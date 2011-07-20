package org.osflash.statemachine.decoding {

public interface IClassMap {
    function addClass( value:Class ):Boolean;

    function hasClass( name:Object ):Boolean;

    function getClass( name:Object ):Class;

    function get hasErrors():Boolean;
    function get errors():Vector.<String>;
}
}
