package org.osflash.statemachine.integration.basic {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IStateProvider;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class CancelledTransitionFromEnteringGuardTestingAllRelevantPhasesDispatched {

    [Before]
    public function before():void {
        initRL();
        initFSM();
        initProps();
    }

    [After]
    public function after():void {
        disposeProps();
    }

    [Test]
    public function cancelled_transition_from_targetState_enteringGuard__only_relevant_phases_dispatched_with_params():void {

        const expected:String = "[ current:: phase/exitingGuard | payload/one ]," +
                                "[ target:: phase/enteringGuard | payload/one ]," +
                                "[ current:: phase/cancelled | reason/testing | payload/one ]";

        addListenersToAllCurrentStatePhases();
        addListenersToAllTargetStatePhases();

        _fsmController.transition( "transition/test", _payloadBody );

        assertThat( got, equalTo( expected ) );
    }

    private function addListenersToAllTargetStatePhases():void {
        _targetState.exitingGuard.addOnce( logPayloadPhaseForTarget );
        _targetState.enteringGuard.addOnce( logAndCancelFromEnteringGuardPhaseForTarget );
        _targetState.entered.addOnce( logPayloadPhaseForTarget );
        _targetState.tearDown.addOnce( logTearDownPhaseForTarget );
        _targetState.cancelled.addOnce( logCancelledPhaseForTarget );
    }

    private function addListenersToAllCurrentStatePhases():void {
        _currentState.exitingGuard.addOnce( logPayloadPhaseForCurrent );
        _currentState.enteringGuard.addOnce( logPayloadPhaseForCurrent );
        _currentState.entered.addOnce( logPayloadPhaseForCurrent );
        _currentState.tearDown.addOnce( logTearDownPhaseForCurrent );
        _currentState.cancelled.addOnce( logCancelledPhaseForCurrent );
    }

    private function logPayloadPhaseForCurrent( payload:IPayload ):void {
        _results.push( "[ current:: " + _fsmProperties.transitionPhase + " | " + payload.body + " ]" );
    }

    private function logAndCancelFromEnteringGuardPhaseForTarget( payload:IPayload ):void {
        _results.push( "[ target:: " + _fsmProperties.transitionPhase + " | " + payload.body + " ]" );
        _fsmController.cancelStateTransition( _reason );
    }

    private function logTearDownPhaseForCurrent():void {
        _results.push( "[ current:: " + _fsmProperties.transitionPhase + " ]" );
    }

    private function logCancelledPhaseForCurrent( reason:String, payload:IPayload ):void {
        _results.push( "[ current:: " + _fsmProperties.transitionPhase + " | " + reason + " | " + payload.body + " ]" );
    }

    private function logPayloadPhaseForTarget( payload:IPayload ):void {
        _results.push( "[ target:: " + _fsmProperties.transitionPhase + " | " + payload.body + " ]" );
    }

    private function logTearDownPhaseForTarget():void {
        _results.push( "[ target:: " + _fsmProperties.transitionPhase + " ]" );
    }

    private function logCancelledPhaseForTarget( reason:String, payload:IPayload ):void {
        _results.push( "[ target:: " + _fsmProperties.transitionPhase + reason + " | " + payload.body + " ]" );
    }

    private function get got():String {
        return _results.join( "," );
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.inject();
    }

    private function initProps():void {
        _stateModel = _injector.getInstance( IStateProvider );
        _fsmProperties = _injector.getInstance( IFSMProperties );
        _fsmController = _injector.getInstance( IFSMController );
        _currentState = _stateModel.getState( "state/starting" ) as ISignalState;
        _targetState = _stateModel.getState( "state/testing" ) as ISignalState;
        _payloadBody = "payload/one";
        _reason = "reason/testing";
        _results = [];
    }

    private function initRL():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function disposeProps():void {
        _injector = null;
        _signalCommandMap = null;
        _stateModel = null;
        _fsmProperties = null;
        _fsmController = null;
        _payloadBody = null;
        _currentState = null;
        _targetState = null;
        _reason = null;
        _results = null;
    }

    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _stateModel:IStateProvider;
    private var _fsmProperties:IFSMProperties;
    private var _fsmController:IFSMController;
    private var _currentState:ISignalState;
    private var _targetState:ISignalState;
    private var _payloadBody:Object;
    private var _reason:String;
    private var _results:Array;

    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">
                          <transition name="transition/test" target="state/testing"/>
                      </state>
                      <state name="state/testing"/>
                  </fsm>;
}
}
