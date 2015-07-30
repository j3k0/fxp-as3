package fxp.utils {

    import fxp.core.*;
    import fxp.monads.*;

    public function arrayUtils():Object {

        var array:Object = {};

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

        // mapEach :: Array[X -> Y] -> Array[X] -> Array[Y]
        // TODO: test & document
        array.mapEach = F.curry(function(func:Array, arr:*):Array {
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
        array.mapApply = function(arr:Array):* {
            if (!arr || arr.length === 0)
                return undefined;
            else {
                var base:* = arr[arr.length - 1];
                for (var i:int = arr.length - 2; i >=0 ; --i)
                    base = base.map(arr[i]);
                return base;
            }
        };

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

        return array;
    }
}
// vim: ts=4:sw=4:et:
