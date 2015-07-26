package fxp.utils {

    import fxp.core.*;
    import fxp.monads.*;

    public function arrayUtils():Object {

        var array:Object = {
            
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
        }
        return array;
    }
}
// vim: ts=4:sw=4:et:

