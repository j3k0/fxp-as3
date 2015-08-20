package fxp.core {

    import fxp.monads.Reader;
    import fxp.monads.Maybe;
    import fxp.monads.IO;
    import fxp.utils.*;

    import flash.utils.getQualifiedClassName;

    public class F {

        // Initialize the fxp library
        //
        // note: I tried using "F.once" for this, however once isn't initialized
        // before fxpInit, and I wouldn't assume it will.
        private static var initialized:Boolean = false;
        public static function fxpInit():void {
            if (initialized) return;
            initialized = true;
            F.debug = debugUtils();
            F.object = objectUtils();
            F.utils = coreUtils();
            F.array = arrayUtils();
            F.string = stringUtils();
        }

        // Identify function
        public static function id(x:*):* { return x; }

        // Dynamic number of arguments function will lose the arity information
        // This "ugly" trick will allow to create functions for which AS3 will
        // have a know arity (works for 0 <= arity <= 9).
        public static function functionWithArity(f:Function, arity:int):Function {
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
        public static const bind:Function = partial;

        // Return a curried function
        public static const curry:Function = function(func:Function, arity:int = -1):Function {
            if (arity < 0) arity = func.length;
            // var arity:int = func.length;
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
            if (func.length === 1 && typeof func[0] !== 'function')
                return combineArray(func[0]);
            else
                return combineArray(func);
        }

        // Combine multiple function together
        public static const combineArray:Function = function(func:*):Function {
            var ret:Function = function(...dynamicArgs):* {
                var data:* = func[func.length - 1].apply(null, dynamicArgs);
                for (var i:int = func.length - 2; i >= 0; --i) {
                    data = func[i](data);
                }
                return data;
            };
            // Keep the arity information (equals last function arity)
            return curry(functionWithArity(ret, func[func.length - 1].length));
        }

        public static const compose:Function = combine;
        public static const composeArray:Function = combineArray;

        // (a -> b) -> M(a) -> M(b)
        public static const map:Function = curry(function(f:Function, m:*):* {
            return m.map(f);
        });

        // M(M(a)) -> M(a)
        public static const join:Function = function(m:*):* { return m.join(); }

        // (a -> M(b)) -> M(a) -> M(b)
        public static const chain:Function = curry(function(f:Function, m:*):* {
            return m.chain(f);
        });

        // (a -> b) -> (b -> a)
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

        // TODO: test & document
        public static function once(f:Function):Function {
            var called:Boolean = false;
            var ret:*;
            return functionWithArity(function(...dynamicArgs):* {
                if (!called) {
                    ret = f.apply(this, dynamicArgs);
                    called = true;
                }
                return ret;
            }, f.length);
        }

        // (a -> b) -> M(a) -> M(b)
        public static const liftM1:Function = curry(function(f:Function, m1:*):* {
            return m1.map(f);
        });

        // (a -> b -> c) -> M(a) -> M(b) -> M(c)
        public static const liftM2:Function = curry(function(f:Function, m1:*, m2:*):* {
            return m1.map(curry(f)).chain(flip(map)(m2));
        });

        // TODO: test & document
        public static function parallel(funcs:Array):Function {
            var arity:int = funcs.length > 0 ? funcs[0].length : 0;
            return functionWithArity(function(...args):* {
                return funcs.map(function(f:Function):* {
                    return f.apply(this, args);
                });
            }, arity);
        }

        // TODO: document
        public static function IO(f:Function):Function {
            return curry(function(...args):fxp.monads.IO {
                return new fxp.monads.IO(function():* {
                    return f.apply(this, args);
                });
            }, f.length);
        }

        public static function Reader(fn:Function):Function {
            return F.functionWithArity(function(...args):fxp.monads.Reader {
                return new fxp.monads.Reader(function(config:*):* {
                    return fn.apply(this, args.concat(config));
                });
            }, fn.length - 1);
        }

        public static function renameType(t:String):String {
            if (t == "int") return "Number";
            else return t;
        }

        // TODO: test & document
        public static function fromJSON(argsDef:Object, T:Class):Function {
            return function(args:Object):* {
                var ret:* = new T();
                for (var k:String in argsDef) {
                    if (argsDef[k] === Function) {
                        if (typeof args[k] !== 'function')
                            throw new Error("Wrong type for '" + k + "'. Expected:'function' Got:'" + typeof(args[k]) + "'");
                    }
                    else if (renameType(getQualifiedClassName(args[k])) !== renameType(getQualifiedClassName(argsDef[k])))
                        throw new Error("Wrong type for '" + k + "'. Expected:'" + getQualifiedClassName(argsDef[k]) + "' Got:'" + getQualifiedClassName(args[k]) + "'");
                    ret[k] = args[k];
                }
                return ret;
            }
        }

        // Returns a function with a dynamic number of arguments
        // that is gonna call `fn` with the right number of args,
        // dicarding any extraneous ones.
        public static function ignoreArity(fn:Function):Function {
            return function(...args):* {
                return fn.apply(this, args.slice(0, fn.length));
            };
        }

        // Return a function that will behave externally exactly like f,
        // It will call and return the value of f().
        //
        // But transparently call also the attached functions with the
        // same arguments.
        //
        // note: attached functions can have less arguments than the
        // master function. Extra args will be ignored.
        //
        // ...(...args -> T) -> ...args -> T
        public static function attach(f:Function, ...thenAlso):Function {
            return F.curry(functionWithArity(function(...args):* {
                var ret:* = f.apply(null, args);
                thenAlso.forEach(function(fb:Function, ...ignored):void {
                    fb.apply(this, args.slice(0, fb.length));
                });
                return ret;
            }, f.length));
        }

        // Return a function that returns a monad that shows the same
        // properties as f's returned monad.
        //
        // But transparently it'll chain extra functions, called with the
        // same arguments.
        //
        // Attached functions can have less arguments than the
        // master function. Extra args will be ignored.
        //
        // ...(...args -> M<T>) -> ...args -> M<T>
        public static function attachChain(f:Function, ...thenAlso):Function {
            return F.curry(functionWithArity(function(...args):* {
                var ret:* = null;
                var monad:* = f.apply(null, args);
                monad = monad.map(function(v:*):* {
                    return ret = v;
                });
                thenAlso.forEach(function(fb:Function, ...ignored):void {
                    monad = monad.chain(function(v:*):* {
                        return fb.apply(this, args.slice(0, fb.length));
                    });
                });
                monad = monad.map(function(v:*):* {
                    return ret;
                });
                return monad;
            }, f.length));
        }

        // (...args -> M<T>) -> (T -> M<U>) -> ... -> (Y -> M<Z>) -> (...args -> M<Z>)
        public static function doChain(f:Function, ...thenAlso):Function {
            return functionWithArity(function(...args):* {
                var m:* = f.apply(this, args);
                thenAlso.forEach(function(fb:Function, ...ignored):void {
                    m = m.chain(fb);
                });
                return m;
            }, f.length);
        }

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
