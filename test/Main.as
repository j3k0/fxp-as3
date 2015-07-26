package
{
    import fxp.core.F;
    import fxp.monads.*;
    import flash.display.Sprite;
	import flash.desktop.NativeApplication;

    public class Main extends Sprite
    {
        public static function test(testName:String):void {
            trace("\n**", testName);
        }

        public function testFDebug():void {
            test("F.debug.stringify");
            assert("null", "null" === F.debug.stringify(null));
            assert("true", "true" === F.debug.stringify(true));
            assert("str", "\"str\"" === F.debug.stringify("str"));
            assert("stringify", "test" === F.debug.stringify({ stringify: function():String { return("test"); }}));

            test("F.debug.trace");
            F.debug.dtrace = function(...args):void {}
            assert("generates a function", typeof F.debug.trace("test") === "function");
            assert("of arity 1", F.debug.trace("test").length === 1);
            assert("return", F.debug.trace("test")(123) === 123);
        }

        public function testFObject():void {
            test("F.object.haz");
            assert("1", !F.object.haz("a", 1));
            assert("null", !F.object.haz("a", null));
            assert("a:true", F.object.haz("a", { a: true}));
            assert("a:false", F.object.haz("a", { a: false }));
            assert("a:null", F.object.haz("a", { a: null }));
            assert("{}", !F.object.haz("a", { }));

            test("F.object.prop");
            assert("a:true", F.object.prop("a", { a :true }).yes());
            assert("a:false", F.object.prop("a", { a: false }).yes());
            assert("a:null", F.object.prop("a", { a: null }).yes());
            assert("{}", F.object.prop("a", {}).no());

            test("F.object.deepHaz");
            assert('"yes"', F.object.deepHaz("push.message", { push: { message: "yes" } }));
            assert("false", F.object.deepHaz("push.message", { push: { message: false } }));
            assert("passage", !F.object.deepHaz("push.message", { push: { passage: "yes" } }));
            assert("mush", !F.object.deepHaz("push.message", { mush: {} }));
            assert("{}", !F.object.deepHaz("push.message", { }));
            assert("null", !F.object.deepHaz("push.message", null));
            assert('value', true === F.object.deepHaz("a", { a: 12 }));
        }

        public function testFArray():void {
            test("F.array.tail");
            assert("null", F.array.tail(null).no());
            assert("[]", F.array.tail([]).no());
            assert("[a]", 'Maybe([])' === F.array.tail(["a"]).stringify());
            assert("[a,b]", 'Maybe(["b"])' === F.array.tail(["a","b"]).stringify());
            assert("[a,b,c]", 'Maybe(["b","c"])' === F.array.tail(["a","b","c"]).stringify());
        }

        public function testMaybe():void {
            test("Maybe.of");
            assert("nothing is nothing",        'Maybe()' === Maybe.of().stringify());
            assert("undefined is nothing",      'Maybe()' === Maybe.of(undefined).stringify());
            assert("null is something (null)",  'Maybe(null)' === Maybe.of(null).stringify());
            assert("false is something (true)", 'Maybe(false)' === Maybe.of(false).stringify());

            test("Maybe.isNothing");
            assert("nothing is nothing",        Maybe.of().isNothing());
            assert("undefined is nothing",      Maybe.of(undefined).isNothing());
            assert("null is something (null)",  !Maybe.of(null).isNothing());
            assert("false is something (true)", !Maybe.of(false).isNothing());

            test("Maybe.yes");
            assert("nothing isn't yes",!Maybe.of().yes());
            assert("something is yes", Maybe.of({}).yes());

            test("Maybe.no");
            assert("nothing is no", Maybe.of().no());
            assert("something isn't no",  !Maybe.of({}).no());

            test("Maybe.map");
            const notCalled:Function = function(x:*):* { throw new Error("Should not be called"); }
            const inverse:Function = function(x:int):int { return -x; }
            assert("nothing -> not called", Maybe.of().map(notCalled).isNothing());
            assert("something -> called", 'Maybe(-12)' === Maybe.of(12).map(inverse).stringify());
            trace(Maybe.of(1).map(Maybe.of).stringify());
            assert("map 2 Maybe", 'Maybe(Maybe(1))' === Maybe.of(1).map(Maybe.of).stringify());

            test("Maybe.chain");
            assert("chain 2 Maybe", 'Maybe(1)' === Maybe.of(1).chain(Maybe.of).stringify());

            test("Maybe.join");
            test("Maybe.maybe");

            test("Maybe.isTrue");
            assert("true", Maybe.of(true).isTrue());
            assert("trueish", Maybe.of("a").isTrue());
            assert("false", !Maybe.of(false).isTrue());
            assert("falsish", !Maybe.of(null).isTrue());
            assert("nothing", !Maybe.of().isTrue());
        }

        public function Main():void
        {
            F.fxpInit();

            try {
                testFDebug();
                testMaybe();
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
