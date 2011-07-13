package org.osflash.statemachine.decoding {

public class ClassMap {

    private var _reflectorMap:Vector.<IClassReflector>;

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
        return null;
    }

    private function reflectorMap():Vector.<IClassReflector> {
        return _reflectorMap || ( _reflectorMap = new <IClassReflector>[]);
    }

}
}
