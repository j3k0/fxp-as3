package {
    public var assert:Function = function(what:String, result:Boolean):Boolean {
        if (result) {
            trace(test, what, " OK");
            ++success;
            return true;
        }
        else {
            trace(test, what, " FAILED");
            ++failures;
            errors.push(new Error("Test failed: " + test + " " + what));
            return false;
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

    assert.equals = function(what:String, expect:*, got:*):Boolean {
        if (!assert(what, expect === got)) {
            trace("Expected: " + expect);
            trace("     Got: " + got);
            return false;
        }
        return true;
    }

    assert.ok = function(what:String, result:Boolean):Boolean {
        return assert.equals(what, true, result);
    }
}

var errors:Array = [];
var test:String = "";

var success:int = 0;
var failures:int = 0;
