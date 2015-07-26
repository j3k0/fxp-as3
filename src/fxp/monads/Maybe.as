package fxp.monads {

    // Maybe Funktor
    public class Maybe {

        private var value:*;

        public function Maybe(v:*) { value = v; }
        public static function of(v:*):Maybe { return new Maybe(v); }

        public function isNothing():Boolean {
            return value === undefined;
        }
        public function no():Boolean  { return isNothing(); }
        public function yes():Boolean { return !isNothing(); }

        public function map(f:Function):* {
            return isNothing() ? Maybe.of(undefined) : Maybe.of(f(value));
        }

        public function chain(f:Function):Maybe {
            return isNothing() ? Maybe.of(undefined) : f(value);
        }

        public function join():* {
            return value;
        }

        public function maybe(x:*, f:Function):* {
            return isNothing() ? x : f(value);
        }

        public function toString():String {
            return "Maybe(" + JSON.stringify(value) + ")";
        }
    }
}
