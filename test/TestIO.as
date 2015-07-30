package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestIO {

        public static function run():void {

            var io:IO;

            assert.test("IO.of");
            assert.equals("safeguards a state",
                'IO(?)', IO.of(state).stringify());

            assert.test("IO.new");
            assert.equals("safeguards an effect function",
                'IO(?)', new IO(loadState).stringify());

            assert.test("IO.perform");
            io = IO.of(state);
            state.value += 1;
            assert.equals("runs the IO", 2, io.perform().value);

            assert.test("IO.map");
            assert.equals("operates on the result of IO", 3,
                IO.of(state).map(safeAdd1).perform().value);
            assert.equals("do not change the state", 2, state.value);

            assert.test("IO.chain");
            const incState:Function = F.combine(
                F.chain(saveStateIO),
                F.map(safeAdd1),
                loadStateIO
            );
            assert.equals("allows to chain 2 effects", 3, incState().perform().value);
            assert.equals("changes the state", 3, state.value);
            incState().perform();
            assert.equals("changes state each time", 4, state.value);

            assert.test("IO.join");
            assert.equals("2 IO gives 1 IO",
                1, new IO(function():IO { return IO.of(1) }).join().perform());
        }
    }
}
// vim: ts=4:sw=4:et:

import fxp.monads.IO;

var state:Object = { value: 1 };

function loadState():Object {
    return state;
}
function saveState(s:Object):Object {
    state.value = s.value;
    return state;
}

function loadStateIO():IO {
    return new IO(loadState);
}
function saveStateIO(newState:Object):IO {
    return new IO(function():Object {
        return saveState(newState);
    });
}

function safeAdd1(s:Object):Object {
    return { value: s.value + 1 }
}
