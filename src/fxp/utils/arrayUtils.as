package fxp.utils {

    import fxp.core.*;
    import fxp.monads.*;

    public function arrayUtils():Object {

        var array:Object = {};

        // ofVector :: Iterable[a] -> Array[a]
        array.ofVector = function(v:*):Array {
            var arr:Array = [];
            for each (var e:* in v)
                arr[arr.length] = e;
            return arr;
        };

        // map :: (a -> b) -> Array[a] -> Array[b]
        // TODO: test & document
        array.map = F.curry(function(f:Function, arr:Array):Array {
            return arr.map(function(item:*, index:int, array:Array):* {
                return f(item);
            });
        });

        // every :: (a -> Boolean) -> Array[a] -> Boolean
        // TODO: test & document
        array.every = F.curry(function(f:Function, arr:Array):Boolean {
            return arr.every(function(item:*, index:int, array:Array):Boolean {
                return f(item);
            });
        });

        // some :: (a -> Boolean) -> Array[a] -> Boolean
        // TODO: test & document
        array.some = F.curry(function(f:Function, arr:Array):Boolean {
            return arr.some(function(item:*, index:int, array:Array):Boolean {
                return f(item);
            });
        });

        // filter :: (a -> Boolean) -> Array[a] -> Array[a]
        // TODO: test & document
        array.filter = F.curry(function(f:Function, arr:Array):Array {
            return arr.filter(function(item:*, index:int, array:Array):Boolean {
                return f(item);
            });
        });

        // TODO: test & document
        array.concat2 = F.curry(function(a1:Array, a2:*):Array { return a1.concat(a2); });
        array.concat3 = F.curry(function(a1:Array, a2:*, a3:*):Array { return a1.concat(a2, a3); });
        array.concat4 = F.curry(function(a1:Array, a2:*, a3:*, a4:*):Array { return a1.concat(a2, a3, a4); });
        array.concat5 = F.curry(function(a1:Array, a2:*, a3:*, a4:*, a5:*):Array { return a1.concat(a2, a3, a4, a5); });
        array.concat6 = F.curry(function(a1:Array, a2:*, a3:*, a4:*, a5:*, a6:*):Array { return a1.concat(a2, a3, a4, a5, a6); });
        array.concat7 = F.curry(function(a1:Array, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*):Array { return a1.concat(a2, a3, a4, a5, a6, a7); });
        array.concat8 = F.curry(function(a1:Array, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*, a8:*):Array { return a1.concat(a2, a3, a4, a5, a6, a7, a8); });
        array.concat9 = F.curry(function(a1:Array, a2:*, a3:*, a4:*, a5:*, a6:*, a7:*, a8:*, a9:*):Array { return a1.concat(a2, a3, a4, a5, a6, a7, a8, a9); });
        array.concat = array.concat2;

        // join :: String -> Array -> String
        // TODO: test
        array.join = F.curry(function(sep:String, arr:Array):String {
            return arr.join(sep);
        });

        // head  =: Array[a] -> Maybe[a]
        // TODO: document
        array.head = function(arr:Array):Maybe {
            return arr && arr.length > 0
                ? Maybe.of(arr[0])
                : Maybe.of(undefined);
        };

        // tail :: Array[a] -> Maybe[Array[a]]
        array.tail = function(arr:Array):Maybe {
            return arr && arr.length > 0
                ? Maybe.of(arr.slice(1))
                : Maybe.of(undefined);
        };

        // headMap :: (a -> *) -> Array[a] -> Maybe[*]
        // TODO: test
        array.headMap = F.curry(function(f:Function, arr:Array):Maybe {
            return F.array.head(arr).map(f);
        });

        // of :: ...* -> Array[*]
        array.of = function(...args):Array {
            return array.concat([], args);
        };

        // reduce :: (T, U -> T) -> T -> Array[U] -> T
        array.reduce = F.curry(function(f:Function, initial:*, arr:Array):* {
            if (!arr || arr.length === 0) {
                return initial;
            }
            else {
                var acc:* = initial;
                for (var i:int = 0; i < arr.length; ++i)
                    acc = f(acc, arr[i]);
                return acc;
            }
        });

        // TODO: test & document
        array.foldL = F.curry(function(f:Function, arr:Array):* {
            if (!arr || arr.length === 0) {
                return undefined;
            }
            else {
                var acc:* = arr[0];
                for (var i:int = 1; i < arr.length; ++i)
                    acc = f(acc, arr[i]);
                return acc;
            }
        });

        // foldR :: (a -> b -> c) -> Array(a, a, ..., a, a, b) -> c
        // TODO: test & document
        array.foldR = F.curry(function(f:Function, arr:Array):* {
            if (!arr || arr.length === 0) {
                return undefined;
            }
            else {
                var acc:* = arr[arr.length - 1];
                for (var i:int = arr.length - 2; i >=0 ; --i)
                    acc = f(arr[i], acc);
                return acc;
            }
        });

        // mapEach :: Array[X -> Y] -> Array[X] -> Array[Y]
        // TODO: test & document
        array.mapEach = F.curry(function(func:Array, arr:Array):Array {
            var ret:Array = [];
            for (var i:int = 0, l:int = func.length; i < l; ++i)
                ret.push(func[i](arr[i]));
            return ret;
        });

        // mapEachArgs :: Array[* -> *] -> ...* -> Array[*]
        // TODO: document
        array.mapEachArgs = function(func:Array):Function {
            return F.functionWithArity(function(...args):Array {
                return array.mapEach(func, args);
            }, func.length);
        };

        // mapApply :: Array[(z -> y), ..., (b -> c), (a -> b), M(a)] -> M(z)
        // TODO: document
        array.mapApply = array.foldR(F.map);

        // mapApplyEach :: Array[a -> (b -> c), d -> M(b)] -> Array[a, d] -> M(c)
        // TODO: test & document
        array.mapApplyEach = F.combine(array.mapApply, array.mapEach);

        // mapApplyEachArgs :: Array[a -> (b -> c), d -> M(b)] -> a -> d -> M(c)
        // TODO: test & document
        array.mapApplyEachArgs = F.curry(function(func:Array, a:*, b:*):* {
            return array.mapApplyEach(func, [a, b]);
        });

        // has :: a -> Array[a] -> Boolean
        // TODO: document
        array.has = F.curry(function(value:*, arr:Array):Boolean {
            return array.some(F.utils.equals(value), arr);
        });

        // toArray :: Iterable<T> -> Array<T>
        // TODO: test & document
        array.ofIterable = function(iterable:*):Array {
            var ret:Array = [];
            for each (var elem:* in iterable) ret.push(elem);
            return ret;
        }

        // mapRange :: Int -> (Int -> T) -> Array<T>
        // TODO: test & document
        array.mapRange = F.curry(function(max:int, func:Function):Array {
            var ret:Array = [];
            for (var i:int = 0; i < max; ++i)
                ret.push(func(i));
            return ret;
        });

        // forRange :: Int -> (Int -> _) -> _
        // TODO: test & document
        array.forRange = F.curry(function(max:int, func:Function):void {
            for (var i:int = 0; i < max; ++i)
                func(i);
        });

        // forRange :: Int -> (Int -> _) -> _
        // TODO: test & document
        array.forEach = F.curry(function(func:Function, arr:Array):Array {
            for (var i:int = 0; i < arr.length; ++i)
                func(arr[i]);
            return arr;
        });

        // equals :: Array<T> -> Array<T> -> Boolean
        // TODO: test & document
        array.equals = F.curry(function(a:Array, b:Array):Boolean {
            const sameAsA:Function = function(value:*, index:int, _:Array):Boolean {
                return value == a[index];
            };
            return (b.length == a.length) && b.every(sameAsA);
        });

        return array;
    }
}
// vim: ts=4:sw=4:et:
