package org.osflash.statemachine.signals {
import org.osflash.signals.PrioritySignal;
import org.osflash.statemachine.core.IPayload;

public class EnteringGuard extends PrioritySignal {
		public function EnteringGuard(){
			super( IPayload );
		}
	}
}