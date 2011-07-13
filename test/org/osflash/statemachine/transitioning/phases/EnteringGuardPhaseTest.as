package org.osflash.statemachine.transitioning.phases {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;

public class EnteringGuardPhaseTest extends BaseSignalStatePhaseTest {


    [Test]
    public function dispatch_returns_true_if_transition_has_not_been_cancelled():void {
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function dispatch_returns_true_if_transition_has_been_cancelled():void {
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function phase_run_if_state_has_enteringGuardSignal_and_is_cancelled():void {
        const expected:String = "lP:phase/enteringGuard:transition/testing:state/current:1,phase/enteringGuard,state/target:dEnG:payload/testing";
        setPropsAndDispatch(true,true);
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function phase_run_if_state_has_enteringGuardSignal_and_is_not_cancelled():void {
        const expected:String = "lP:phase/enteringGuard:transition/testing:state/current:1,phase/enteringGuard,state/target:dEnG:payload/testing";
        setPropsAndDispatch(false,true);
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function phase_not_run_if_state_has_no_enteringGuardSignal_and_is_not_cancelled():void {
        const expected:String = "";
        setPropsAndDispatch(false,false);
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function phase_not_run_if_state_has_no_enteringGuardSignal_and_is_cancelled():void {
        const expected:String = "";
        setPropsAndDispatch(true,false);
        assertThat( got, equalTo( expected ) );
    }

      private function setPropsAndDispatch( hasBeenCancelled:Boolean, hasSignal:Boolean ):void {
        _model.hasTransitionBeenCancelled = hasBeenCancelled;
        _targetState.hasSignal = hasSignal;
        _testSubject.dispatch();
    }


    protected override function initTestSubject():void {
        _testSubject = new EnteringGuardPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

}
}
