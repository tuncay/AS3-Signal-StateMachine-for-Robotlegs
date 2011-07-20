package org.osflash.statemachine.decoding {

public class ClassMap implements IClassMap {

    private var _reflectorMap:Vector.<IClassReflector>;
    private var _errors:Vector.<String>;

    public function get errors():Vector.<String> {
        return _errors;
    }

    public function get hasErrors():Boolean {
        return !(_errors == null || _errors.length == 0);
    }

    public function addClass( value:Class ):Boolean {
        if ( hasClass( value ) ) return false;
        reflectorMap.push( new ClassReflector( value ) );
        return true;
    }

    public function hasClass( name:Object ):Boolean {
        return ( getClass( name ) != null );
    }

    public function getClass( name:Object ):Class {
        for each ( var cb:ClassReflector in reflectorMap ) {
            if ( cb.equals( name ) ) return cb.payload;
        }
        errorList.push( name );
        return null;
    }

    private function get errorList():Vector.<String> {
        return _errors || (_errors = new <String>[]);
    }

    private function get reflectorMap():Vector.<IClassReflector> {
        return _reflectorMap || ( _reflectorMap = new <IClassReflector>[]);
    }

}
}
