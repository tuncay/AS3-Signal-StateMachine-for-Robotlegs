package org.osflash.statemachine.decoding.helpers {

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class MapGuardedCmdsWithFallback implements ISignalPhaseCmdMapper {

    public var _signalCommandMap:IGuardedSignalCommandMap;

    public function mapToPhaseSignal( item:ICmdClassDeclaration, signal:ISignal ):void {
        if ( item.commandClass == null ||
             item.fallbackCommandClass == null )return;
        _signalCommandMap.mapGuardedSignalWithFallback( signal, item.commandClass, item.fallbackCommandClass, item.guardClasses );
    }

    public function set signalCommandMap( value:IGuardedSignalCommandMap ):void {
        _signalCommandMap = value;
    }

    public function get signalCommandMap():IGuardedSignalCommandMap {
        return _signalCommandMap;
    }
}
}
