package org.osflash.statemachine.transitioning.phases.supporting {

import org.osflash.statemachine.base.BaseState;
import org.osflash.statemachine.core.ISignalStateOwner;
import org.osflash.statemachine.supporting.IResultsRegistry;

public class MockSignalState extends BaseState implements ISignalStateOwner {

    public var hasSignal:Boolean;
    private var _registry:IResultsRegistry;

    public function MockSignalState( name:String, index:uint, registry:IResultsRegistry ) {
        super( name, index );
        _registry = registry;
    }

    public function get hasEntered():Boolean {
        return hasSignal;
    }

    public function get hasEnteringGuard():Boolean {
        return hasSignal;
    }

    public function get hasExitingGuard():Boolean {
        return hasSignal;
    }

    public function get hasCancelled():Boolean {
        return hasSignal;
    }

    public function get hasTearDown():Boolean {
        return hasSignal;
    }

    public function dispatchEnteringGuard( payload:Object ):void {
        _registry.pushResults( name + ":dEnG:" + payload.body.toString() );
    }

    public function dispatchExitingGuard( payload:Object ):void {
        _registry.pushResults(  name + ":dExG:" + payload.body.toString() );
    }

    public function dispatchTearDown():void {
        _registry.pushResults(  name + ":dTD" );
    }

    public function dispatchCancelled( reason:String, payload:Object ):void {
        _registry.pushResults(  name + ":dC:" + reason + ":" + payload.body.toString() );
    }

    public function dispatchEntered( payload:Object ):void {
        _registry.pushResults(  name + ":dE:" + payload.body.toString() );
    }
}
}
