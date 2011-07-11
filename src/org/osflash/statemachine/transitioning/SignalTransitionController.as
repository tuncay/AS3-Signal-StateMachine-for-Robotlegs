package org.osflash.statemachine.transitioning {
import org.osflash.statemachine.base.*;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.core.IStateModelOwner;
import org.osflash.statemachine.signals.Changed;
import org.osflash.statemachine.states.SignalState;

/**
 * Encapsulates the state transition and thus the communications between
 * FSM and framework actors using Signals.
 */
public class SignalTransitionController extends BaseStateMachine {

    /**
     * @private
     */
    private var _changed:Changed = new Changed();

    /**
     * Creates an instance of the SignalTransitionController
     * @param model the StateModel
     * between the SignalTransitionController and the framework actors.
     */
    public function SignalTransitionController( model:IStateModelOwner, logger:IStateLogger = null ) {
        super( model, logger );
    }

    /**
     * @inheritDoc
     */
    override protected function get isCancellationLegal():Boolean {
        return ( transitionPhase.equals( SignalTransitionPhases.ENTERING_GUARD ) ||
                 transitionPhase.equals( SignalTransitionPhases.EXITING_GUARD ) );
    }

    /**
     * @inheritDoc
     */
    override protected function get isTransitionLegal():Boolean {
        return (    transitionPhase.equals( SignalTransitionPhases.ENTERED ) ||
                    transitionPhase.equals( SignalTransitionPhases.CANCELLED ) ||
                    transitionPhase.equals( SignalTransitionPhases.GLOBAL_CHANGED ) ||
                    transitionPhase.equals( SignalTransitionPhases.NONE ) );
    }

    override public function destroy():void {
        super.destroy();
        _changed.removeAll();
        _changed = null;
    }


    /**
     * @inheritDoc
     */
    protected function get currentSignalState():SignalState {
        return SignalState( currentState );
    }


    /**
     * @inheritDoc
     */
    override protected function onTransition( target:IState, payload:Object ):void {

        var targetState:SignalState = SignalState( target );

        // Exit the current State
        if ( currentState != null && currentSignalState.hasExitingGuard ) {
            currentTransitionPhase = SignalTransitionPhases.EXITING_GUARD;
            logPhase( SignalTransitionPhases.EXITING_GUARD, currentState );
            currentSignalState.dispatchExitingGuard( payload );
        }

        // Check to see whether the exiting guard has been canceled
        if ( isCanceled ) {
            return;
        }

        // Enter the next State
        if ( targetState.hasEnteringGuard ) {
            currentTransitionPhase = SignalTransitionPhases.ENTERING_GUARD;
            logPhase( SignalTransitionPhases.ENTERING_GUARD, targetState );
            targetState.dispatchEnteringGuard( payload );
        }

        // Check to see whether the entering guard has been canceled
        if ( isCanceled ) {
            return;
        }

        // teardown current state
        if ( currentState != null && currentSignalState.hasTearDown ) {
            currentTransitionPhase = SignalTransitionPhases.TEAR_DOWN;
            logPhase( SignalTransitionPhases.TEAR_DOWN, currentState );
            currentSignalState.dispatchTearDown();
        }

        currentState = targetState;
        log( "CURRENT STATE CHANGED TO: " + currentState.name );

        // Send the notification configured to be sent when this specific state becomes current
        if ( currentSignalState.hasEntered ) {
            currentTransitionPhase = SignalTransitionPhases.ENTERED;
            logPhase( SignalTransitionPhases.ENTERED, currentState );
            currentSignalState.dispatchEntered( payload );
        }

    }

    /**
     * @inheritDoc
     */
    override protected function dispatchGlobalStateChanged():void {
        // Notify the app generally that the state changed and what the new state is
        if ( _changed.numListeners > 0 ) {
            logPhase( SignalTransitionPhases.GLOBAL_CHANGED, currentState );
            _changed.dispatch( currentState.name );
        }
    }

    /**
     * @inheritDoc
     */
    override protected function dispatchTransitionCancelled():void {
        if ( currentState != null && currentSignalState.hasCancelled ) {
            logPhase( SignalTransitionPhases.CANCELLED, currentState );
            currentSignalState.dispatchCancelled( cachedInfo, cachedPayload );
        }
    }



    /**
     * @inheritDoc
     */
    override public function listenForStateChange( listener:Function ):* {
        return _changed.add( listener );
    }

    /**
     * @inheritDoc
     */
    override public function listenForStateChangeOnce( listener:Function ):* {
        return _changed.addOnce( listener );
    }

    /**
     * @inheritDoc
     */
    override public function stopListeningForStateChange( listener:Function ):* {
        return _changed.remove( listener );
    }


}
}