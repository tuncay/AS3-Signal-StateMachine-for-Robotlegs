package org.osflash.statemachine.transitioning.validators {

import org.osflash.statemachine.transitioning.*;

import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.uids.IUID;

public class TransitionValidator implements ITransitionValidator {

    public function validate( model:IFSMProperties ):Boolean {
        const transitionPhase:IUID = model.transitionPhase;
        return (transitionPhase.equals( SignalStateTransitionPhases.ENTERED ) ||
                transitionPhase.equals( SignalStateTransitionPhases.CANCELLED ) ||
                transitionPhase.equals( SignalStateTransitionPhases.NONE ) );

    }
}
}
