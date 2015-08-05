package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestF {

        public static function run():void {

            assert.test("F.combine");
            assert("should combine args", F.combine(add2, add3)(1) === 6);
            assert("should combine arrays", F.combine([add2, add3])(4) === 9);

            assert.test("F.liftM1");
            assert.equals("takes a monad, gives a monad",
                "Maybe(14)", F.liftM1(add2)(Maybe.of(12)).stringify());
            assert.equals("keeps monad properties",
                "Maybe()", F.liftM1(add2)(Maybe.of()).stringify());

            assert.test("F.liftM2");
            assert.equals("takes 2 monads, gives a monad",
                "Maybe(8)", F.liftM2(add)(Maybe.of(3), Maybe.of(5)).stringify());
            assert.equals("keeps left monad properties",
                "Maybe()", F.liftM2(add)(Maybe.of(), Maybe.of(2)).stringify());
            assert.equals("keeps right monad properties",
                "Maybe()", F.liftM2(add)(Maybe.of(2), Maybe.of()).stringify());

            assert.test("F.IO");
            assert.equals("is a shortcut for an IO function",
                11, F.IO(function(a:int, b:int):* { return a + b; })(5,6).perform());
            assert.equals("is curried",
                11, F.IO(function(a:int, b:int):* { return a + b; })(5)(6).perform());
        }
    }
}
// vim: ts=4:sw=4:et:

function add(x:int, y:int):int { return x + y; }
function add2(x:int):int { return x + 2; }
function add3(x:int):int { return x + 3; }

