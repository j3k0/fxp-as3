package fxp.monads {

    import fxp.core.F;

    public class Reader {

        private var f:Function;

        // TODO: document
        public function Reader(fn:Function) {
            init(fn);
        }

        // TODO: document
        public static function of(x:*):Reader {
            return new Reader(function(...args):* {
                return x;
            });
        }

        // TODO: test & document
        public static function ask():Reader {
            return new Reader(F.id);
        }

        // TODO: test & document
        public function init(fn:Function):void {
            this.f = fn;
        }

        // TODO: test & document
        public function run(config:*):* {
            return this.f(config);
        }

        // TODO: test & document
        public function chain(fn:Function):Reader {
            var that:Reader = this;
            return new Reader(function(config:*):* {
                return fn(that.run(config)).run(config);
            });
        }

        // TODO: test & document
        public function ap(readerWithFn:Reader):Reader {
            var that:Reader = this;
            return readerWithFn.chain(function(fn:Function):Reader {
                return Reader(function(config:*):* {
                    return fn(that.run(config));
                });
            });
        }

        // TODO: test & document
        public function map(fn:Function):Reader {
            var that:Reader = this;
            return new Reader(function(config:*):* {
                return fn(that.run(config));
            });
        }

        // TODO: test & document
        public function local(fn:*):Reader {
            var that:Reader = this;
            return new Reader(function(c:*):* {
                return that.run(fn(c));
            });
        }

        // TODO: test & document
        public function stringify():String {
            return "Reader(" + (typeof f) + ")";
        }
    }
}
// vim: ts=4:sw=4:et:
