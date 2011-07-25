package org.osflash.statemachine.basic {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IStateProvider;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class SuccessfulTransitionsChangeCurrentStateToTarget {

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
    public function first_state_is_initial_state():void {
        assertThat( _fsmProperties.currentStateName, equalTo( "state/starting" ) );
    }

    [Test]
    public function single_transition_changes_state():void {
        _fsmController.transition( "transition/test" );

        assertThat( _fsmProperties.currentStateName, equalTo( "state/testing" ) );
    }

    [Test]
    public function two_consecutive_transitions_changes_state():void {
        _fsmController.transition( "transition/test" );
        _fsmController.transition( "transition/end" );

        assertThat( _fsmProperties.currentStateName, equalTo( "state/ending" ) );
    }

    [Test]
    public function three_consecutive_transitions_changes_state():void {
        _fsmController.transition( "transition/test" );
        _fsmController.transition( "transition/end" );
        _fsmController.transition( "transition/start" );

        assertThat( _fsmProperties.currentStateName, equalTo( "state/starting" ) );
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
        _payloadBody = "testing,testing,1,2,3";
        _reason = "reason/testing";
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
        _reason = null;
    }


    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _stateModel:IStateProvider;
    private var _fsmProperties:IFSMProperties;
    private var _fsmController:IFSMController;
    private var _payloadBody:Object;
    private var _reason:String;
    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">
                          <transition name="transition/test" target="state/testing"/>
                      </state>
                      <state name="state/testing">
                          <transition name="transition/end" target="state/ending"/>
                      </state>
                      <state name="state/ending">
                          <transition name="transition/start" target="state/starting"/>
                      </state>
                  </fsm>
    ;

}
}
