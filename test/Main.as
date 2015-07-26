package
{
    import fxp.core.F;
    import fxp.monads.*;
    import flash.display.Sprite;
    import flash.desktop.NativeApplication;

    public class Main extends Sprite
    {
        public function testFDebug():void {
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

        public function testFObject():void {
            assert.test("F.object.haz");
            assert("1", !F.object.haz("a", 1));
            assert("null", !F.object.haz("a", null));
            assert("a:true", F.object.haz("a", { a: true}));
            assert("a:false", F.object.haz("a", { a: false }));
            assert("a:null", F.object.haz("a", { a: null }));
            assert("{}", !F.object.haz("a", { }));

            assert.test("F.object.prop");
            assert("a:true", F.object.prop("a", { a :true }).yes());
            assert("a:false", F.object.prop("a", { a: false }).yes());
            assert("a:null", F.object.prop("a", { a: null }).yes());
            assert("{}", F.object.prop("a", {}).no());

            assert.test("F.object.deepHaz");
            assert('"yes"', F.object.deepHaz("push.message", { push: { message: "yes" } }));
            assert("false", F.object.deepHaz("push.message", { push: { message: false } }));
            assert("passage", !F.object.deepHaz("push.message", { push: { passage: "yes" } }));
            assert("mush", !F.object.deepHaz("push.message", { mush: {} }));
            assert("{}", !F.object.deepHaz("push.message", { }));
            assert("null", !F.object.deepHaz("push.message", null));
            assert('value', true === F.object.deepHaz("a", { a: 12 }));
        }

        public function testFArray():void {
            assert.test("F.array.tail");
            assert("null", F.array.tail(null).no());
            assert("[]", F.array.tail([]).no());
            assert("[a]", 'Maybe([])' === F.array.tail(["a"]).stringify());
            assert("[a,b]", 'Maybe(["b"])' === F.array.tail(["a","b"]).stringify());
            assert("[a,b,c]", 'Maybe(["b","c"])' === F.array.tail(["a","b","c"]).stringify());
        }

        public function Main():void
        {
            F.fxpInit();

            try {
                testFDebug();
                TestMaybe.run();
                testFObject();
                testFArray();
                assert.finish();
                NativeApplication.nativeApplication.exit(0);
            }
            catch(err:Error) {
                trace(err.getStackTrace());
                NativeApplication.nativeApplication.exit(1);
            }

        }
    }
}
// vim: ts=4:sw=4:et:
