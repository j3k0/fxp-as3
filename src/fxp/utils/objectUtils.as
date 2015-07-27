package fxp.utils {

    import fxp.core.F;
    import fxp.monads.Maybe;

    public function objectUtils():Object {
        var object:Object = {

            // haz :: String -> Object -> Boolean
            haz: F.curry(function(field:String, data:Object):Boolean {
                return (!F.utils.isNativeType(data) && data && data[field] !== undefined);
            }),

            // deepHaz :: Array[String] -> Object -> Boolean
            //
            // Examples:
            // deepHaz(["a", "b", "c"], { a: { b: { c: "yes" } } }) -> true
            // deepHaz(["a", "b", "c"], { a: { b: { c: false } } }) -> true
            // deepHaz(["a", "b", "c"], { a: { b: {} } }) -> false
            deepHaz: F.curry(function(path:Array, data:Object):Boolean {
                const child:Object = F.array.head(path).chain(F.flip(F.object.prop)(data)).maybe(null, F.id);
                return (path.length === 0) || (
                       F.array.head(path).map(F.object.haz).map(F.rcall(data)).isTrue()
                    && F.array.tail(path).map(F.flip(F.object.deepHaz)(child)).isTrue()
                );
            }),

            // prop :: String -> Object -> Maybe[*]
            prop: F.curry(function(field:String, data:*):Maybe {
                return object.haz(field, data)
                    ? Maybe.of(data[field])
                    : Maybe.of();
            })
        }
        return object;
    }
}
// vim: ts=4:sw=4:et:


