### F.debug

#### F.debug.trace :: String → (a → a)

Returns an identify function that'll log its argument on the console.

**Example**:
```
Maybe.of(12).map(F.debug.trace("What?").map(add5) == 'Maybe(17)'
 > [What?] Maybe(12)
```

#### F.debug.stringify :: a → String

Convert to String using the object's own `stringify` method if it exists, using `JSON.stringify` otherwise.

**Example**: `Maybe.of(5).stringify() === 'Maybe(5)'`

