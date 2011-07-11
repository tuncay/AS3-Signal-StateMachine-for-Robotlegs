package org.osflash.statemachine.signals {
import org.osflash.signals.PrioritySignal;
import org.osflash.statemachine.core.IPayload;

public class Cancelled extends PrioritySignal {
		public function Cancelled(){
			super( String, IPayload );
		}
	}
}