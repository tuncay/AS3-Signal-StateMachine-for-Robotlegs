package org.osflash.statemachine.transitioning.validators {

import org.osflash.statemachine.transitioning.*;

import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.uids.IUID;

public class TransitionValidator implements ITransitionValidator {

    public function validate( model:IFSMProperties ):Boolean {
        const transitionPhase:IUID = model.transitionPhase;
        return (SignalStateTransitionPhases.ENTERED.equals( transitionPhase ) ||
                SignalStateTransitionPhases.CANCELLED.equals( transitionPhase ) ||
                SignalStateTransitionPhases.NONE.equals( transitionPhase ) );

    }
}
}
