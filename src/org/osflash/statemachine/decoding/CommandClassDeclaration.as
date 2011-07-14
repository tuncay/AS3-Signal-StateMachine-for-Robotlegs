package org.osflash.statemachine.decoding {

internal class CommandClassDeclaration {

    private var _commandClassName:String;
    private var _fallbackCommandClassName:String;
    private var _guardCommandClassNames:Vector.<String>;

    public function CommandClassDeclaration( commandClassDef:XML ) {
        decode( commandClassDef );
    }

    public function get commandClassName():String {
        return _commandClassName;
    }

     public function get hasFallback():Boolean {
        return ( _fallbackCommandClassName != null ) &&
               ( _fallbackCommandClassName != "" ) &&
               (_guardCommandClassNames != null );
    }

    public function get fallbackCommandClassName():String {
        return _fallbackCommandClassName;
    }

    public function get guardCommandClassNames():Vector.<String> {
        return _guardCommandClassNames;
    }

    public function decode( commandClassDef:XML ):void {
        _commandClassName = commandClassDef.@classPath.toString();
        _fallbackCommandClassName = (commandClassDef.@fallback == undefined ) ? null : commandClassDef.@fallback.toString();
        _guardCommandClassNames = decodeGuards( commandClassDef.guardClass.@classPath );
    }



    private function decodeGuards( list:XMLList ):Vector.<String> {
        if ( list.length() == 0 )return null;
        var a:Vector.<String> = new <String>[];
        for each ( var xml:XML in list ) {
            a.push( xml.toString() );
        }
        return a;
    }


}
}
