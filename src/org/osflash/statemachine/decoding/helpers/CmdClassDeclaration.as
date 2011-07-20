package org.osflash.statemachine.decoding.helpers {

import org.osflash.statemachine.decoding.IClassMap;

public class CmdClassDeclaration implements ICmdClassDeclaration {

    public var classMap:IClassMap;

    private var _commandClass:Class;
    private var _fallbackCommandClass:Class;
    private var _guardClasses:Array;

    public function get commandClass():Class {
        return _commandClass;
    }

    public function get hasGuards():Boolean {
        return !(_guardClasses == null || _guardClasses.length == 0)
    }

    public function get hasFallback():Boolean {
        return ( _fallbackCommandClass != null ) &&
               (_guardClasses != null );
    }

    public function get fallbackCommandClass():Class {
        return _fallbackCommandClass;
    }

    public function get guardClasses():Array {
        return _guardClasses;
    }

    public function decode( commandClassDef:XML  ):ICmdClassDeclaration {
        _commandClass = classMap.getClass( commandClassDef.@classPath.toString() );

        _guardClasses = decodeGuards( commandClassDef.guardClass.@classPath, classMap );

        _fallbackCommandClass = (commandClassDef.@fallback == undefined || !hasGuards )
                                ? null
                                : classMap.getClass(commandClassDef.@fallback.toString() );

       return this;
    }

    private function decodeGuards( list:XMLList, classmap:IClassMap ):Array{
        if ( list.length() == 0 )return null;
        var a:Array = [];
        for each ( var xml:XML in list ) {
            a.push( classmap.getClass( xml.toString() ) );
        }
        return a;
    }


}
}
