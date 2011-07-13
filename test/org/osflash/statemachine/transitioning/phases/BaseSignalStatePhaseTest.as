package org.osflash.statemachine.transitioning.phases {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.supporting.IResultsRegistry;
import org.osflash.statemachine.transitioning.Payload;
import org.osflash.statemachine.transitioning.phases.supporting.MockIPhaseModel;
import org.osflash.statemachine.transitioning.phases.supporting.MockLogger;
import org.osflash.statemachine.transitioning.phases.supporting.MockSignalState;
import org.osflash.statemachine.uids.IUID;
import org.osflash.statemachine.uids.TransitionPhaseUID;

public class BaseSignalStatePhaseTest implements IResultsRegistry {

    protected var _testSubject:BaseSignalStatePhase;
    protected var _currentState:MockSignalState;
    protected var _targetState:MockSignalState;
    protected var _reason:String;
    protected var _referringTransition:String;
    protected var _model:MockIPhaseModel;
    protected var _logger:IStateLogger;
    protected var _results:Array;
    protected var _phase:IUID;
    protected var _payload:IPayload;

    [Before]
    public function before():void {
        initProps();
        initTestSubject();
    }

    [After]
    public function after():void {
        disposeProps();
    }

    [Test]
    public function currentState_is_retrieved_from_model():void {
        assertThat( _testSubject.currentState, strictlyEqualTo( _model.currentState ) )
    }

    [Test]
    public function targetState_is_retrieved_from_model():void {
        assertThat( _testSubject.targetState, strictlyEqualTo( _model.targetState ) )
    }

    [Test]
    public function log_passes_correct_values_to_logger():void {
        _testSubject.log( "hello" );
        assertThat( got, equalTo( "hello" ) );
    }

     [Test]
    public function null_logger__log_passes_no_values():void {
         nullifyLogger();
         _testSubject.log( "hello" );
        assertThat( got, equalTo( "" ) );
    }

    [Test]
    public function logCancellation_passes_correct_values_to_logger():void {
        const expected:String = "lC:reason/testing:transition/testing:state/current:1"  ;
        _testSubject.logCancellation();
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function null_logger__logCancellation_passes_no_values():void {
         nullifyLogger();
         _testSubject.logCancellation();
        assertThat( got, equalTo( "" ) );
    }

    [Test]
    public function logPhase_passes_correct_values_to_logger():void {
        const expected:String = "lP:phase/testing:transition/testing:state/current:1" ;
        _testSubject.logPhase(_phase);
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function null_logger__logPhase_passes_no_values():void {
         nullifyLogger();
         _testSubject.logPhase(_phase);
        assertThat( got, equalTo( "" ) );
    }

     [Test]
    public function logStateChange_passes_correct_values_to_logger():void {
        const expected:String = "lSC:state/current:1:state/target:2" ;
        _testSubject.logStateChange();
        assertThat( got, equalTo( expected ) );
    }

     [Test]
    public function null_logger__logStateChange_passes_no_values():void {
         nullifyLogger();
         _testSubject.logStateChange();
        assertThat( got, equalTo( "" ) );
    }

    private function initProps():void {
        _currentState = new MockSignalState( "state/current", 1, this);
        _targetState = new MockSignalState( "state/target", 2, this );
        _reason = "reason/testing";
        _referringTransition = "transition/testing";
        _phase = new TransitionPhaseUID( "testing" );
        _payload = new Payload("payload/testing");

        _model = new MockIPhaseModel( this );
        _model.currentState = _currentState;
        _model.targetState = _targetState;
        _model.cancellationReason = _reason;
        _model.referringTransition = _referringTransition;
       // _model.transitionPhase = _phase;
        _model.payload = _payload;

        _logger = new MockLogger( this );
        _results = [];
    }

    protected function initTestSubject():void {
        _testSubject = new BaseSignalStatePhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

     private function nullifyLogger():void {
        _testSubject.logger = null;
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
        _results = null;
        _phase = null
    }

    public function pushResults( results:Object ):void {
        _results.push( results );
    }

    protected function get got():String {
        return _results.join( "," );
    }
}
}

