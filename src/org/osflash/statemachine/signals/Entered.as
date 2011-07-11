package org.osflash.statemachine.signals {
import org.osflash.signals.PrioritySignal;
import org.osflash.statemachine.core.IPayload;

public class Entered extends PrioritySignal {
		public function Entered(){
			super( IPayload );
		}
	}
}