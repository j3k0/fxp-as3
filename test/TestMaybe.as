package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestMaybe {

        public static function run():void {

            assert.test("Maybe.of");
            assert("nothing is nothing",        'Maybe()' === Maybe.of().stringify());
            assert("undefined is nothing",      'Maybe()' === Maybe.of(undefined).stringify());
            assert("null is something (null)",  'Maybe(null)' === Maybe.of(null).stringify());
            assert("false is something (true)", 'Maybe(false)' === Maybe.of(false).stringify());

            assert.test("Maybe.isNothing");
            assert("of nothing is true",   Maybe.of().isNothing());
            assert("of undefined is true", Maybe.of(undefined).isNothing());
            assert("of null is false",  !Maybe.of(null).isNothing());
            assert("of false is false", !Maybe.of(false).isNothing());

            assert.test("Maybe.yes");
            assert("of nothing isn't yes",!Maybe.of().yes());
            assert("of something is yes", Maybe.of({}).yes());

            assert.test("Maybe.no");
            assert("of nothing is no", Maybe.of().no());
            assert("of something isn't no",  !Maybe.of({}).no());

            assert.test("Maybe.map");
            const notCalled:Function = function(x:*):* { throw new Error("Should not be called"); }
            const inverse:Function = function(x:int):int { return -x; }
            assert("of nothing is not called", Maybe.of().map(notCalled).isNothing());
            assert("of something is called", 'Maybe(-12)' === Maybe.of(12).map(inverse).stringify());
            assert("2 Maybe nests them", 'Maybe(Maybe(1))' === Maybe.of(1).map(Maybe.of).stringify());

            assert.test("Maybe.chain");
            assert("2 Maybe gives 1 Maybe", 'Maybe(1)' === Maybe.of(1).chain(Maybe.of).stringify());
            assert("a failed Maybe gives 1 Maybe", 'Maybe()' === Maybe.of().chain(inverse).stringify());

            assert.test("Maybe.join");
            assert("2 Maybe gives 1 Maybe", 'Maybe(1)' === Maybe.of(Maybe.of(1)).join().stringify());
            assert("a failed Maybe gives 1 Maybe", 'Maybe()' === Maybe.of().map(Maybe.of).join().stringify());

            assert.test("Maybe.maybe");
            assert("of something calls right", true === Maybe.of(1).maybe(false, function(x:*):Boolean { return true; }));
            assert("of nothing returns left", false === Maybe.of().maybe(false, function(x:*):Boolean { return true; }));

            assert.test("Maybe.isTrue");
            assert("of true is true", Maybe.of(true).isTrue());
            assert("of trueish is true", Maybe.of("a").isTrue());
            assert("of false is false", !Maybe.of(false).isTrue());
            assert("of falsish is false", !Maybe.of(null).isTrue());
            assert("of nothing is false", !Maybe.of().isTrue());
        }
    }
}
// vim: ts=4:sw=4:et:
