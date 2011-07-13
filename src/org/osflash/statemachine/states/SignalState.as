package org.osflash.statemachine.states {

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.base.BaseState;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.ISignalStateOwner;
import org.osflash.statemachine.signals.Cancelled;
import org.osflash.statemachine.signals.Entered;
import org.osflash.statemachine.signals.EnteringGuard;
import org.osflash.statemachine.signals.ExitingGuard;
import org.osflash.statemachine.signals.TearDown;

public class SignalState extends BaseState implements ISignalState, ISignalStateOwner {

    protected var _enteringGuard:Signal;
    protected var _exitingGuard:Signal;
    protected var _entered:Signal;
    protected var _tearDown:Signal;
    protected var _cancelled:Signal;

    public function SignalState( name:String, index:uint ):void {
        super( name, index );
    }

    public function get hasEntered():Boolean {
        return ( _entered != null);
    }

    public function get hasEnteringGuard():Boolean {
        return ( _enteringGuard != null);
    }

    public function get hasExitingGuard():Boolean {
        return ( _exitingGuard != null);
    }

    public function get hasCancelled():Boolean {
        return ( _cancelled != null);
    }

    public function get hasTearDown():Boolean {
        return ( _tearDown != null);
    }

    public function get entered():ISignal {
        return _entered || ( _entered = new Entered() );
    }

    public function get enteringGuard():ISignal {
        return _enteringGuard || ( _enteringGuard = new EnteringGuard() );
    }

    public function get exitingGuard():ISignal {
        return _exitingGuard || ( _exitingGuard = new ExitingGuard() );
    }

    public function get cancelled():ISignal {
        return _cancelled || ( _cancelled = new Cancelled() );
    }

    public function get tearDown():ISignal {
        return _tearDown || ( _tearDown = new TearDown() );
    }

    public function dispatchEnteringGuard( payload:Object ):void {
        if ( _enteringGuard == null || _enteringGuard.numListeners < 0 ) return;
        _enteringGuard.dispatch( payload );
    }

    public function dispatchExitingGuard( payload:Object ):void {
        if ( _exitingGuard == null || _exitingGuard.numListeners < 0 ) return;
        _exitingGuard.dispatch( payload );
    }

    public function dispatchTearDown():void {
        if ( _tearDown == null || _tearDown.numListeners < 0 ) return;
        _tearDown.dispatch();
    }

    public function dispatchCancelled( reason:String, payload:Object ):void {
        if ( _cancelled == null || _cancelled.numListeners < 0 ) return;
        _cancelled.dispatch( reason, payload );
    }

    public function dispatchEntered( payload:Object ):void {
        if ( _entered == null || _entered.numListeners < 0 ) return;
        _entered.dispatch( payload );
    }
}
}