package fxp.utils {

    import fxp.core.F;
    import fxp.monads.Maybe;

    public function coreUtils():Object {
        var core:Object = {

            // equals :: a -> a -> Boolean
            equals: F.curry(function(a:*, b:*):Boolean {
                return a === b;
            }),

            // isNativeType :: a -> Boolean
            isNativeType: function(data:*):Boolean {
                return typeof data == "number" ||
                    typeof data == "string" ||
                    typeof data == "boolean";
            }
        }
        return core;
    }
}
// vim: ts=4:sw=4:et: