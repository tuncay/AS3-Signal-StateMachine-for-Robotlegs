package org.osflash.statemachine.decoding {

import org.osflash.signals.ISignal;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.errors.StateDecodingError;
import org.robotlegs.core.IGuardedSignalCommandMap;

internal class StateSignalCommandMappingDecoder {

    private static const COMMAND_CLASS_NOT_REGISTERED:String = "These commands need to be added to the StateDecoder: ";
    private static const COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL:String = "A command class can be mapped once only to the same signal: ";

    private var _errors:Array;
    private var _classMap:ClassMap;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _phaseSignalCOmmandMapper:PhaseSignalCommandMapper;

    public function StateSignalCommandMappingDecoder( classMap:ClassMap, signalCommandMap:IGuardedSignalCommandMap ) {
        _classMap = classMap;
        _signalCommandMap = signalCommandMap;
        _phaseSignalCOmmandMapper = new PhaseSignalCommandMapper( _signalCommandMap, _classMap);
        _errors = [];
    }

    public function mapCmdDeclarationsToStateSignals( signalState:ISignalState, stateDef:Object ):void {
        mapPhaseCmdDeclarationsToPhaseSignal( stateDef.entered, signalState.entered );
        mapPhaseCmdDeclarationsToPhaseSignal( stateDef.enteringGuard, signalState.enteringGuard );
        mapPhaseCmdDeclarationsToPhaseSignal( stateDef.exitingGuard, signalState.exitingGuard );
        mapPhaseCmdDeclarationsToPhaseSignal( stateDef.tearDown, signalState.tearDown );
        mapPhaseCmdDeclarationsToPhaseSignal( stateDef.cancelled, signalState.cancelled );
        if ( _errors.length > 0 )
            throw new StateDecodingError( COMMAND_CLASS_NOT_REGISTERED + _errors.toString() );
    }

    private function mapPhaseCmdDeclarationsToPhaseSignal( phaseDef:XMLList, phaseSignal:ISignal ):void {
        var decoder:PhaseCommandDecoder = new PhaseCommandDecoder( phaseDef );
        if ( decoder.isNull ) return;
        const e:Vector.<String>   = decoder.mapPhaseCommandsToSignal( phaseSignal, _phaseSignalCOmmandMapper );
        _errors.concat( e );
    }
}
}
