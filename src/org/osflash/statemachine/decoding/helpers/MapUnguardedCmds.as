package org.osflash.statemachine.decoding.helpers {

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class MapUnguardedCmds implements ISignalPhaseCmdMapper {

    private var _signalCommandMap:IGuardedSignalCommandMap;

    public function mapToPhaseSignal( item:ICmdClassDeclaration, signal:ISignal ):void {
        _signalCommandMap.mapSignal( signal, item.commandClass );
    }

    public function set signalCommandMap( value:IGuardedSignalCommandMap ):void {
        _signalCommandMap = value;
    }

    public function get signalCommandMap():IGuardedSignalCommandMap {
        return _signalCommandMap;
    }
}
}
