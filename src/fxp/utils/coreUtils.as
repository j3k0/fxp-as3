package fxp.utils {

    import fxp.core.F;
    import fxp.monads.Maybe;

    public function coreUtils():Object {
        var core:Object = {

            // equals :: a -> a -> Boolean
            equals: F.curry(function(a:*, b:*):Boolean {
                return a === b;
            }),

            // lowerThan :: a -> a -> Boolean
            lowerThan: F.curry(function(a:*, b:*):Boolean {
                return b < a;
            }),
            // lowerEqual :: a -> a -> Boolean
            lowerEqual: F.curry(function(a:*, b:*):Boolean {
                return b <= a;
            }),

            // greaterThan :: a -> a -> Boolean
            greaterThan: F.curry(function(a:*, b:*):Boolean {
                return b > a;
            }),
            // greaterEqual :: a -> a -> Boolean
            greaterEqual: F.curry(function(a:*, b:*):Boolean {
                return b >= a;
            }),

            // selector :: a -> a -> Boolean -> a
            selector: F.curry(function(whenFalse:*, whenTrue:*, test:Boolean):* {
                return test ? whenTrue : whenFalse;
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
