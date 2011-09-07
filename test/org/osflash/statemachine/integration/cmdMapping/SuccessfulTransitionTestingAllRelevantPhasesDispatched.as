package org.osflash.statemachine.integration.cmdMapping {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.integration.support.CancelCommand;
import org.osflash.statemachine.integration.support.CommandA;
import org.osflash.statemachine.integration.support.CommandB;
import org.osflash.statemachine.integration.support.CommandC;
import org.osflash.statemachine.integration.support.CommandD;
import org.osflash.statemachine.integration.support.CommandE;
import org.osflash.statemachine.integration.support.CommandF;
import org.osflash.statemachine.integration.support.CommandG;
import org.osflash.statemachine.integration.support.CommandH;
import org.osflash.statemachine.integration.support.IResultRegistable;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class SuccessfulTransitionTestingAllRelevantPhasesDispatched implements IResultRegistable {

    [Before]
    public function before():void {
        initRL();
        initFSM();
        initProps();
    }

    private function handleError( e:Error ):void {
        trace( e );
    }

    [After]
    public function after():void {
        disposeProps();
    }

    [Test]
    public function cancelled_from_exitingGuard__only_relevant_phases_dispatched_with_params():void {
        _results = [];
        const expected:String =  "[ CommandC:: starting | exitingGuard | payload/one ]," +
                                 "[ CommandC:: starting | enteringGuard | payload/one ]," +
                                 "[ CommandD:: starting | enteringGuard | payload/one ]," +
                                 "[ CommandE:: starting | tearDown ]," +
                                 "[ CommandC:: ending | entered | payload/one ]," +
                                 "[ CommandB:: ending | entered | payload/one ]," +
                                 "[ CommandA:: ending | entered | payload/one ]," +
                                 "[ CommandA:: ending | exitingGuard | payload/one ]," +
                                 "[ CommandD:: ending | enteringGuard | payload/one ]," +
                                 "[ CommandF:: ending | tearDown ]," +
                                 "[ CommandE:: ending | tearDown ]," +
                                 "[ CommandA:: starting | entered | payload/one ]," +
                                 "[ CommandB:: starting | entered | payload/one ]," +
                                 "[ CommandC:: starting | entered | payload/one ]";


        _fsmController.pushTransition( "transition/end", _payloadBody );
        _fsmController.pushTransition( "transition/start", _payloadBody );
        _fsmController.transition();

        assertThat( got, equalTo( expected ) );
    }


    public function pushResult( result:Object ):void {
        if ( _results == null ) _results = [];
        _results.push( "[ " + result + " ]" )
    }

    public function get got():String {
        return _results.join( "," );
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.addClass( CommandA );
        fsmInjector.addClass( CommandB );
        fsmInjector.addClass( CommandC );
        fsmInjector.addClass( CommandD );
        fsmInjector.addClass( CommandE );
        fsmInjector.addClass( CommandF );
        fsmInjector.addClass( CommandG );
        fsmInjector.addClass( CommandH );
        fsmInjector.inject();
    }

    private function initProps():void {
        _fsmProperties = _injector.getInstance( IFSMProperties );
        _fsmController = _injector.getInstance( IFSMController );
        _payloadBody = "payload/one";
        _reason = "reason/testing";

    }

    private function initRL():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
        _injector.mapValue( IResultRegistable, this );
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function disposeProps():void {
        _injector = null;
        _signalCommandMap = null;
        _fsmProperties = null;
        _fsmController = null;
        _payloadBody = null;
        _reason = null;
        _results = null;
    }

    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _fsmProperties:IFSMProperties;
    private var _fsmController:IFSMController;
    private var _payloadBody:Object;
    private var _reason:String;
    private var _results:Array;

    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">

                          <entered>
                              <commandClass classPath="CommandA"/>
                              <commandClass classPath="CommandB"/>
                              <commandClass classPath="CommandC"/>
                          </entered>

                          <enteringGuard>
                              <commandClass classPath="CommandD"/>
                          </enteringGuard>

                          <exitingGuard>
                              <commandClass classPath="CommandC"/>
                          </exitingGuard>

                          <tearDown>
                              <commandClass classPath="CommandE"/>
                          </tearDown>

                          <cancelled>
                              <commandClass classPath="CommandH"/>
                              <commandClass classPath="CommandG"/>
                          </cancelled>

                          <transition name="transition/end" target="state/ending"/>

                      </state>
                      <state name="state/ending">

                          <entered>
                              <commandClass classPath="CommandC"/>
                              <commandClass classPath="CommandB"/>
                              <commandClass classPath="CommandA"/>
                          </entered>

                          <enteringGuard>
                              <commandClass classPath="CommandC"/>
                              <commandClass classPath="CommandD"/>
                          </enteringGuard>

                          <exitingGuard>
                              <commandClass classPath="CommandA"/>
                          </exitingGuard>

                          <tearDown>
                              <commandClass classPath="CommandF"/>
                              <commandClass classPath="CommandE"/>
                          </tearDown>

                          <cancelled>
                              <commandClass classPath="CommandG"/>
                          </cancelled>

                          <transition name="transition/start" target="state/starting"/>

                      </state>
                  </fsm>


}
}
