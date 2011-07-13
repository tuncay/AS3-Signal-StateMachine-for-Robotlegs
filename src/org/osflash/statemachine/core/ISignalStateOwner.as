package org.osflash.statemachine.core {

public interface ISignalStateOwner {
    function get hasEntered():Boolean;

    function get hasEnteringGuard():Boolean;

    function get hasExitingGuard():Boolean;

    function get hasCancelled():Boolean;

    function get hasTearDown():Boolean;

    function dispatchEnteringGuard( payload:Object ):void;

    function dispatchExitingGuard( payload:Object ):void;

    function dispatchTearDown():void;

    function dispatchCancelled( reason:String, payload:Object ):void;

    function dispatchEntered( payload:Object ):void;
}
}
