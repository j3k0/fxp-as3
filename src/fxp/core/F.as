package fxp.core {

    import fxp.monads.*;

    public class F {

        public static function fxpInit():void {
            F.object = objectUtils();
            F.array = arrayUtils();
            F.string = stringUtils();
        }

        // debug :: String -> (a -> a)
        // Return a function that'll log and return whatever data
        public static function debug(name:String):Function {
            return function(o:*):* {
                trace("F.debug [" + name + "] " + o);
                return o;
            }
        }

        // Return a partially applied function
        public static const partial:Function = function(func:Function, ...boundArgs):Function {
            var ret:Function = function(...dynamicArgs):* {
                var arity:int = func.length;
                var args:Array = boundArgs.concat(dynamicArgs);
                if (arity > 0)
                    args = args.slice(0, arity);
                return func.apply(null, args);
            }
            // Keep the arity of the partial function
            return functionWithArity(ret, func.length - boundArgs.length);
        }

        // Return a curried function
        public static const curry:Function = function(func:Function):Function {
            var arity:int = func.length;
            var currying:Function = function(func:Function, arity:int, args:Array):* {
                return function(... moreArgs:Array):* {
                    var newArgs:Array = args.concat(moreArgs);
                    var ret:* = undefined;
                    if (newArgs.length < arity) {
                        ret = functionWithArity(currying(func, arity, newArgs),
                                                arity - newArgs.length);
                    }
                    else {
                        if (arity > 0)
                            newArgs = newArgs.slice(0, arity)
                        ret = func.apply(this, newArgs);
                    }
                    return ret;
                }
            }
            return functionWithArity(currying(func, arity, []), arity);
        }

        // Combine multiple function together
        public static const combine:Function = function(...func):Function {
            var ret:Function = function(...dynamicArgs):* {
                var data:* = func[func.length - 1].apply(null, dynamicArgs);
                for (var i:int = func.length - 2; i >= 0; --i) {
                    data = func[i](data);
                }
                return data;
            };
            // Keep the arity information (equals last function arity)
            return functionWithArity(ret, func[func.length - 1].length);
        }

        // Dynamic number of arguments function will lose the arity information
        // This "ugly" trick will allow to create functions for which AS3 will
        // have a know arity (works for 0 <= arity <= 9).
        public static const functionWithArity:Function = function(f:Function, arity:int):Function {
            switch(arity) {
                case 1: return function a1(a:*):* { return f.apply(this, arguments); };
                case 2: return function a2(a:*,b:*):* { return f.apply(this, arguments); };
                case 3: return function a3(a:*,b:*,c:*):* { return f.apply(this, arguments); };
                case 4: return function a4(a:*,b:*,c:*,d:*):* { return f.apply(this, arguments); };
                case 5: return function a5(a:*,b:*,c:*,d:*,e:*):* { return f.apply(this, arguments); };
                case 6: return function a6(a:*,b:*,c:*,d:*,e:*,f:*):* { return f.apply(this, arguments); };
                case 7: return function a7(a:*,b:*,c:*,d:*,e:*,f:*,g:*):* { return f.apply(this, arguments); };
                case 8: return function a8(a:*,b:*,c:*,d:*,e:*,f:*,g:*,h:*):* { return f.apply(this, arguments); };
                case 9: return function a9(a:*,b:*,c:*,d:*,e:*,f:*,g:*,h:*,i:*):* { return f.apply(this, arguments); };
            }
            return function a0(...args):* { return f.apply(this, args); };
        }

        public static const map:Function = function(f:Function, m:* = undefined):* {
            if (m == undefined) {
                return function(m:*):* {
                    return m.map(f);
                }
            }
            else {
                return m.map(f);
            }
        }

        public static const flip:Function = function(f:Function):Function {
            return curry(function(a:*, b:*):* {
                return f(b, a);
            });
        }

        public static const call:Function = function(f:Function, data:*):* { return f(data); }
        public static const rcall:Function = F.flip(F.call);

        public static const join:Function = function(m:*):* { return m.join(); }
        public static const chain:Function = function(f:Function, m:* = undefined):* {
            if (m == undefined) {
                return function(m:*):* {
                    return m.chain(f);
                }
            }
            else {
                return m.chain(f);
            }
        }

        public static const maybe:Function = function(x:*, f:Function):* {
            return function(m:Maybe):* {
                return m.maybe(x, f);
            }
        }

        // Utility functions that applies to Objects
        public static var object:Object = null;

        // Utility functions that applies to Arrays
        public static var array:Object = null;

        // Utility functions that applies to Strings
        public static var string:Object = null;
    }
}

import fxp.core.F;
import fxp.monads.*;

function objectUtils():Object {
    var object:Object = {

        // haz :: String -> Object -> Maybe[Object]
        haz: F.curry(function(field:String, data:Object):Maybe {
            return (data && data[field] !== undefined)
                ? Maybe.of(data)
                : Maybe.of(undefined);
        }),

        // deepHaz :: Array[a] -> Object -> Maybe[Object]
        //
        // Examples:
        // deepHaz("a.b.c", { a: { b: { c: "yes" } } }) -> yes
        // deepHaz("a.b.c", { a: { b: { c: false } } }) -> yes
        // deepHaz("a.b.c", { a: { b: {} } }) -> no
        deepHaz: F.curry(function(def:String, data:Object):Maybe {

            const headHaz:Function = F.curry(function(data:Object, arr:Array):Maybe {
                return F.array.headMap(F.object.haz, arr).chain(F.rcall(data));
            });
            const joinTail:Function = F.combine(F.join, F.map(F.array.join(".")), F.array.tail);

            const tokens:Maybe = F.string.split(".", def);
            const child:Object = tokens.chain(F.array.head).chain(F.flip(F.object.prop)(data)).join();
            return (
                tokens.no() || (
                    tokens.chain(headHaz(data)).yes()
                    && tokens.map(joinTail).chain(F.flip(F.object.deepHaz)(child)).yes()
                )
            )
            ? Maybe.of(data)
            : Maybe.of(undefined)
        }),

        // prop :: String -> Object -> Maybe[*]
        prop: F.curry(function(field:String, data:Object):Maybe {
            return object.haz(field, data).map(function(data:Object):* {
                return data[field];
            });
        })
    }
    return object;
}

function arrayUtils():Object { return {

    // join :: String -> Array -> String
    join: F.curry(function(sep:String, arr:Array):String {
        return arr.join(sep);
    }),

    // head :: Array[a] -> Maybe[a]
    head: function(arr:Array):Maybe {
        return arr && arr.length > 0
            ? Maybe.of(arr[0])
            : Maybe.of(undefined);
    },

    // head :: Array[a] -> Maybe[Array[a]]
    tail: function(arr:Array):Maybe {
        return arr && arr.length > 0
            ? Maybe.of(arr.slice(1))
            : Maybe.of(undefined);
    },

    // headMap :: (a -> *) -> Array[a] -> Maybe[*]
    headMap: F.curry(function(f:Function, arr:Array):Maybe {
        return F.array.head(arr).map(f);
    })
}}

function stringUtils():Object { return {

    // split :: String -> String -> Array
    split: F.curry(function(separator:String, str:String):Maybe {
        if (!str) return Maybe.of(undefined);
        const tokens:Array = str.split(separator);
        if (tokens.length === 0) return Maybe.of(undefined);
        return Maybe.of(tokens);
    })
}}

// vim: ts=4:sw=4:et:
