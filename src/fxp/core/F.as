package fxp.core {

    import fxp.monads.*;
    import fxp.utils.*;

    public class F {

        public static function fxpInit():void {
            F.utils = coreUtils();
            F.object = objectUtils();
            F.array = arrayUtils();
            F.string = stringUtils();
            F.debug = debugUtils();
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

        public static const call0:Function = function(f:Function):* { return f(); }
        public static const call1:Function = curry(function(f:Function, a1:*):* { return f(a1); });
        public static const call2:Function = curry(function(f:Function, a1:*, a2:*):* { return f(a1, a2); });
        public static const call3:Function = curry(function(f:Function, a1:*, a2:*, a3:*):* { return f(a1, a2, a3); });
        public static const call4:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*):* { return f(a1, a2, a3, a4); });
        public static const call5:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*, a5:*):* { return f(a1, a2, a3, a4, a5); });
        public static const call6:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*, a5:*, a6:*):* { return f(a1, a2, a3, a4, a5, a6); });
        public static const call7:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*):* { return f(a1, a2, a3, a4, a5, a6, a7); });
        public static const call8:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*, a8:*):* { return f(a1, a2, a3, a4, a5, a6, a7, a8); });
        public static const call9:Function = curry(function(f:Function, a1:*, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*, a8:*, a9:*):* { return f(a1, a2, a3, a4, a5, a6, a7, a8, a9); });

        public static const call:Function = call1;
        public static const rcall:Function = flip(call);

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

        public static function id(x:*):* { return x; }

        // Core utils
        public static var utils:Object = null;

        // Debug utils
        public static var debug:Object = null;

        // Utility functions that applies to Objects
        public static var object:Object = null;

        // Utility functions that applies to Arrays
        public static var array:Object = null;

        // Utility functions that applies to Strings
        public static var string:Object = null;
    }
}

// vim: ts=4:sw=4:et:
