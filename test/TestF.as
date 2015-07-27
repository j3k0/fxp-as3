package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestF {

        public static function run():void {

            assert.test("F.combine");
            assert("should combine args", F.combine(add2, add3)(1) === 6);
            assert("should combine arrays", F.combine([add2, add3])(4) === 9);
        }
    }
}
// vim: ts=4:sw=4:et:

function add2(x:int):int { return x + 2; }
function add3(x:int):int { return x + 3; }

