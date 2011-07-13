package org.osflash.statemachine.core {
	import org.osflash.signals.ISignal;

	public interface ISignalState extends IState {
		function get entered():ISignal;
		function get hasEntered():Boolean;
		function get enteringGuard():ISignal;
		function get hasEnteringGuard():Boolean;
		function get hasExitingGuard():Boolean;
        function get exitingGuard():ISignal;
		function get cancelled():ISignal;
		function get hasCancelled():Boolean;
		function get tearDown():ISignal;
		function get hasTearDown():Boolean;
	}
}