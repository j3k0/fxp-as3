package
{
    import fxp.core.F;
    import fxp.monads.*;
    import flash.display.Sprite;
    import flash.desktop.NativeApplication;

    public class Main extends Sprite
    {
        public function Main():void
        {
            F.fxpInit();

            try {
                TestFDebug.run();
                TestF.run();
                TestMaybe.run();
                TestFObject.run();
                TestFArray.run();
                TestIO.run();
                assert.finish();
                NativeApplication.nativeApplication.exit(0);
            }
            catch(err:Error) {
                trace(err.getStackTrace());
                NativeApplication.nativeApplication.exit(1);
            }

        }
    }
}
// vim: ts=4:sw=4:et:
