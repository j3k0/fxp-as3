### IO Monad

```actionscript
    import fxp.monads.IO;
```

#### new IO :: f -> IO

Enclose an unpure function into an IO, an act of great purification.

**Example**:
```actionscript
    var io:IO = new IO(function():* { return computer.shutdown(); });
```

#### IO.of :: Object -> IO

Enclose an unpure mutable object into an IO, like in a pandora box.

**Example**:
```actionscript
    var io:IO = IO.of(SharedObject.getLocal("state"));
```

#### IO.perform :: IO(a) -> * -> *

Run the unpure effect enclosed in the IO.

You can pass any required arguments and use its return value.

**Example**:
```actionscript
    io.perform()
```

#### IO.map :: IO(a) -> (a -> b) -> IO(b)

**Example**:
```actionscript
    var state:Object = { value: 1 }
    IO.of(state).map(safeAdd1).perform().value);
```

#### IO.chain :: IO(a) -> (a -> IO(b)) -> IO(b)

**Example**:
```actionscript
    const incState:Function = F.combine(
        F.chain(saveStateIO),
        F.map(safeAdd1),
        loadStateIO
    );
```

#### IO.join :: IO(IO(a)) -> IO(a)

**Example**:
```actionscript
    new IO(function():IO { return IO.of(1) }).join().perform());
```
