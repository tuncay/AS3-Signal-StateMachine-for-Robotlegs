package org.osflash.statemachine.transitioning.phases {

import org.osflash.statemachine.core.ISignalStateOwner;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.transitioning.ITransitionPhase;
import org.osflash.statemachine.uids.IUID;

public class BaseSignalStatePhase implements ITransitionPhase {

    protected const CANCEL_TRANSITION:Boolean = false;
    protected const CONTINUE_TRANSITION:Boolean = true;

    private var _model:IPhaseModel;
    private var _logger:IStateLogger;

    public function get currentState():ISignalStateOwner {
        return ISignalStateOwner( _model.currentState );
    }

    public function get targetState():ISignalStateOwner {
        return ISignalStateOwner( _model.targetState );
    }

    public function set model( value:IPhaseModel ):void {
        _model = value
    }

    public function set logger( value:IStateLogger ):void {
        _logger = value;
    }

    public function dispatch():Boolean {
        return runPhase( _model );
    }

    protected function runPhase( model:IPhaseModel ):Boolean {
        return CONTINUE_TRANSITION;
    }

    public function log( msg:String ):void {
        if ( _logger == null ) return;
        _logger.log( msg );
    }

    public function logPhase( phase:IUID ):void {
        if ( _logger == null ) return;
        _logger.logPhase( phase, _model.referringTransition, _model.currentState )

    }

    public function logStateChange():void {
        if ( _logger == null ) return;
        _logger.logStateChange( _model.currentState, _model.targetState );
    }

    public function logCancellation():void {
        if ( _logger == null ) return;
        _logger.logCancellation( _model.cancellationReason, _model.referringTransition, _model.currentState );
    }
}
}
