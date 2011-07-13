package org.osflash.statemachine.transitioning.validators.supporting {

import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.uids.IUID;

public class MockIFSMProperties implements IFSMProperties {

    private var _transitionPhase:IUID;



    public function get currentStateName():String {
        return "";
    }

    public function get referringTransition():String {
        return "";
    }

    public function get transitionPhase():IUID {
        return _transitionPhase;
    }


    public function set transitionPhase( value:IUID ):void {
        _transitionPhase = value;
    }
}
}
