package org.osflash.statemachine.transitioning.phases {

import mockolate.received;
import mockolate.stub;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class CancellingPhaseTest extends BaseSignalStatePhaseTest {

    [Test]
    public function dispatch_returns_true_if_transition_has_not_been_cancelled():void {
        transitionCancelled( false );
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function dispatch_returns_false_if_transition_has_been_cancelled():void {
        transitionCancelled( true );
        currentStateHasCancelledSignal( false );
        assertThat( _testSubject.dispatch(), isFalse() );
    }

    [Test]
    public function phase_not_dispatched_if_transition_has_not_been_cancelled():void {
        transitionCancelled( false );
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                   .method( "dispatchCancelled" )
                                   .never() );
    }

    [Test]
    public function phase_not_dispatched_if_state_has_no_cancelledSignal():void {
        transitionCancelled( true );
        currentStateHasCancelledSignal( false );
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                   .method( "dispatchCancelled" )
                                   .never() );
    }

    [Test]
    public function currentState_dispatchCancelled_method_called_during_phase_dispatch():void {
        stubExpectedFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                   .method( "dispatchCancelled" )
                                   .args( strictlyEqualTo( _reason ), strictlyEqualTo( _payload ) )
                                   .once() );
    }

    [Test]
    public function model_transitionPhase_set_as_CANCELLED_during_phase_dispatch():void {
        stubExpectedFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .setter( "transitionPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.CANCELLED ) )
                            .once() );
    }

    [Test]
    public function logger_logCancellation_called_during_phase_dispatch():void {
        stubExpectedFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _logger, received()
                             .method( "logCancellation" )
                             .args( equalTo( _reason ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ) )
                             .once() );
    }

    private function currentStateHasCancelledSignal( value:Boolean ):void {
        stub( _currentState ).getter( "hasCancelled" ).returns( value );
    }

    private function stubExpectedFullPhaseDispatch():void {
        transitionCancelled( true );
        currentStateHasCancelledSignal( true );
        stub( _model ).setter( "transitionPhase" ).arg( strictlyEqualTo( SignalStateTransitionPhases.CANCELLED ) ).once();
        stub( _currentState ).method( "dispatchCancelled" ).args( strictlyEqualTo( _reason ), strictlyEqualTo( _payload ) ).once();
    }

    protected override function initTestSubject():void {
        _testSubject = new CancellingPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }



}
}
