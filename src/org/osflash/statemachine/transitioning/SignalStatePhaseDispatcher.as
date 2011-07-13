package org.osflash.statemachine.transitioning {

import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.phases.CancellingPhase;
import org.osflash.statemachine.transitioning.phases.ChangingStatePhase;
import org.osflash.statemachine.transitioning.phases.EnteringGuardPhase;
import org.osflash.statemachine.transitioning.phases.EnteringPhase;
import org.osflash.statemachine.transitioning.phases.ExitingGuardPhase;
import org.osflash.statemachine.transitioning.phases.TearingDownPhase;

public class SignalStatePhaseDispatcher extends TransitionPhaseDispatcher {
    public function SignalStatePhaseDispatcher(phaseModel:IPhaseModel, logger:IStateLogger) {
        super( phaseModel,  logger );
    }

    override protected function initialiseStateTransition():void {
        pushTransitionPhase( new ExitingGuardPhase()) ;
        pushTransitionPhase( new CancellingPhase()) ;
        pushTransitionPhase( new EnteringGuardPhase()) ;
        pushTransitionPhase( new CancellingPhase()) ;
        pushTransitionPhase( new TearingDownPhase()) ;
        pushTransitionPhase( new ChangingStatePhase()) ;
        pushTransitionPhase( new EnteringPhase()) ;
    }
}
}
