package org.osflash.statemachine.transitioning.phases {

import flash.events.Event;

import mockolate.nice;
import mockolate.prepare;
import mockolate.received;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.states.SignalState;
import org.osflash.statemachine.uids.IUID;

public class BaseSignalStatePhaseTest {

    protected var _testSubject:BaseSignalStatePhase;
    protected var _currentState:ISignalState;
    protected var _targetState:ISignalState;
    protected var _reason:String;
    protected var _referringTransition:String;
    protected var _model:IPhaseModel;
    protected var _logger:IStateLogger;
    protected var _phase:IUID;
    protected var _payload:IPayload;
    protected var _logMsg:String;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( IPhaseModel, IStateLogger, SignalState, IUID, IPayload ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        initSupport();
        initTestSubject();
    }

    [After]
    public function after():void {
        disposeProps();
    }

    [Test]
    public function currentState_is_retrieved_from_model():void {
        assertThat( _testSubject.currentState, strictlyEqualTo( _currentState ) )
    }

    [Test]
    public function targetState_is_retrieved_from_model():void {
        assertThat( _testSubject.targetState, strictlyEqualTo( _model.targetState ) )
    }

    [Test]
    public function log_passes_correct_values_to_logger():void {
        _testSubject.log( _logMsg );
        assertThat( _logger, received()
                             .method( "log" )
                             .arg( equalTo( _logMsg ) )
                             .once() );
    }

    [Test]
    public function null_logger__log_passes_no_values():void {
        nullifyLogger();
        _testSubject.log( "_logMsg" );
        assertThat( _logger, received()
                             .method( "log" )
                             .never() );
    }


    [Test]
    public function logCancellation_passes_correct_values_to_logger():void {
        _testSubject.logCancellation();
        assertThat( _logger, received()
                             .method( "logCancellation" )
                             .args( equalTo( _reason ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ) )
                             .once() );
    }


    [Test]
    public function null_logger__logCancellation_passes_no_values():void {
        nullifyLogger();
        _testSubject.logCancellation();
        assertThat( _logger, received()
                             .method( "logCancellation" )
                             .never() );
    }


    [Test]
    public function logPhase_passes_correct_values_to_logger():void {
        _testSubject.logPhase( _phase );
        assertThat( _logger, received()
                             .method( "logPhase" )
                             .args( strictlyEqualTo( _phase ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ) )
                             .once() );
    }


    [Test]
    public function null_logger__logPhase_passes_no_values():void {
        nullifyLogger();
        _testSubject.logCancellation();
        assertThat( _logger, received()
                             .method( "logPhase" )
                             .never() );
    }


    [Test]
    public function logStateChange_passes_correct_values_to_logger():void {
        _testSubject.logStateChange();
        assertThat( _logger, received()
                             .method( "logStateChange" )
                             .args( strictlyEqualTo( _currentState ), strictlyEqualTo( _targetState ) )
                             .once() );
    }


    [Test]
    public function null_logger__logStateChange_passes_no_values():void {
        nullifyLogger();
        _testSubject.logStateChange();
        assertThat( _logger, received()
                             .method( "logStateChange" )
                             .never() );
    }

    private function initSupport():void {
        assignStringValues();
        stubProperties();
        stubModel();
        stubLogger();
    }

    private function assignStringValues():void {
        _reason = "reason/testing";
        _referringTransition = "transition/testing";
        _logMsg = "testing,testing,1,2,3";
    }

    private function stubProperties():void {
        _currentState = strict( SignalState, "currentState", ["currentState", 1] );
        stub( _currentState ).method( "toString" ).returns( "state/currentState" );

        _targetState = strict( SignalState, "targetState", ["targetState", 2] );
        stub( _targetState ).method( "toString" ).returns( "state/targetState" );

        _phase = nice( IUID );
        stub( _targetState ).method( "toString" ).returns( "phase/testing" );

        _payload = nice( IPayload );
        stub( _payload ).getter( "body" ).returns( "payload/testing" );
    }

    private function stubModel():void {
        _model = strict( IPhaseModel );
        stub( _model ).getter( "currentState" ).returns( _currentState );
        stub( _model ).getter( "targetState" ).returns( _targetState );
        stub( _model ).getter( "cancellationReason" ).returns( _reason );
        stub( _model ).getter( "referringTransition" ).returns( _referringTransition );
        stub( _model ).getter( "transitionPhase" ).returns( _phase );
        stub( _model ).getter( "payload" ).returns( _payload );
    }

    private function stubLogger():void {
        _logger = strict( IStateLogger );
        stub( _logger ).method( "log" ).args( equalTo( _logMsg ) );
        stub( _logger ).method( "logCancellation" ).args( equalTo( _reason ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ) ).once();
        stub( _logger ).method( "logPhase" ).args( isA( IUID ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ) ).once();
        stub( _logger ).method( "logStateChange" ).args( strictlyEqualTo( _currentState ), strictlyEqualTo( _targetState ) ).once();
    }

    protected function initTestSubject():void {
        _testSubject = new BaseSignalStatePhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

    private function nullifyLogger():void {
        _testSubject.logger = null;
    }

    protected function transitionCancelled( value:Boolean ):void {
        stub( _model ).getter( "hasTransitionBeenCancelled" ).returns( value );
    }


    private function disposeProps():void {
        _testSubject = null;
        _currentState = null;
        _targetState = null;
        _reason = null;
        _payload = null;
        _referringTransition = null;
        _model = null;
        _logger = null;
        _logMsg = null;
        _phase = null
    }
}
}

