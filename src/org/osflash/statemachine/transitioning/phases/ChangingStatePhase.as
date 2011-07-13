package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.model.IPhaseModel;

public class ChangingStatePhase extends BaseSignalStatePhase {


  override protected function runPhase( model:IPhaseModel ):Boolean{
      logStateChange();
      model.setTargetStateAsCurrent();
      return  CONTINUE_TRANSITION;
  }
}
}
