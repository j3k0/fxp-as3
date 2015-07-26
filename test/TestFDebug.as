package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestFDebug {

        public static function run():void {

            assert.test("F.debug.stringify");
            assert("null", "null" === F.debug.stringify(null));
            assert("true", "true" === F.debug.stringify(true));
            assert("str", "\"str\"" === F.debug.stringify("str"));
            assert("stringify", "test" === F.debug.stringify({ stringify: function():String { return("test"); }}));

            assert.test("F.debug.trace");
            F.debug.dtrace = function(...args):void {}
            assert("generates a function", typeof F.debug.trace("test") === "function");
            assert("of arity 1", F.debug.trace("test").length === 1);
            assert("return", F.debug.trace("test")(123) === 123);
        }
    }
}
// vim: ts=4:sw=4:et:

