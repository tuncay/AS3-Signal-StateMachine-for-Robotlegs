package org.osflash.statemachine.transitioning.validators {

import org.osflash.statemachine.transitioning.*;

import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.uids.IUID;

public class CancellationValidator implements ITransitionValidator {

    public function validate( model:IFSMProperties ):Boolean {
        const transitionPhase:IUID = model.transitionPhase;
        return ( SignalStateTransitionPhases.ENTERING_GUARD.equals( transitionPhase ) ||
                 SignalStateTransitionPhases.EXITING_GUARD.equals( transitionPhase ) );


    }
}
}
