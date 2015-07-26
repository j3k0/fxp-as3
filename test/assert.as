package {
    public function assert(what:String, test:Boolean):void {
        if (test) {
            trace("OK:", what);
        }
        else {
            trace("FAILED:", what);
            throw new Error("Test failed: " + what);
        }
    }
}
