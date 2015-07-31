### F.object

```actionscript
    import fxp.core.F;
```

#### F.object.prop :: String → Object → Maybe(a)

Return the Object's property with name provided in the first argument.

**Example**: `F.object.prop("a", { a:123 }) == 'Maybe(123)'`

#### F.object.deepProp:: (Array(String) | String) → Object → Maybe(a)

Returns Object's property found at **path** provided in the first argument.

**Examples**:
 * `F.object.deepProp(["a","b","c"], { a: { b: { c: true } } }) == 'Maybe(true)'`
 * `F.object.deepProp("a.b"], { a: { b: { c: true } } }) == 'Maybe("c":true)'`

#### F.object.haz :: String → Object → Boolean

Returns true iff Object has the property with name provided in the first argument.

**Example**: `F.object.haz("hello", { hello: true }) === true`

#### F.object.deepHaz :: (Array(String) | String) → Object → Boolean

Returns true iff Object has the property with **path** provided in the first argument.

**Examples**:
 * `F.object.deepHaz(["a","b","c"], { a: { b: { c: true } } }) === true`
 * `F.object.deepHaz("a.b"], { a: { b: { c: true } } }) === true`

