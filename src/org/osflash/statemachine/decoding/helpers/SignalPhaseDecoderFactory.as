package org.osflash.statemachine.decoding.helpers {

import org.osflash.statemachine.decoding.ClassMap;
import org.osflash.statemachine.decoding.IClassMap;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class SignalPhaseDecoderFactory implements ICreatable {

    private var _classMap:IClassMap;
    private var _signalCommandMap:IGuardedSignalCommandMap;

    public function SignalPhaseDecoderFactory( signalCommandMap:IGuardedSignalCommandMap ) {
        _signalCommandMap = signalCommandMap;
    }

    public function create( id:Class, ...rest ):Object {

        if ( id === (IClassMap) )
            return classMap;

        if ( id === ISignalPhaseDecoder )
            return  getSignalPhaseCommandMapper();

        if ( id === ISignalPhaseCmdMapper )
            return  getSignalPhaseCmdMapper( rest[0] as ICmdClassDeclaration );

        if ( id === ICmdClassDeclaration )
            return getCmdClassDeclaration();

        return null;
    }

    private function getSignalPhaseCommandMapper():ISignalPhaseDecoder {
        const decoder:SignalPhaseDecoder = new SignalPhaseDecoder();
        decoder.factory = this;
        return decoder;
    }

    private function getCmdClassDeclaration():ICmdClassDeclaration {
        const ccd:CmdClassDeclaration = new CmdClassDeclaration();
        ccd.classMap = classMap;
        return ccd
    }

    private function getSignalPhaseCmdMapper( item:ICmdClassDeclaration ):ISignalPhaseCmdMapper {
        var o:Object;

        if ( item.hasGuards && item.hasFallback )
            o = new MapGuardedCmdsWithFallback();

        if ( item.hasGuards && !item.hasFallback )
            o = new MapGuardedCmds();

        if ( !item.hasGuards && !item.hasFallback || !item.hasGuards && item.hasFallback )
            o = new MapUnguardedCmds();

        o.signalCommandMap = _signalCommandMap;

        return o as ISignalPhaseCmdMapper;
    }

    private function get classMap():IClassMap {
        return  _classMap || ( _classMap = new ClassMap()  )
    }
}
}