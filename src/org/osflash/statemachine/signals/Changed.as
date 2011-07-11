package org.osflash.statemachine.signals {
import org.osflash.signals.PrioritySignal;

public class Changed extends PrioritySignal {
		public function Changed(){
			super( String );
		}
	}
}