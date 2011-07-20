package org.osflash.statemachine.transitioning.phases {

import mockolate.received;
import mockolate.stub;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;

public class TearingDownPhaseTest extends BaseSignalStatePhaseTest {

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
    public function transition_not_cancelled__dispatchTearDown_called():void {
        stubCancelledPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchTearDown" )
                                  .args( )
                                  .once() );
    }

      [Test]
    public function transition_cancelled__dispatchTearDown_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchTearDown" )
                                  .args( )
                                  .once() );
    }

      [Test]
    public function hasEnteringGuard_false__dispatchTearDown_not_called():void {
        stubNoEnteringGuardPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _currentState, received()
                                  .method( "dispatchTearDown" )
                                  .never() );
    }

    [Test]
    public function transition_not_cancelled__logPhase_called():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _logger, received()
                            .method( "logPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.TEAR_DOWN ), equalTo( _referringTransition ), strictlyEqualTo( _currentState ))
                            .once() );
    }

     [Test]
    public function transition_not_cancelled__transitionPhase_set():void {
        stubFullPhaseDispatch();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .setter( "transitionPhase" )
                            .args( strictlyEqualTo( SignalStateTransitionPhases.TEAR_DOWN ) )
                            .once() );
    }

    protected override function initTestSubject():void {
        _testSubject = new TearingDownPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

    private function targetStateHasEnteringGuardSignal( value:Boolean ):void {
        stub( _currentState ).getter( "hasTearDown" ).returns( value );
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
        stub( _model ).setter( "transitionPhase" ).arg( strictlyEqualTo( SignalStateTransitionPhases.TEAR_DOWN ) ).once();
        stub( _currentState ).method( "dispatchTearDown" ).args(  ).once();
    }

}
}
