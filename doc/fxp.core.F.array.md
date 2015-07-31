### F.array

```actionscript
    import fxp.core.F;
```

#### F.array.of :: ...args → Array(a)

Create an array from a dynamic list of arguments

**Example**:
```actionscript
    F.array.of(1,2,4,5); // == [1,2,4,5]
```

#### F.array.join :: String → Array(a) → String

Join an array into a single string using a separator.

**Example**:
```actionscript
    F.array.join(".", [1,2]) === '1.2'
```

#### F.array.head :: Array(a) → Maybe(a)

Returns the first element in the array.

**Example**:
```actionscript
    F.array.head([4,3,1]); // == 'Maybe(4)'
```

#### F.array.tail :: Array(a) → Maybe(Array(a))

Returns all but the first elements in the array.

**Example**:
```actionscript
    F.array.tail([4,3,1]); // == 'Maybe([3,1])'
```

#### F.array.headMap :: (a → b) → Array(a) → Maybe(b)

Map a function to the head of the array.

**Example**:
```actionscript
    F.array.headMap(add5, [4,3,1]); // == 'Maybe(9)'
```

