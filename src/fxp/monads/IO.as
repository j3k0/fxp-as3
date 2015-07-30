package fxp.monads {

    import fxp.core.F;

    public class IO {

        private var _performIO:Function;

        // TODO: document
        public function get perform():Function { return _performIO; }

        // TODO: document
        public function IO(f:Function) {
            _performIO = f;
        }
        // TODO: document
        public static function of(v:*):IO {
            return new IO(function():* { return v; });
        }

        // TODO: document
        public function map(f:Function):* {
            return new IO(function():* { return f(perform()); });
        }

        // TODO: document
        public function chain(f:Function):* {
            return new IO(function():* { return f(perform()).perform(); });
        }

        // TODO: document
        public function join():IO { return perform(); }

        public function stringify():String {
            return "IO(?)";
        }
    }
}
