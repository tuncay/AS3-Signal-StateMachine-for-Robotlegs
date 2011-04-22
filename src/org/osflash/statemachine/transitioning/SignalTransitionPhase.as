package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.core.ITransitionPhase;

public class SignalTransitionPhase implements ITransitionPhase {

    public static const NONE:SignalTransitionPhase = new SignalTransitionPhase("none", 1);
    public static const EXITING_GUARD:SignalTransitionPhase = new SignalTransitionPhase("exitingGuard", 2);
    public static const ENTERING_GUARD:SignalTransitionPhase = new SignalTransitionPhase("enteringGuard", 4);
    public static const ENTERED:SignalTransitionPhase = new SignalTransitionPhase("entered", 8);
    public static const TEAR_DOWN:SignalTransitionPhase = new SignalTransitionPhase("tearDown", 16);
    public static const CANCELLED:SignalTransitionPhase = new SignalTransitionPhase("cancelled", 32);
    public static const GLOBAL_CHANGED:SignalTransitionPhase = new SignalTransitionPhase("globalChanged", 64);

    public function SignalTransitionPhase(name:String, index:int) {
        _name = name;
        _index = index;
    }

    private var _name:String;

    public function get name():String {
        return _name;
    }

    private var _index:int;

    public function get index():int {
        return _index;
    }

    public function equals(value:Object):Boolean {
        return (value === this) || (value == name) || (value == index);
    }
}


}