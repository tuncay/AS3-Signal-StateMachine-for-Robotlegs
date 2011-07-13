package org.osflash.statemachine.transitioning.phases.supporting {

import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.supporting.IResultsRegistry;
import org.osflash.statemachine.uids.IUID;

public class MockIPhaseModel implements IPhaseModel {

    private var _currentState:IState;
    private var _targetState:IState;
    private var _referringTransition:String;
    private var _cancellationReason:String;
    private var _hasTransitionBeenCancelled:Boolean;
    private var _tansitionPhase:IUID;
    private var _payload:IPayload;
    private var _reqistry:IResultsRegistry;


    public function MockIPhaseModel(reqistry:IResultsRegistry) {
        _reqistry = reqistry;
    }

    public function get currentState():IState {
        return _currentState;
    }

    public function set currentState( value:IState ):void {
        _currentState = value;
    }

    public function get targetState():IState {
        return _targetState;
    }

    public function set targetState( value:IState ):void {
        _targetState = value;
    }

    public function get referringTransition():String {
        return _referringTransition;
    }

    public function get cancellationReason():String {
        return _cancellationReason;
    }

    public function get hasTransitionBeenCancelled():Boolean {
        return _hasTransitionBeenCancelled;
    }

    public function set hasTransitionBeenCancelled( value:Boolean ):void {
        _hasTransitionBeenCancelled = value;
    }

      public function get tansitionPhase():IUID {
        return _tansitionPhase;
    }

    public function set transitionPhase( phase:IUID ):void {
       _reqistry.pushResults( phase.toString() );
    }

    public function set payload( value:IPayload ):void {
        _payload = value;
    }

    public function get payload():IPayload {
        return _payload;
    }

    public function setTargetStateAsCurrent():void {
      _reqistry.pushResults( "sTSAT");
    }

    public function set cancellationReason( cancellationReason:String ):void {_cancellationReason = cancellationReason;}

    public function set referringTransition( referringTransition:String ):void {_referringTransition = referringTransition;}



}
}
