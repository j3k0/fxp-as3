package {
    public var assert:Function = function(what:String, result:Boolean):void {
        if (result) {
            trace(test, what, " OK");
            ++success;
        }
        else {
            trace(test, what, " FAILED");
            ++failures;
            errors.push(new Error("Test failed: " + test + " " + what));
        }
    }

    assert.finish = function():void {
        trace("\n**\nsuccess:  " + success + "\nfailures: " + failures + "\n");
        if (errors.length > 0)
            throw errors[0];
    }

    assert.test = function(testName:String):void {
        test = testName;
        trace("\n**", testName);
    }
}

var errors:Array = [];
var test:String = "";

var success:int = 0;
var failures:int = 0;
