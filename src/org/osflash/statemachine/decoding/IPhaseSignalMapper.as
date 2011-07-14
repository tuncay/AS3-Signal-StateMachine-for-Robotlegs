package org.osflash.statemachine.decoding {

import org.osflash.signals.ISignal;

internal interface IPhaseSignalMapper {
    function mapToPhaseSignal( item:CommandClassDeclaration, signal:ISignal ):Vector.<String>;
}
}
