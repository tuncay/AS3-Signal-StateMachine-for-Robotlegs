package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class EnteringPhase extends BaseSignalStatePhase {

    protected override function runPhase( model:IPhaseModel):Boolean{
        if ( currentState.hasEntered ) {
            logPhase(SignalStateTransitionPhases.ENTERED);
            model.transitionPhase = SignalStateTransitionPhases.ENTERED;
            currentState.dispatchEntered( model.payload );
        }
        return CONTINUE_TRANSITION
    }
}
}
