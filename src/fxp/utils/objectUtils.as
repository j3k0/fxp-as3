package fxp.utils {

    import fxp.core.F;
    import fxp.monads.*;

    public function objectUtils():Object {
        var object:Object = {

            // haz :: String -> Object -> Boolean
            haz: F.curry(function(field:String, data:Object):Boolean {
                return (!F.utils.isNativeType(data) && data && data[field] !== undefined);
            }),

            // deepHaz :: Array[a] -> Object -> Boolean
            //
            // Examples:
            // deepHaz("a.b.c", { a: { b: { c: "yes" } } }) -> true
            // deepHaz("a.b.c", { a: { b: { c: false } } }) -> true
            // deepHaz("a.b.c", { a: { b: {} } }) -> false
            deepHaz: F.curry(function(def:String, data:Object):Boolean {

                const headHaz:Function = F.curry(function(data:Object, arr:Array):Boolean {
                    return F.array.headMap(F.object.haz, arr).map(F.rcall(data)).isTrue();
                });
                const joinTail:Function = F.combine(F.join, F.map(F.array.join(".")), F.array.tail);

                const tokens:Maybe = F.string.split(".", def);
                const child:Object = tokens.chain(F.array.head).chain(F.flip(F.object.prop)(data)).maybe(null, F.id);
                return tokens.no() || (
                    tokens.map(headHaz(data)).isTrue()
                    && tokens.map(joinTail).map(F.flip(F.object.deepHaz)(child)).isTrue()
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


