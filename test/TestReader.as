package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestReader {

        public static function run():void {

            assert.test("Reader.of");
            assert.equals("accepts function as argument", F.id, Reader.of(F.id).run("discarded"));
            assert.equals("accepts int as argument", 5, Reader.of(5).run("discarded"));

            assert.test("Reader.map");
            assert.equals("combine the reader with an innocent function",
                8, Reader.ask().map(add5).run(3));
            assert.equals("combine the reader with many innocent functions",
                13, Reader.ask().map(add5).map(add5).run(3));

            assert.test("Reader.chain");
            const addR:Function = function(x:int):Reader { return new Reader(add(x)); }
            const addTwice:Function = function(x:int):Reader { return new Reader(add(x)).chain(addR); }
            assert.equals("apply config to all the chain", 13, addTwice(3).run(5));
        }
    }
}

function add(x:int):Function {
    return function(y:int):int { return x + y; };
}

const add5:Function = add(5);

// vim: ts=4:sw=4:et:
