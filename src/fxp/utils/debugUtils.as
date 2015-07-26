package fxp.utils {

    import fxp.core.F;

    public function debugUtils():Object {

        var debug:Object = {

            dtrace: trace,

            // debug :: String -> (a -> a)
            //
            // Return a function that'll trace and return the data
            trace: function(name:String):Function {
                return function(o:*):* {
                    debug.dtrace("F.debug.trace [" + name + "] " + debug.stringify(o));
                    return o;
                }
            },

            // stringify :: a -> String
            stringify: function(o:*):String {
                return F.object.prop("stringify", o).maybe(JSON.stringify(o), F.call0);
            }
        }
        return debug;
    }
}
// vim: ts=4:sw=4:et:
