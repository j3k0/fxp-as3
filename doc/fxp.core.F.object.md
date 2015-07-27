### F.object

#### F.object.haz :: String → Object → Boolean

Returns true iff Object has the property with name provided in the first argument.

**Example**: `F.object.haz("hello", { hello: true }) === true`

#### F.object.deepHaz :: Array(String) → Object → Boolean

Returns true iff Object has the property with **path** provided in the first argument.

**Example**: `F.object.deepHaz(["a","b","c"], { a: { b: { c: true } } }) === true`

#### F.object.prop :: String → Object → Maybe(a)

Return the Object's property with name provided in the first argument.

**Example**: `F.object.prop("a", { a:123 }) == 'Maybe(123)'`

