package org.osflash.statemachine.signals {
import org.osflash.signals.PrioritySignal;
import org.osflash.statemachine.core.IPayload;

public class ExitingGuard extends PrioritySignal {
		public function ExitingGuard(){
			super( IPayload );
		}
	}
}