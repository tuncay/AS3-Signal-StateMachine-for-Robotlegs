package org.osflash.statemachine.integration.support {

import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IPayload;
import org.robotlegs.core.IGuard;

public class TeardownHappyGuard implements IGuard {
    [Inject]
    public var resultsRegistery:IResultRegistable;


      [Inject]
    public var fsmProperties:IFSMProperties;

    public function approve():Boolean {
        const state:String = fsmProperties.currentStateName.split("/")[1];
        const phase:String = fsmProperties.transitionPhase.identifier.split("/")[1];
        resultsRegistery.pushResult( "happyGuard:: " + state + " | " + phase );
        return true;
    }
}
}
