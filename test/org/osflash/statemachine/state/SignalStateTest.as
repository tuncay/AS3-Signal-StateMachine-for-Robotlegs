package org.osflash.statemachine.state {

import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.signals.utils.SignalAsyncEvent;
import org.osflash.signals.utils.handleSignal;
import org.osflash.statemachine.base.BaseState;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.transitioning.Payload;

public class SignalStateTest {

    private var _signalState:SignalState;
    private var _payload:IPayload;
    private var _reason:String;

    [Before]
    public function before():void {
        _signalState = new SignalState( "state/testing", 16 );
        _payload = new Payload( "payload/testing" );
        _reason = "reason/testing"
    }

    [After]
    public function after():void {
        _signalState = null;
        _payload = null;
        _reason = null;
    }

    [Test]
    public function extends_BaseState():void {
        assertThat( _signalState, isA( BaseState ) );
    }

    [Test]
    public function default_hasEnteringGuard_returns_false():void {
        assertThat( _signalState.hasEnteringGuard, isFalse() );
    }

    [Test]
    public function calling_enteringGuard_lazily_creates_signal():void {
        const signal:ISignal = _signalState.enteringGuard;
        assertThat( _signalState.hasEnteringGuard, isTrue() );
    }

    [Test(async)]
    public function dispatchEnteringGuard_dispatches_with_correct_value_objects_passed():void {

        var gotPayload:IPayload;

        const listener:Function = function ( event:SignalAsyncEvent, data:Object ):void {
            gotPayload = IPayload( event.args[0] );
        };

        handleSignal( this, _signalState.enteringGuard, listener );
        _signalState.dispatchEnteringGuard( _payload );

        assertThat( gotPayload, strictlyEqualTo( _payload ) )
    }

    [Test]
    public function default_hasEntered_returns_false():void {
        assertThat( _signalState.hasEntered, isFalse() );
    }

    [Test]
    public function calling_entered_lazily_creates_signal():void {
        const signal:ISignal = _signalState.entered;
        assertThat( _signalState.hasEntered, isTrue() );
    }

    [Test(async)]
    public function dispatchEntered_dispatches_with_correct_value_objects_passed():void {

        var gotPayload:IPayload;

        const listener:Function = function ( event:SignalAsyncEvent, data:Object ):void {
            gotPayload = IPayload( event.args[0] );
        };

        handleSignal( this, _signalState.entered, listener );
        _signalState.dispatchEntered( _payload );

        assertThat( gotPayload, strictlyEqualTo( _payload ) )
    }

    [Test]
    public function default_hasCancelled_returns_false():void {
        assertThat( _signalState.hasCancelled, isFalse() );
    }

    [Test]
    public function calling_cancelled_lazily_creates_signal():void {
        const signal:ISignal = _signalState.cancelled;
        assertThat( _signalState.hasCancelled, isTrue() );
    }

    [Test(async)]
    public function dispatchCancelled_dispatches_with_correct_value_objects_passed():void {

        var gotPayload:IPayload;
        var gotReason:String;

        const listener:Function = function ( event:SignalAsyncEvent, data:Object ):void {
            gotReason = String( event.args[0] );
            gotPayload = IPayload( event.args[1] );
        };

        handleSignal( this, _signalState.cancelled, listener );
        _signalState.dispatchCancelled( _reason, _payload );

        assertThat( gotPayload, strictlyEqualTo( _payload ) );
        assertThat( gotReason, strictlyEqualTo( _reason ) )
    }

    [Test]
    public function default_hasExitingGuard_returns_false():void {
        assertThat( _signalState.hasExitingGuard, isFalse() );
    }

    [Test]
    public function calling_exitingGuard_lazily_creates_signal():void {
        const signal:ISignal = _signalState.exitingGuard;
        assertThat( _signalState.hasExitingGuard, isTrue() );
    }

    [Test(async)]
    public function dispatchExitingGuard_dispatches_with_correct_value_objects_passed():void {

        var gotPayload:IPayload;

        const listener:Function = function ( event:SignalAsyncEvent, data:Object ):void {
            gotPayload = IPayload( event.args[0] );
        };

        handleSignal( this, _signalState.exitingGuard, listener );
        _signalState.dispatchExitingGuard(  _payload );

        assertThat( gotPayload, strictlyEqualTo( _payload ) );
    }

    [Test]
    public function default_hasTearDown_returns_false():void {
        assertThat( _signalState.hasTearDown, isFalse() );
    }

    [Test]
    public function calling_tearDown_lazily_creates_signal():void {
        const signal:ISignal = _signalState.tearDown;
        assertThat( _signalState.hasTearDown, isTrue() );
    }

     [Test(async)]
    public function dispatchTearDown_dispatches_with_correct_value_objects_passed():void {

        var wasListenerCalled:Boolean;

        const listener:Function = function ( event:SignalAsyncEvent, data:Object ):void {
            wasListenerCalled =  true;
        };

        handleSignal( this, _signalState.tearDown, listener );
        _signalState.dispatchTearDown(  );

        assertThat( wasListenerCalled, isTrue() );
    }


}
}
