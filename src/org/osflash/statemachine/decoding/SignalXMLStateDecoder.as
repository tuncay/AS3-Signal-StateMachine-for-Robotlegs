package org.osflash.statemachine.decoding {

import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IState;
import org.osflash.statemachine.decoding.helpers.ICreatable;
import org.osflash.statemachine.decoding.helpers.ISignalPhaseDecoder;
import org.osflash.statemachine.errors.StateDecodingError;
import org.osflash.statemachine.states.SignalState;

public class SignalXMLStateDecoder extends BaseXMLStateDecoder {

    private static const COMMAND_CLASS_NOT_REGISTERED:String = "These commands need to be added to the StateDecoder: ";
    private static const COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL:String = "A command class can be mapped once only to the same signal: ";

    private var _classMap:IClassMap;
    private var _factory:ICreatable;

    public function SignalXMLStateDecoder( factory:ICreatable ):void {
        _factory = factory
    }

    override protected function decodeState( stateDef:Object, index:uint ):IState {
        var state:ISignalState = getState( stateDef, index );

        if ( stateDef.entered.length() != 0 )
            decoder.decodePhase( stateDef.entered, state.entered );

        if ( stateDef.enteringGuard.length() != 0 )
            decoder.decodePhase( stateDef.enteringGuard, state.enteringGuard );

        if ( stateDef.exitingGuard.length() != 0 )
            decoder.decodePhase( stateDef.exitingGuard, state.exitingGuard );

        if ( stateDef.tearDown.length() != 0 )
            decoder.decodePhase( stateDef.tearDown, state.tearDown );

        if ( stateDef.cancelled.length() != 0 )
            decoder.decodePhase( stateDef.cancelled, state.cancelled );

        if ( classMap.hasErrors )
            throw new StateDecodingError( COMMAND_CLASS_NOT_REGISTERED + classMap.errors.toString() );

        return state;
    }

    public function addClass( value:Class ):Boolean {
        return classMap.addClass( value );
    }

    public function hasClass( name:Object ):Boolean {
        return classMap.hasClass( name );
    }

    public function getClass( name:Object ):Class {
        return classMap.getClass( name );
    }

    private function getState( stateDef:Object, index:uint ):ISignalState {
        return new SignalState( stateDef.@name.toString(), index );
    }

    private function get classMap():IClassMap {
        return _classMap || (_classMap = IClassMap( _factory.create( IClassMap ) ) );
    }

    private function get decoder():ISignalPhaseDecoder {
        return  _factory.create( ISignalPhaseDecoder ) as ISignalPhaseDecoder;
    }


}

}
