package {
    import fxp.core.F;
    import fxp.monads.*;

    public class TestFObject {

        public static function run():void {

            assert.test("F.object.prop");
            assert("a:true", F.object.prop("a", { a :true }).yes());
            assert("a:false", F.object.prop("a", { a: false }).yes());
            assert("a:null", F.object.prop("a", { a: null }).yes());
            assert("{}", F.object.prop("a", {}).no());

            assert.test("F.object.deepProp");
            assert('"yes"', 'Maybe("yes")' === F.object.deepProp(["push", "message"], { push: { message: "yes" } }).stringify());
            assert("false", 'Maybe(false)' === F.object.deepProp(["push", "message"], { push: { message: false } }).stringify());
            assert("passage", 'Maybe()' === F.object.deepProp(["push", "message"], { push: { passage: "yes" } }).stringify());
            assert("mush", 'Maybe()' === F.object.deepProp(["push", "message"], { mush: {} }).stringify());
            assert("{}", 'Maybe()' === F.object.deepProp(["push", "message"], { }).stringify());
            assert("null", 'Maybe()' === F.object.deepProp(["push", "message"], null).stringify());
            assert('12', 'Maybe(12)' === F.object.deepProp(["a"], { a: 12 }).stringify());
            assert('12', 'Maybe(12)' === F.object.deepProp("a", { a: 12 }).stringify());

            assert.test("F.object.haz");
            assert("1", !F.object.haz("a", 1));
            assert("null", !F.object.haz("a", null));
            assert("a:true", F.object.haz("a", { a: true}));
            assert("a:false", F.object.haz("a", { a: false }));
            assert("a:null", F.object.haz("a", { a: null }));
            assert("{}", !F.object.haz("a", { }));

            assert.test("F.object.deepHaz");
            assert('"yes"', F.object.deepHaz(["push", "message"], { push: { message: "yes" } }));
            assert("false", F.object.deepHaz(["push", "message"], { push: { message: false } }));
            assert("passage", !F.object.deepHaz(["push", "message"], { push: { passage: "yes" } }));
            assert("mush", !F.object.deepHaz(["push", "message"], { mush: {} }));
            assert("{}", !F.object.deepHaz(["push", "message"], { }));
            assert("null", !F.object.deepHaz(["push", "message"], null));
            assert('value', true === F.object.deepHaz(["a"], { a: 12 }));
        }
    }
}
// vim: ts=4:sw=4:et:

