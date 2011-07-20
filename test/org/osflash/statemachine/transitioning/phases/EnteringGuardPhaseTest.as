package org.osflash.statemachine.transitioning.phases {

import mockolate.received;
import mockolate.stub;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class EnteringGuardPhaseTest extends BaseSignalStatePhaseTest {

    [Test]
    public function transition_not_cancelled__dispatch_returns_true():void {
       stubFullPhaseDispatch();
        assertThat( _testSubject.dispatch(), isTrue() );
    }


    [Test]
    public function transition_cancelled__dispatch_returns_true():void {
        stubCancelledPhaseDispatch();
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function transition_not_cancelled__dispatchEnteringGuard_called():void {
        stubCancelledPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _targetState, received()
                                  .method( "dispatchEnteringGuard" )
                                  .args( strictlyEqualTo( _payload ) )
                                  .once() );
    }

      [Test]
    public function transition_cancelled__dispatchEnteringGuard_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _targetState, received()
                                  .method( "dispatchEnteringGuard" )
                                  .args( strictlyEqualTo( _payload ) )
                                  .once() );
    }

      [Test]
    public function hasEnteringGuard_false__dispatchEnteringGuard_not_called():void {
        stubNoEnteringGuardPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _targetState, received()
                                  .method( "dispatchEnteringGuard" )
                                  .never() );
    }

    [Test]
    public function transition_not_cancelled__logPhase_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _logger, received()
                            .method( "logPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.ENTERING_GUARD ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ))
                            .once() );
    }

     [Test]
    public function transition_not_cancelled__transitionPhase_set():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .setter( "transitionPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.ENTERING_GUARD ) )
                            .once() );
    }

    protected override function initTestSubject():void {
        _testSubject = new EnteringGuardPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

    private function targetStateHasEnteringGuardSignal( value:Boolean ):void {
        stub( _targetState ).getter( "hasEnteringGuard" ).returns( value );
    }

     private function stubCancelledPhaseDispatch():void {
        transitionCancelled( true );
        targetStateHasEnteringGuardSignal( true );
        stubEnteringGuardSpecificValues();
    }

    private function stubNoEnteringGuardPhaseDispatch():void {
        transitionCancelled( false );
        targetStateHasEnteringGuardSignal( false );
        stubEnteringGuardSpecificValues();
    }

    private function stubFullPhaseDispatch():void {
        transitionCancelled( false );
        targetStateHasEnteringGuardSignal( true );
        stubEnteringGuardSpecificValues();
    }

    private function stubEnteringGuardSpecificValues():void {
        stub( _model ).setter( "transitionPhase" ).arg( strictlyEqualTo( SignalStateTransitionPhases.ENTERING_GUARD ) ).once();
        stub( _targetState ).method( "dispatchEnteringGuard" ).args( strictlyEqualTo( _payload ) ).once();
    }

}
}
