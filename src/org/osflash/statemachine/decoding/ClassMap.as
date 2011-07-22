package org.osflash.statemachine.decoding {

public class ClassMap implements IClassMap {

    private var _reflectorMap:Vector.<IClassReflector>;
    private var _errors:Vector.<String>;

    public function ClassMap( ) {
        _reflectorMap = new <IClassReflector>[];
    }

    public function get errors():Vector.<String> {
        return _errors;
    }

    public function get hasErrors():Boolean {
        return !(_errors == null || _errors.length == 0);
    }

    public function addClass( value:Class ):Boolean {
        if ( hasClass( value ) ) return false;
        _reflectorMap.push( new ClassReflector( value ) );
        return true;
    }

    public function hasClass( name:Object ):Boolean {
        return ( retrieveClass( name ) != null );
    }

    public function getClass( name:Object ):Class {
        const classRef:Class = retrieveClass( name );
        if(classRef == null )errorList.push( name );
        return classRef;
    }

     private function retrieveClass( name:Object ):Class {
        for each ( var cb:ClassReflector in _reflectorMap ) {
            if ( cb.equals( name ) ) return cb.payload;
        }
        return null;
    }

    private function get errorList():Vector.<String> {
        return _errors || (_errors = new <String>[]);
    }

}
}
