package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.core.ITransitionPhase;
import org.osflash.statemachine.enumbs.TransitionPhaseID;

public class SignalTransitionPhases {


    public static const NONE:ITransitionPhase = TransitionPhaseID.NONE;
    public static const GLOBAL_CHANGED:ITransitionPhase = TransitionPhaseID.GLOBAL_CHANGED;
    public static const CANCELLED:ITransitionPhase = TransitionPhaseID.CANCELLED;

    public static const EXITING_GUARD:ITransitionPhase = new TransitionPhaseID("exitingGuard", 8);
    public static const ENTERING_GUARD:ITransitionPhase = new TransitionPhaseID("enteringGuard", 16);
    public static const ENTERED:ITransitionPhase = new TransitionPhaseID("entered", 32);
    public static const TEAR_DOWN:ITransitionPhase = new TransitionPhaseID("tearDown", 64);


}


}