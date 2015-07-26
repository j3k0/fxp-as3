package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestFArray {

        public static function run():void {

            assert.test("F.array.tail");
            assert("null", F.array.tail(null).no());
            assert("[]", F.array.tail([]).no());
            assert("[a]", 'Maybe([])' === F.array.tail(["a"]).stringify());
            assert("[a,b]", 'Maybe(["b"])' === F.array.tail(["a","b"]).stringify());
            assert("[a,b,c]", 'Maybe(["b","c"])' === F.array.tail(["a","b","c"]).stringify());
        }
    }
}
// vim: ts=4:sw=4:et:
