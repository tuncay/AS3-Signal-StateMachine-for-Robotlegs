package org.osflash.statemachine.transitioning.phases.supporting {

import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.supporting.IResultsRegistry;
import org.osflash.statemachine.uids.IUID;

public class MockLogger implements IStateLogger {

    private var _registry:IResultsRegistry;

    public function MockLogger( registry:IResultsRegistry ) {
        _registry = registry;
    }

    public function log( msg:String ):void {

        _registry.pushResults( msg );
    }

    public function logPhase( phase:IUID, transition:String, state:IState ):void {
        _registry.pushResults( "lP:" + phase + ":" + transition + ":" + state );
    }

    public function logStateChange( currentState:IState, targetState:IState ):void {
        _registry.pushResults( "lSC:" + currentState + ":" + targetState );
    }

    public function logCancellation( reason:String, transition:String, state:IState ):void {
        _registry.pushResults( "lC:" + reason + ":" + transition + ":" + state );
    }
}
}
