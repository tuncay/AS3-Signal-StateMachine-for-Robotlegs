package org.osflash.statemachine.decoding {

import flash.utils.describeType;

import org.osflash.statemachine.decoding.IClassReflector;
import org.osflash.statemachine.transitioning.SignalStateTransitionPhases;
import org.osflash.statemachine.uids.IUID;

internal class ClassReflector implements IClassReflector {

    private var _pkg:String;
    private var _name:String;
    private var _payload:Class;

    public function ClassReflector( c:Class ):void {
        _payload = c;
        describeClass( c );
    }

    public function get name():String {
        return _name;
    }

    public function get payload():Class {
        return _payload;
    }

    public function get pkg():String {
        return _pkg;
    }

    public function toString():String {
        return _pkg + "." + _name;
    }

    public function equals( value:Object ):Boolean {
        return (( value.toString() == _pkg + "." + _name ) ||
                ( value.toString() == _pkg + "::" + _name ) ||
                ( value.toString() == _name ) ||
                ( value == _payload )                            );
    }

    public function destroy():void {
        _payload = null;
        _name = null;
        _pkg = null;
    }

    private function describeClass( c:Class ):void {
        var description:XML = describeType( c );
        var split:Array = description.@name.toString().split( "::" );
        _pkg = String( split[0] );
        _name = String( split[1] );
    }
}
}
