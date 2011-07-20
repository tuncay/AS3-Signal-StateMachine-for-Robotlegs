package org.osflash.statemachine.transitioning.validators {

import flash.events.Event;

import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.model.ITransitionModel;
import org.osflash.statemachine.transitioning.ITransitionValidator;
import org.osflash.statemachine.uids.IUID;

public class TransitionValidatorTest {

    private var _testSubject:ITransitionValidator;
    private var _model:IFSMProperties;
    private var _iuid:IUID;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( ITransitionModel, IUID ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        _testSubject = new TransitionValidator();
        _model = strict( ITransitionModel );
        _iuid = strict( IUID );
    }

    [After]
    public function after():void {
        _testSubject = null;
        _model = null;
        _iuid = null;
    }

    [Test]
    public function transition_from_CANCELLED_phase_returns_true():void {
        stubModelTransitionPhaseWith( "cancelled" );
        assertThat( _testSubject.validate( _model ), isTrue() );
    }

    [Test]
    public function transition_from_ENTERED_phase_returns_false():void {
        stubModelTransitionPhaseWith( "entered" );
        assertThat( _testSubject.validate( _model ), isTrue() );
    }

    [Test]
    public function transition_from_ENTERING_GUARD_phase_returns_true():void {
        stubModelTransitionPhaseWith( "enteringGuard" );
        assertThat( _testSubject.validate( _model ), isFalse() );
    }

    [Test]
    public function transition_from_EXITING_GUARD_phase_returns_true():void {
        stubModelTransitionPhaseWith( "exitingGuard" );
        assertThat( _testSubject.validate( _model ), isFalse() );
    }

    [Test]
    public function transition_from_TEAR_DOWN_phase_returns_false():void {
        stubModelTransitionPhaseWith( "tearDown" );
        assertThat( _testSubject.validate( _model ), isFalse() );
    }

    [Test]
    public function transition_from_NONE_phase_returns_false():void {
        stubModelTransitionPhaseWith( "none" );
        assertThat( _testSubject.validate( _model ), isTrue() );

    }

    private function stubModelTransitionPhaseWith( phaseName:String ):void {
        stub( _iuid ).getter( "identifier" ).returns( "phase/" + phaseName );
        stub( _model ).getter( "transitionPhase" ).returns( _iuid );
    }

}
}
