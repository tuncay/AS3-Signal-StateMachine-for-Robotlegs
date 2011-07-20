package org.osflash.statemachine.transitioning.phases {

import mockolate.received;
import mockolate.stub;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

public class ChangingStatePhaseTest extends BaseSignalStatePhaseTest {


    [Test]
    public function dispatch_returns_true_if_transition_has_not_been_cancelled():void {
        transitionCancelled( false );
        stubMethod();
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    private function stubMethod():void {
        stub( _model ).method( "setTargetStateAsCurrent" );
    }

    [Test]
    public function dispatch_returns_true_if_transition_has_been_cancelled():void {
        transitionCancelled( true );
        stubMethod();
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function setTargetStateAsCurrent_is_called_if_transition_has_not_been_cancelled():void {
        transitionCancelled( false );
        stubMethod();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .method( "setTargetStateAsCurrent" )
                            .once() );
    }

    [Test]
    public function logStateChange_is_called_if_transition_has_not_been_cancelled():void {
        transitionCancelled( false );
        stubMethod();
        _testSubject.dispatch();
        assertThat( _logger, received()
                             .method( "logStateChange" )
                             .args( strictlyEqualTo( _currentState ), strictlyEqualTo( _targetState ) )
                             .once() );
    }

    [Test]
    public function setTargetStateAsCurrent_is_called_if_transition_has_been_cancelled():void {
        transitionCancelled( true );
        stubMethod();
        _testSubject.dispatch();
        assertThat( _model, received()
                            .method( "setTargetStateAsCurrent" )
                            .once() );
    }


    [Test]
    public function logStateChange_is_called_if_transition_has_been_cancelled():void {
        transitionCancelled( true );
        stub( _model ).method( "setTargetStateAsCurrent" ).once();
        _testSubject.dispatch();
        assertThat( _logger, received()
                             .method( "logStateChange" )
                             .args( strictlyEqualTo( _currentState ), strictlyEqualTo( _targetState ) )
                             .once() );
    }


    protected override function initTestSubject():void {
        _testSubject = new ChangingStatePhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }



}
}
