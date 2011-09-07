package org.osflash.statemachine.transitioning.processes {

import flash.events.Event;

import mockolate.nice;

import mockolate.prepare;
import mockolate.received;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.core.anything;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.core.IInjector;

public class InjectableProcessTest {

    private var _injector:IInjector;
    private var _injectableProcess:InjectableProcess;
    private var _fsmController:IFSMController;
    private var _fsmProperties:IFSMProperties;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
            prepare( IFSMController, IFSMProperties ),
            Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IFSMController, stubFSMController() );
        _injector.mapValue( IFSMProperties, stubFSMProperties() );
        _injector.mapClass( InjectableProcess, InjectableProcess );
        _injectableProcess = _injector.instantiate( InjectableProcess );
    }

    [After]
    public function after():void {
        _injector = null;
        _injectableProcess = null;
        _fsmController = null;
        _fsmProperties = null;
    }

    [Test]
    public function fsmController_setter_is_injected():void {
        _injectableProcess.start();
        assertThat( _fsmController, received().method( "transition" ).once );
    }

    [Test]
    public function fsmProperties_setter_is_injected():void {
        const currentStateName:String = _injectableProcess.currentStateName;
        assertThat( _fsmProperties, received().getter( "currentStateName" ).once );
    }

    private function stubFSMProperties():IFSMProperties {
        _fsmProperties = nice( IFSMProperties ) as IFSMProperties;
        stub( _fsmController ).getter( "currentStateName" );
        return _fsmProperties
    }

    private function stubFSMController():IFSMController {
        _fsmController = nice( IFSMController ) as IFSMController;
        stub( _fsmController ).method( "transition" );
        return _fsmController;
    }
}
}
