package {
    public var assert:Function = function(what:String, test:Boolean):void {
        if (test) {
            trace("OK:", what);
            ++success;
        }
        else {
            trace("FAILED:", what);
            ++failures;
            errors.push(new Error("Test failed: " + what));
        }
    }

    assert.finish = function():void {
        trace("\n**\nsuccess:  " + success + "\nfailures: " + failures + "\n");
        if (errors.length > 0)
            throw errors[0];
    }
}

var errors:Array = [];

var success:int = 0;
var failures:int = 0;
