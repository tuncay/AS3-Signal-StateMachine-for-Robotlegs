package org.osflash.statemachine.decoding.helpers {

import org.osflash.signals.ISignal;

public class SignalPhaseDecoder implements ISignalPhaseDecoder {

    public var factory:ICreatable;

    public function decodePhase( phaseDef:XMLList, signal:ISignal ):void {
        var commandClasses:XMLList = phaseDef.commandClass;
        for each ( var xml:XML in commandClasses ) {
            const item:ICmdClassDeclaration = getCmdClassDeclaration( xml );
            const mapper:ISignalPhaseCmdMapper = getPhaseSignalMapper( item );
            mapper.mapToPhaseSignal( item, signal );
        }
    }

    private function getPhaseSignalMapper( item:ICmdClassDeclaration ):ISignalPhaseCmdMapper {
        return  factory.create( ISignalPhaseCmdMapper, item ) as ISignalPhaseCmdMapper;
    }

    private function getCmdClassDeclaration( xml:XML ):ICmdClassDeclaration {
        const decoder:ICmdClassDeclaration = factory.create( ICmdClassDeclaration ) as ICmdClassDeclaration;
        decoder.decode( xml );
        return decoder;
    }
}
}
