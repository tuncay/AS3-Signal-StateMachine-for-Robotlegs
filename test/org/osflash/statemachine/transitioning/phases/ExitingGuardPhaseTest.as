package org.osflash.statemachine.transitioning.phases {

import mockolate.received;
import mockolate.stub;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class ExitingGuardPhaseTest extends BaseSignalStatePhaseTest {

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
    public function transition_not_cancelled__dispatchExitingGuard_called():void {
        stubCancelledPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchExitingGuard" )
                                  .args( strictlyEqualTo( _payload ) )
                                  .once() );
    }

      [Test]
    public function transition_cancelled__dispatchExitingGuard_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchExitingGuard" )
                                  .args( strictlyEqualTo( _payload ) )
                                  .once() );
    }

      [Test]
    public function hasEnteringGuard_false__dispatchExitingGuard_not_called():void {
        stubNoEnteringGuardPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchExitingGuard" )
                                  .never() );
    }

    [Test]
    public function transition_not_cancelled__logPhase_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _logger, received()
                            .method( "logPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.EXITING_GUARD ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ))
                            .once() );
    }

     [Test]
    public function transition_not_cancelled__transitionPhase_set():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .setter( "transitionPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.EXITING_GUARD ) )
                            .once() );
    }

    protected override function initTestSubject():void {
        _testSubject = new ExitingGuardPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

    private function targetStateHasEnteringGuardSignal( value:Boolean ):void {
        stub( _currentState ).getter( "hasExitingGuard" ).returns( value );
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
        stub( _model ).setter( "transitionPhase" ).arg( strictlyEqualTo( SignalStateTransitionPhases.EXITING_GUARD ) ).once();
        stub( _currentState ).method( "dispatchExitingGuard" ).args( strictlyEqualTo( _payload ) ).once();
    }

}
}
