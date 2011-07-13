package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class TearingDownPhase extends BaseSignalStatePhase {

    protected override function runPhase( model:IPhaseModel):Boolean{
        if ( currentState.hasTearDown ) {
            logPhase(SignalStateTransitionPhases.TEAR_DOWN);
            model.transitionPhase = SignalStateTransitionPhases.TEAR_DOWN;
            currentState.dispatchTearDown( );
        }
        return CONTINUE_TRANSITION
    }

}
}
