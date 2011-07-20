package org.osflash.statemachine.decoding.helpers {

import org.osflash.signals.ISignal;

public interface ISignalPhaseDecoder {
    function decodePhase( phaseDef:XMLList, phaseSignal:ISignal ):void;
}
}
