package org.osflash.statemachine.integration.support {

import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;

public class CancelCommand {
    [Inject]
    public var resultsRegistery:IResultRegistable;

      [Inject]
    public var fsmController:IFSMController;
       [Inject]
    public var fsmProperties:IFSMProperties;

    public function execute():void {
        const state:String = fsmProperties.currentStateName.split("/")[1];
        const phase:String = fsmProperties.transitionPhase.identifier.split("/")[1];
        resultsRegistery.pushResult( "CancelCommand:: " + state + " | " + phase  );
        fsmController.cancelStateTransition("reason/testing")
    }
}
}
