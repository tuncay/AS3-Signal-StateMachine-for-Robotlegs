package org.osflash.statemachine.transitioning.phases {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;

public class ChangingStatePhaseTest extends BaseSignalStatePhaseTest {


    [Test]
    public function dispatch_returns_true_if_transition_has_not_been_cancelled():void {
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function dispatch_returns_true_if_transition_has_been_cancelled():void {
        assertThat( _testSubject.dispatch(), isTrue() );
    }

    [Test]
    public function dispatch_runs_if_transition_has_not_been_cancelled():void {
        const expected:String = "lSC:state/current:1:state/target:2,sTSAT";
        setPropsAndDispatch(false);
        assertThat( got, equalTo( expected ) );
    }
     [Test]
    public function dispatch_runs_if_transition_has_been_cancelled():void {
        const expected:String = "lSC:state/current:1:state/target:2,sTSAT";
        setPropsAndDispatch(true);
        assertThat( got, equalTo( expected ) );
    }

      private function setPropsAndDispatch( hasBeenCancelled:Boolean):void {
        _model.hasTransitionBeenCancelled = hasBeenCancelled;
        _testSubject.dispatch();
    }



    protected override function initTestSubject():void {
        _testSubject = new ChangingStatePhase();
        _testSubject.model = _model;
        _testSubject.logger = _logger;
    }

}
}
