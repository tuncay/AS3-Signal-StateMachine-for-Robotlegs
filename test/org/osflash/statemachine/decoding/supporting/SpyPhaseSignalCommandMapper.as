package org.osflash.statemachine.decoding.supporting {

import org.osflash.statemachine.decoding.*;

import org.osflash.signals.ISignal;
import org.osflash.statemachine.supporting.IResultsRegistry;

public class SpyPhaseSignalCommandMapper implements IPhaseSignalMapper {

    private var _register:IResultsRegistry;

    public function SpyPhaseSignalCommandMapper( register:IResultsRegistry) {
        _register = register;
    }

    public function mapToPhaseSignal( item:CommandClassDeclaration, signal:ISignal ):Vector.<String> {
        _register.pushResults("mTPS:" + item.commandClassName + ":" + signal );
        return null;
    }
}
}
