package fxp.utils {

    import fxp.core.F;
    import fxp.monads.Maybe;

    public function objectUtils():Object {
        var object:Object = {

            // prop :: String -> Object -> Maybe[*]
            prop: F.curry(function(field:String, data:*):Maybe {
                return F.object.haz(field, data)
                    ? Maybe.of(data[field])
                    : Maybe.of();
            }),

            // deepPropWithArray :: Array[String] -> Object -> Maybe[*]
            deepPropWithArray: F.curry(function(path:Array, data:Object):Maybe {
                const child:Maybe = F.array.head(path).chain(F.flip(F.object.prop)(data));
                return (path.length <= 0
                    ? Maybe.of(data)
                    : child.chain(F.object.deepPropWithArray(F.array.tail(path).maybe(null, F.id))));
            }),

            // deepPropWithString :: String -> Object -> Maybe[*]
            deepPropWithString: F.curry(function(path:String, data:Object):Maybe {
                return F.object.deepPropWithArray(path.split("."), data);
            }),

            // deepProp :: (Array[String] | String) -> Object -> Maybe[*]
            deepProp: F.curry(function(path:*, data:Object):Maybe {
                return (typeof path === "string"
                    ? F.object.deepPropWithString
                    : F.object.deepPropWithArray)(path, data);
            }),

            // haz :: String -> Object -> Boolean
            haz: F.curry(function(field:String, data:Object):Boolean {
                return (!F.utils.isNativeType(data) && data && data[field] !== undefined);
            }),

            // deepHazWithArray :: Array[String] -> Object -> Boolean
            deepHazWithArray: F.curry(function(path:Array, data:Object):Boolean {
                const child:Object = F.array.head(path).chain(F.flip(F.object.prop)(data)).maybe(null, F.id);
                return (path.length === 0) || (
                       F.array.head(path).map(F.object.haz).map(F.rcall(data)).isTrue()
                    && F.array.tail(path).map(F.flip(F.object.deepHazWithArray)(child)).isTrue()
                );
            }),

            // deepHazWithString :: String -> Object -> Boolean
            deepHazWithString: F.curry(function(path:String, data:Object):Boolean {
                return F.object.deepHazWithArray(path.split("."), data);
            }),

            // deepHaz :: (Array[String] | String) -> Object -> Boolean
            //
            // Examples:
            // deepHaz(["a", "b", "c"], { a: { b: { c: "yes" } } }) -> true
            // deepHaz(["a", "b", "c"], { a: { b: { c: false } } }) -> true
            // deepHaz(["a", "b", "c"], { a: { b: {} } }) -> false
            // deepHaz("a.b.c", { a: { b: { c: "yes" } } }) -> true
            deepHaz: F.curry(function(path:*, data:Object):Boolean {
                return !F.object.deepProp(path, data).isNothing();
                //return (typeof path === "string"
                //    ? object.deepHazWithString
                //    : object.deepHazWithArray)(path, data);
            })
        }
        return object;
    }
}
// vim: ts=4:sw=4:et:


