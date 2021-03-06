package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestFArray {

        public static function run():void {

            assert.test("F.array.of");
            assert.equals("uses arguments", '[1,2,3,4]', F.debug.stringify(F.array.of(1,2,3,4)));
            assert.equals("uses arrays", '[[1,2],[3,4]]', F.debug.stringify(F.array.of([1,2],[3,4])));
            assert.equals("uses null", '[null]', F.debug.stringify(F.array.of(null)));

            assert.test("F.array.tail");
            assert.ok("null", F.array.tail(null).no());
            assert.ok("[]", F.array.tail([]).no());
            assert.equals("[a]", 'Maybe([])', F.array.tail(["a"]).stringify());
            assert.equals("[a,b]", 'Maybe(["b"])', F.array.tail(["a","b"]).stringify());
            assert.equals("[a,b,c]", 'Maybe(["b","c"])', F.array.tail(["a","b","c"]).stringify());

            assert.test("F.array.some");
            assert("find the element", F.array.some(is1, [ 1 ]));
            assert("do not find missing element", !F.array.some(is1, [ 2 ]));

            assert.test("F.array.has");
            assert("find last element", true === F.array.has(3)([ 1, 2, 3 ]));
            assert("find first element", true === F.array.has(1, [ 1, 2, 3]));
            assert("report missing element", false === F.array.has(4, [ 1, 2, 3]));

            assert.test("F.array.mapEachArgs");
            assert("matches each arguments with functions 1/2",
                '[true,false]' === F.debug.stringify(F.array.mapEachArgs([ is1, is1 ])(1, 2)));
            assert("matches each arguments with functions 2/2",
                '[false,false]' === F.debug.stringify(F.array.mapEachArgs([ is2, is1 ])(1, 2)));

            assert.test("F.array.mapApply");
            assert("apply F.map on an array 1/2", 'Maybe(true)' === F.array.mapApply([ is1, Maybe.of(1) ]).stringify());
            assert("apply F.map on an array 2/2", 'Maybe()' === F.array.mapApply([ is1, Maybe.of() ]).stringify());

            // hasPlayer :: String -> GameObject -> Boolean
            assert.test("F.array demo");
            const hasPlayer:Function = F.combine(
                Maybe.utils.isTrue,
                F.array.mapApply,
                F.array.mapEachArgs([ F.array.has, F.object.prop("players") ]));
            assert("finds jeko", hasPlayer("jeko", { players: [ "jeko", "sousou" ] }));
            assert("no joke", !hasPlayer("joke", { players: [ "jeko", "sousou" ] }));
        }
    }
}

function is1(a:int):Boolean { return a === 1; }
function is2(a:int):Boolean { return a === 2; }

// vim: ts=4:sw=4:et:
