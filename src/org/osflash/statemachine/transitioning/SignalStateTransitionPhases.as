package org.osflash.statemachine.transitioning {

import org.osflash.statemachine.uids.IUID;
import org.osflash.statemachine.uids.TransitionPhaseUID;

public class SignalStateTransitionPhases {


    public static const NONE:IUID = TransitionPhaseUID.NONE;
    public static const CANCELLED:IUID = TransitionPhaseUID.CANCELLED;

    public static const EXITING_GUARD:IUID = new TransitionPhaseUID("exitingGuard", 4);
    public static const ENTERING_GUARD:IUID = new TransitionPhaseUID("enteringGuard", 8);
    public static const ENTERED:IUID = new TransitionPhaseUID("entered", 16);
    public static const TEAR_DOWN:IUID = new TransitionPhaseUID("tearDown", 32);


}


}