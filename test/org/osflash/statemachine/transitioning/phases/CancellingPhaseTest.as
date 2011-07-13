package org.osflash.statemachine.transitioning.phases {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;

public class CancellingPhaseTest extends BaseSignalStatePhaseTest {


    [Test]
    public function dispatch_returns_true_if_transition_has_not_been_cancelled():void {
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function dispatch_returns_false_if_transition_has_been_cancelled():void {
        _model.hasTransitionBeenCancelled = true;
        assertThat( _testSubject.dispatch(), isFalse() );
    }

    [Test]
    public function phase_not_run_if_transition_has_not_been_cancelled():void {
        _testSubject.dispatch();
        assertThat( got, equalTo( "" ) );
    }

    [Test]
    public function phase_not_run_if_state_has_no_cancelledSignal():void {
        _model.hasTransitionBeenCancelled = true;
        _currentState.hasSignal = false;
        _testSubject.dispatch();
        assertThat( got, equalTo( "" ) );
    }

    [Test]
    public function phase_run_if_state_has_cancelledSignal():void {
        const expected:String = "lC:reason/testing:transition/testing:state/current:1,phase/cancelled,state/current:dC:reason/testing:payload/testing";
        _model.hasTransitionBeenCancelled = true;
        _currentState.hasSignal = true;
        _testSubject.dispatch();
        assertThat( got, equalTo( expected ) );
    }


    protected override function initTestSubject():void {
        _testSubject = new CancellingPhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

}
}
