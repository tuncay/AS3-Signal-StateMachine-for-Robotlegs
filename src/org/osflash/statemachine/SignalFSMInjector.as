package org.osflash.statemachine {

import org.osflash.statemachine.base.StateMachine;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.core.IStateProvider;
import org.osflash.statemachine.decoding.IStateModelDecoder;
import org.osflash.statemachine.decoding.SignalXMLStateDecoder;
import org.osflash.statemachine.decoding.StateModelDecoder;
import org.osflash.statemachine.decoding.StateXMLValidator;
import org.osflash.statemachine.decoding.helpers.ICreatable;
import org.osflash.statemachine.decoding.helpers.SignalPhaseDecoderFactory;
import org.osflash.statemachine.model.IPhaseModel;
import org.osflash.statemachine.model.IStateModel;
import org.osflash.statemachine.model.ITransitionModel;
import org.osflash.statemachine.model.ITransitionProperties;
import org.osflash.statemachine.model.PhaseModel;
import org.osflash.statemachine.model.StateModel;
import org.osflash.statemachine.model.TransitionModel;
import org.osflash.statemachine.model.TransitionProperties;
import org.osflash.statemachine.transitioning.validators.CancellationValidator;
import org.osflash.statemachine.transitioning.IPhaseDispatcher;
import org.osflash.statemachine.transitioning.ITransitionController;
import org.osflash.statemachine.transitioning.SignalStatePhaseDispatcher;
import org.osflash.statemachine.transitioning.TransitionController;
import org.osflash.statemachine.transitioning.validators.TransitionValidator;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class SignalFSMInjector {

    private var _decoder:SignalXMLStateDecoder;
    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _fsmInjector:IStateModelDecoder;
    private var _stateMachine:StateMachine;
    private var _stateModel:IStateModel;

    public function SignalFSMInjector( injector:IInjector, signalCommandMap:IGuardedSignalCommandMap ) {
        _injector = injector;
        _signalCommandMap = signalCommandMap;
    }

    public function initiate( stateDefinition:XML, logger:IStateLogger = null ):void {
        const stateModel:IStateModel = new StateModel();
        const transitionProperties:ITransitionProperties = new TransitionProperties();
        const transitionModel:ITransitionModel = new TransitionModel( stateModel, transitionProperties );
        const phaseModel:IPhaseModel = new PhaseModel( stateModel, transitionProperties );
        const phaseDispatcher:IPhaseDispatcher = new SignalStatePhaseDispatcher( phaseModel, logger );
        const transitionController:ITransitionController = new TransitionController( transitionModel, phaseDispatcher );
        const decoderFactory:ICreatable = new SignalPhaseDecoderFactory( _signalCommandMap );
        _stateModel = stateModel;
        _stateMachine = new StateMachine( transitionModel, transitionController );
        _stateMachine.setValidators( new TransitionValidator(), new CancellationValidator() );
        _decoder = new SignalXMLStateDecoder(  decoderFactory );
        _decoder.setData( new StateXMLValidator( stateDefinition ) );
        _fsmInjector = new StateModelDecoder( _decoder );
    }

    public function addClass( commandClass:Class ):Boolean {
        return _decoder.addClass( commandClass );
    }

    public function inject():void {
        _fsmInjector.inject( _stateModel );
        _injector.mapValue( IFSMController, _stateMachine );
        _injector.mapValue( IFSMProperties, _stateMachine );
        _injector.mapValue( IStateProvider, _stateModel );
        _stateMachine.transitionToInitialState();
    }


}
}