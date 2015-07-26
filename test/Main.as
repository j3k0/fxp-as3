package
{
    import fxp.core.F;
    import flash.display.Sprite;
	import flash.desktop.NativeApplication;

    public class Main extends Sprite
    {
        public function testFObject():void {
            trace("** F.object.haz");
            assert("a:true", F.object.haz("a", { a: true}).yes());
            assert("a:false", F.object.haz("a", { a: false }).yes());
            assert("a:null", F.object.haz("a", { a: null }).yes());
            assert("{}", F.object.haz("a", { }).no());

            trace("** F.object.prop");
            assert("a:true", F.object.prop("a", { a :true }).yes());
            assert("a:false", F.object.prop("a", { a: false }).yes());
            assert("a:null", F.object.prop("a", { a: null }).yes());
            assert("{}", F.object.prop("a", {}).no());

            trace("** F.object.deepHaz");
            assert("\"yes\"", F.object.deepHaz("push.message", { push: { message: "yes" } }).yes());
            assert("false", F.object.deepHaz("push.message", { push: { message: false } }).yes());
            assert("passage", F.object.deepHaz("push.message", { push: { passage: "yes" } }).no());
            assert("mush", F.object.deepHaz("push.message", { mush: {} }).no());
            assert("{}", F.object.deepHaz("push.message", { }).no());
            assert("null", F.object.deepHaz("push.message", null).no());
            assert('value', 'Maybe({"a":12})' === F.object.deepHaz("a", { a: 12 }).toString());
        }

        public function testFArray():void {
            trace("** F.array.tail");
            assert("null", F.array.tail(null).no());
            assert("[]", F.array.tail([]).no());
            assert("[a]", 'Maybe([])' === F.array.tail(["a"]).toString());
            assert("[a,b]", 'Maybe(["b"])' === F.array.tail(["a","b"]).toString());
            assert("[a,b,c]", 'Maybe(["b","c"])' === F.array.tail(["a","b","c"]).toString());
        }

        public function Main():void
        {
            F.fxpInit();

            try {
                testFObject();
                testFArray();
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
