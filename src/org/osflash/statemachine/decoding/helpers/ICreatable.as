package org.osflash.statemachine.decoding.helpers {

public interface ICreatable {
    function create( id:Class, ...rest ):Object;
}
}
