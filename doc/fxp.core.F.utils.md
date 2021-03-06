### F.utils

```actionscript
    import fxp.core.F;
```

#### F.utils.equals :: a → a → Boolean

Returns true iff arguments are strictly equal.

**Example**:
```actionscript
    F.utils.equals(3, 3) === true;
```

#### F.utils.lowerThan :: a → a → Boolean

Returns true iff the second argument is lower than the first argument.

**Example**:
```actionscript
    F.utils.lowerThan(2, 1) === true;
```

#### F.utils.lowerEqual :: a → a → Boolean

Returns true iff the second argument is lower or equal to the first argument.

**Example**:
```actionscript
    F.utils.lowerEqual(2, 1) === true;
```

#### F.utils.greaterThan :: a → a → Boolean

Returns true iff the second argument is greater than the first argument.

**Example**:
```actionscript
    F.utils.greaterThan(2, 1) === true;
```

#### F.utils.greaterEqual :: a → a → Boolean

Returns true iff the second argument is greater or equal to the first argument.

**Example**:
```actionscript
    F.utils.greaterEqual(2, 1) === true;
```

#### F.utils.selector :: a → a → Boolean → a

Returns either the first (resp. second) argument if the Boolean is false (resp. true).

**Example**:
```actionscript
    F.utils.selector(null, { a: 1 }, true); // == { a: 1 }
    F.utils.selector(null, { a: 1 }, false); // == null
```

#### F.utils.isNativeType :: a → Boolean

Returns true iff a is a native type (number, boolean, string).

**Example**:
```actionscript
    F.utils.isNativeType(12) === true;
```

