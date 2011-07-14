package org.osflash.statemachine.decoding {

import org.osflash.signals.ISignal;

internal class PhaseCommandDeclarationDecoder {

    internal var decodedItems:Vector.<CommandClassDeclaration>;

    public function PhaseCommandDeclarationDecoder( phaseDef:XMLList ):void {

        decode( phaseDef );
    }

    public function get isNull():Boolean {
        return (decodedItems == null || decodedItems.length == 0);
    }

    private function decode( phaseDef:XMLList ):void {
        if ( phaseDef.length() == 0 )return;
        decodedItems = new <CommandClassDeclaration>[];
        var commandClasses:XMLList = phaseDef.commandClass;
        for each ( var xml:XML in commandClasses ) {
            var item:CommandClassDeclaration = new CommandClassDeclaration( xml );
            decodedItems.push( item );
        }
    }

    public function mapPhaseCommandsToSignal( signal:ISignal, mapper:PhaseSignalCommandMapper ):Vector.<String> {
        var e:Vector.<String> = new <String>[];
        for each ( var item:CommandClassDeclaration in decodedItems ) {
            e = mapper.mapCommandClassToPhaseSignal( item, signal );
        }
        return e;
    }
}
}
