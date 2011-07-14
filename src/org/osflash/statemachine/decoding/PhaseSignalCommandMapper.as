package org.osflash.statemachine.decoding {

import org.osflash.signals.ISignal;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class PhaseSignalCommandMapper {

    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _classMap:ClassMap;
    private var _errors:Vector.<String>;

    public function PhaseSignalCommandMapper( signalCommandMap:IGuardedSignalCommandMap, classMap:ClassMap ) {
        _signalCommandMap = signalCommandMap;


        _classMap = classMap;
        _errors = new <String>[];
    }

    public function mapCommandClassToPhaseSignal( item:CommandClassDeclaration, signal:ISignal ):Vector.<String> {
        if ( item.guardCommandClassNames == null ) {
            mapUnguardedCommands( item, signal );
        } else {
            mapGuardedSignalCommand( item, signal )
        }
        return _errors;
    }

    private function mapUnguardedCommands( item:CommandClassDeclaration, signal:ISignal ):void {
        var commandClass:Class = getAndValidateClass( item.commandClassName );
        if( commandClass == null )return;
        if ( !hasMapping( signal, commandClass ) )  {
           _signalCommandMap.mapSignal( signal, commandClass );
        }  else {
            /* throw new StateDecodingError( COMMAND_CLASS_CAN_BE_MAPPED_ONCE_ONLY_TO_SAME_SIGNAL );*/
        }
    }

    private function mapGuardedSignalCommand( item:CommandClassDeclaration, signal:ISignal ):void {
        var guardClasses:Array = retrieveGuardClasses( item );
        var commandClass:Class = getAndValidateClass( item.commandClassName );
        var fallBackCommandClass:Class = ( item.hasFallback ) ? getAndValidateClass( item.fallbackCommandClassName ) : null;
        if ( fallBackCommandClass == null )
            _signalCommandMap.mapGuardedSignal( signal, commandClass, guardClasses );
        else
            _signalCommandMap.mapGuardedSignalWithFallback( signal, commandClass, fallBackCommandClass, guardClasses );
    }

    private function retrieveGuardClasses( item:CommandClassDeclaration ):Array  {
         var returnValue:Array = [];
        for each ( var guardClassName:String in item.guardCommandClassNames ) {
            var g:Class = getAndValidateClass( guardClassName );
            if ( g != null )returnValue.push( g );
        }
        return returnValue;
    }

    private function hasMapping( signal:ISignal, commandClass:Class ):Boolean {
        return ( _signalCommandMap.hasSignalCommand( signal, commandClass ) );
    }

     private function getAndValidateClass( name:Object ):Class {
        var c:Class = _classMap.getClass( name );
        if ( c == null ) _errors.push( name.toString() );
        return c;
    }
}
}
