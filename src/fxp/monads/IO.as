package fxp.monads {

    import fxp.core.F;

    public class IO {

        private var _performIO:Function;

        public function get perform():Function { return _performIO; }

        public function IO(f:Function) {
            _performIO = f;
        }
        public static function of(v:*):IO {
            return new IO(function():* { return v; });
        }

        public static function ofIOArray(ioArray:Array):IO {
            return new IO(function():* { return utils.performArray(ioArray); });
        }

        public function map(f:Function):* {
            return new IO(function():* { return f(perform()); });
        }

        public function chain(f:Function):* {
            return new IO(function():* { return f(perform()).perform(); });
        }

        public function join():IO { return perform(); }

        public function stringify():String {
            return "IO(?)";
        }

        public static const utils:Object = {
            // TODO: document
            perform: function(io:IO):* {
                return io.perform();
            },

            // TODO: document
            performArray: function(ioArray:Array):Array {
                return F.array.map(utils.perform, ioArray);
            },

            // TODO: document
            setProp: F.IO(function(name:String, value:*, obj:*):* {
                obj[name] = value;
                return obj;
            })

        }
    }
}
