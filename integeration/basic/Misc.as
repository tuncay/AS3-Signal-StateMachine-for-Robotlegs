package org.osflash.statemachine.basic{

import mockolate.expect;

import org.hamcrest.assertThat;
import org.hamcrest.core.throws;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IStateProvider;
import org.osflash.statemachine.errors.StateTransitionError;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class Misc {

    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
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

    private var _stateModel:IStateProvider;
    private var _fsmProperties:IFSMProperties;
    private var _fsmController:IFSMController;
    private var _payloadBody:Object;
    private var _reason:String;

    [Before]
    public function before():void {
        initSS();
        initProps();
        initFSM();

        _stateModel = _injector.getInstance( IStateProvider );
        _fsmProperties = _injector.getInstance( IFSMProperties );
        _fsmController = _injector.getInstance( IFSMController );
        _payloadBody = "testing,testing,1,2,3";
        _reason = "reason/testing";
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.inject();
    }

    private function initProps():void {
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function initSS():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
    }

    [After]
    public function after():void {
        _injector = null;
        _signalCommandMap = null;
        _stateModel = null;
        _fsmProperties = null;
        _fsmController = null;
        _payloadBody = null;
        _reason = null;
    }



    [Test]
    public function states_have_no_lazily_created_signals():void {
        const stateModel:IStateProvider = _injector.getInstance( IStateProvider );
        const state:ISignalState = stateModel.getState( "state/testing" ) as ISignalState;
        const expected:String = "false,false,false,false,false";
        const got:String = [ state.hasCancelled, state.hasEntered, state.hasEnteringGuard, state.hasExitingGuard, state.hasTearDown ].join( "," );
        assertThat( got, equalTo( expected ) );
    }

    private function cancelTransitionFromGuard( payload:IPayload ):void {
        _fsmController.cancelStateTransition( _reason );
    }


}
}
