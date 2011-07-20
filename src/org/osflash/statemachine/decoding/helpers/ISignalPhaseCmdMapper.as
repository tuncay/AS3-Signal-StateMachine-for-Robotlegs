package org.osflash.statemachine.decoding.helpers {

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;

public interface ISignalPhaseCmdMapper {
    function get signalCommandMap():IGuardedSignalCommandMap;

    function set signalCommandMap( value:IGuardedSignalCommandMap ):void;

    function mapToPhaseSignal( item:ICmdClassDeclaration, signal:ISignal ):void;
}
}
