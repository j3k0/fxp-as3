package fxp.monads {

    import fxp.core.F;

    // Maybe Funktor
    public class Maybe {

        private var value:*;
        public static const NOTHING:* = undefined;

        public function Maybe(v:* = undefined) {
            value = v;
        }
        public static function of(v:* = undefined):Maybe {
            return new Maybe(v);
        }

        public function isNothing():Boolean {
            return value === undefined;
        }
        public function no():Boolean  { return isNothing(); }
        public function yes():Boolean { return !isNothing(); }

        public function map(f:Function):* {
            return isNothing() ? this : Maybe.of(f(value));
        }

        public function chain(f:Function):Maybe {
            return isNothing() ? Maybe.of(undefined) : f(value);
        }

        public function join():* {
            return isNothing() ? this : value;
        }

        public function maybe(x:*, f:Function):* {
            return isNothing() ? x : f(value);
        }

        public function stringify():String {
            return isNothing()
                ? "Maybe()"
                : "Maybe(" + F.debug.stringify(value) + ")";
        }

        public function isTrue():Boolean {
            return maybe(false, F.id) ? true : false;
        }

        public function isFalse():Boolean {
            return !this.isTrue();
        }

        public static const utils:Object = {
            maybe: F.curry(function(x:*, f:Function, m:Maybe):* {
                return m.maybe(x, f);
            }),
            isTrue: function(m:*):Boolean { return m.isTrue(); },
            isFalse: function(m:*):Boolean { return m.isFalse(); }
        }
    }
}
