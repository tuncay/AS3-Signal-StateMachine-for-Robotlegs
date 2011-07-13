package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class ExitingGuardPhase extends BaseSignalStatePhase {

    protected override function runPhase( model:IPhaseModel ):Boolean {
        if ( currentState.hasExitingGuard ) {
            logPhase( SignalStateTransitionPhases.EXITING_GUARD);
            model.transitionPhase = SignalStateTransitionPhases.EXITING_GUARD;
            currentState.dispatchExitingGuard( model.payload );
        }
        return CONTINUE_TRANSITION;
    }
}
}
