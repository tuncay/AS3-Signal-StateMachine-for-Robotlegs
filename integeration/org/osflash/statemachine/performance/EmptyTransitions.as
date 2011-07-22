package org.osflash.statemachine.performance {

import org.hamcrest.assertThat;
import org.hamcrest.number.lessThan;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class EmptyTransitions {


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

    public function run():void {
        const startTime:Number = new Date().time;
        const iterations:int = 100000;
        var count:int = 0;

        while ( count < iterations ) {
            _fsmController.transition( "transition/next" );
            count++;
        }

        const duration:Number = new Date().time - startTime;
        const results:Number = ( duration / iterations );

        assertThat( results, lessThan( 0.1))
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.inject();
    }

    private function initProps():void {
        _fsmController = _injector.getInstance( IFSMController );
    }

    private function initRL():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function disposeProps():void {
        _injector = null;
        _signalCommandMap = null;
        _fsmController = null;
    }


    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _fsmController:IFSMController;
    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">
                          <transition name="transition/next" target="state/ending"/>
                      </state>
                      <state name="state/ending">
                          <transition name="transition/next" target="state/starting"/>
                      </state>
                  </fsm>
    ;

}
}
