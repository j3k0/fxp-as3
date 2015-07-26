package fxp.utils {

    import fxp.core.F;
    import fxp.monads.*;

    public function stringUtils():Object {
        var string:Object = {

            // split :: String -> String -> Array
            split: F.curry(function(separator:String, str:String):Maybe {
                if (!str) return Maybe.of(undefined);
                const tokens:Array = str.split(separator);
                if (tokens.length === 0) return Maybe.of(undefined);
                return Maybe.of(tokens);
            })
        }
        return string;
    }
}
// vim: ts=4:sw=4:et:
