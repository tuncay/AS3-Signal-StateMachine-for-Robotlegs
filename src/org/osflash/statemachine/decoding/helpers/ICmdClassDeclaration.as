package org.osflash.statemachine.decoding.helpers {

import org.osflash.statemachine.decoding.IClassMap;

public interface ICmdClassDeclaration {
    function get commandClass():Class;

    function get hasFallback():Boolean;

    function get hasGuards():Boolean;

    function get fallbackCommandClass():Class;

    function get guardClasses():Array;

    function decode( commandClassDef:XML ):ICmdClassDeclaration
}
}
