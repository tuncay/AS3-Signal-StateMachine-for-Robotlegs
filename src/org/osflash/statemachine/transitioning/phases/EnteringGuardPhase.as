package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class EnteringGuardPhase extends BaseSignalStatePhase {

    protected override function runPhase( model:IPhaseModel ):Boolean {
        if ( targetState.hasEnteringGuard ) {
            logPhase( SignalStateTransitionPhases.ENTERING_GUARD );
            model.transitionPhase = SignalStateTransitionPhases.ENTERING_GUARD;
            targetState.dispatchEnteringGuard( model.payload );
        }
        return CONTINUE_TRANSITION;
    }
}
}
