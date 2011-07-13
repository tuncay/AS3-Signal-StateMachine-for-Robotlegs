package org.osflash.statemachine.transitioning.validators {

import org.hamcrest.assertThat;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.osflash.statemachine.transitioning.ITransitionValidator;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;
import org.osflash.statemachine.transitioning.validators.supporting.MockIFSMProperties;

public class TransitionValidatorTest {

    private var _testSubject:ITransitionValidator;
    private var _model:MockIFSMProperties;

    [Before]
    public function before():void {
        _testSubject = new TransitionValidator();
        _model = new MockIFSMProperties();
    }

    [After]
    public function after():void {
        _testSubject = null;
    }

    [Test]
    public function transition_from_CANCELLED_phase_returns_true():void {
        _model.transitionPhase = SignalStateTransitionPhases.CANCELLED;
       assertThat( _testSubject.validate( _model ), isTrue() );
    }

    [Test]
    public function transition_from_ENTERED_phase_returns_false():void {
        _model.transitionPhase = SignalStateTransitionPhases.ENTERED;
       assertThat( _testSubject.validate( _model ), isTrue() );
    }

    [Test]
    public function transition_from_ENTERING_GUARD_phase_returns_true():void {
        _model.transitionPhase = SignalStateTransitionPhases.ENTERING_GUARD;
       assertThat( _testSubject.validate( _model ), isFalse() );
    }

    [Test]
    public function transition_from_EXITING_GUARD_phase_returns_true():void {
        _model.transitionPhase = SignalStateTransitionPhases.EXITING_GUARD;
       assertThat( _testSubject.validate( _model ), isFalse() );
    }

     [Test]
    public function transition_from_TEAR_DOWN_phase_returns_false():void {
        _model.transitionPhase = SignalStateTransitionPhases.TEAR_DOWN;
       assertThat( _testSubject.validate( _model ), isFalse() );
    }

      [Test]
    public function transition_from_NONE_phase_returns_false():void {
        _model.transitionPhase = SignalStateTransitionPhases.NONE;
       assertThat( _testSubject.validate( _model ), isTrue() );
    }

}
}
