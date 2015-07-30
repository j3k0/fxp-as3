### fxp.core.F

#### F.fxpInit :: _ → _

Initialize the library. Must be called before doing anything else.

#### F.id :: a → a

Identify function.

**Example**: `F.id(12) === 12`

#### F.partial :: Function → ...Args → Function

Returns a partially applied function.

**Example**:
```
const add = function(a:*, b:*):* { return a + b; };
const add7 = F.partial(add, 7)
```

#### F.curry :: Function → Function

Returns the curried version of the function.

**Example**:
```
const add = F.curry(function(a:*, b:*):* { return a + b; });
const add5 = add(5);
```

#### F.combine :: ...Functions → Function

Returns the combination of multiple functions.

**Example**: `add12 = F.combine(add7, add5)`

#### F.map :: (a → b) → M(a) → M(b)

Maps a function to a monad.

**Example**: `Maybe.of(1).map(add5) == 'Maybe(6)'`

#### F.join :: M(M(a)) → M(a)

Join to monads of the same type.

**Example**: `Maybe.of(1).map(Maybe.of).join == 'Maybe.of(1)'`

#### F.chain :: (a → M(b)) → M(a) → M(b)

Chain to monads of the same type.

**Example**: `Maybe.of(1).chain(Maybe.of) == 'Maybe.of(1)'`

#### F.flip :: (a → b → c) → (b → a → c)

Flips arguments for a function of arity 2.

**Example**:
```
const div = function(a:*, b:*):* { return a / b; };
const divBy2 = F.flip(div)(2);
```

#### F.call0 :: (_ → a) → a

Calls a function of arity 0.

**Example**:
```
one = function():int { return 1; }
F.call0(one) == 1;
```

#### F.call1 :: (a → b) → a → b

Calls a function of arity 1.

**Example**: `F.call1(add5, 2) == 7`

#### F.callN :: (a → b → ... → z) → a → b → ... → z

Calls a function of arity N.

**Example**: `Maybe.of(div).map(F.flip(F.call2)(6, 3))`

#### F.call :: (a → b) → a → b

Alias for `F.call1`.

#### F.rcall :: a → (a → b) → b

Fliped call function.

**Example**: `Maybe.of(add5).map(F.rcall(6)) == 'Maybe(11)'`

#### F.liftM1 :: (a -> b) -> M(a) -> M(b)

Convert a function (a -> b) to a function M(a) to M(b).

**Example**:
```
maybeAdd5 = F.liftM1(add5)
maybeAdd5(Maybe.of(1)) == 'Maybe(6)'
```

#### F.liftM2 :: (a -> b -> c) -> M(a) -> M(b) -> M(c)

Convert a function (a -> b -> c) to a function M(a) -> M(b) -> M(b).

**Example**:
```
maybeAdd = F.liftM1(add)
maybeAdd(Maybe.of(1), Maybe.of(2)) == 'Maybe(3)'
```

### Utilities

The `F` class also provides access to utilities.

 * [utils](fxp.core.F.utils.md)
 * [debug](fxp.core.F.debug.md)
 * [object](fxp.core.F.object.md)
 * [array](fxp.core.F.array.md)
 * [string](fxp.core.F.string.md)

