package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class CancellingPhase extends BaseSignalStatePhase {


    protected override function runPhase( model:IPhaseModel):Boolean {

        if ( !model.hasTransitionBeenCancelled ) return CONTINUE_TRANSITION;

        if ( currentState.hasCancelled ) {
            logCancellation();
            model.transitionPhase = SignalStateTransitionPhases.CANCELLED;
            currentState.dispatchCancelled( model.cancellationReason, model.payload );
        }
        return CANCEL_TRANSITION;
    }

}
}
