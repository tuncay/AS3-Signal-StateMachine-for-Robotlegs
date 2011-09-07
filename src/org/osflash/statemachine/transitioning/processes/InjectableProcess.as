package org.osflash.statemachine.transitioning.processes {

import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.transitioning.Process;

public class InjectableProcess extends Process{

    [Inject]
    override public function set fsmController(value:IFSMController):void{
        super.fsmController = value;
    }

    [Inject]
    override public function set fsmProperties(value:IFSMProperties):void{
        super.fsmProperties = value;
    }

}
}
