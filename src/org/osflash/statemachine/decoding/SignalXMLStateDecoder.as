package org.osflash.statemachine.decoding {

import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.states.SignalState;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class SignalXMLStateDecoder extends BaseXMLStateDecoder {

    private var _classMap:ClassMap;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _commandMapper:StateSignalCommandMappingDecoder;

    public function SignalXMLStateDecoder( signalCommandMap:IGuardedSignalCommandMap ):void {
        _signalCommandMap = signalCommandMap;
        _commandMapper = new StateSignalCommandMappingDecoder( _classMap, _signalCommandMap );
    }

    override protected function decodeState( stateDef:Object, index:uint ):IState {
        var state:ISignalState = getState( stateDef, index );
        _commandMapper.mapCmdDeclarationsToStateSignals( state, stateDef );
        return state;
    }

    public function addClass( value:Class ):Boolean {
        return classMap.addClass( value );
    }

    private function get classMap():ClassMap {
        return _classMap || (_classMap == new ClassMap() );
    }

    public function hasClass( name:Object ):Boolean {
        return classMap.hasClass( name );
    }

    public function getClass( name:Object ):Class {
        return classMap.getClass( name );
    }

    protected function getState( stateDef:Object, index:uint ):ISignalState {
        return new SignalState( stateDef.@name.toString(), index );
    }


}

}
