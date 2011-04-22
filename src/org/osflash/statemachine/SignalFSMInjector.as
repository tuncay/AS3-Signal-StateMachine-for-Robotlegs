package org.osflash.statemachine {
import org.osflash.statemachine.base.BaseStateMachine;
import org.osflash.statemachine.base.StateModel;
import org.osflash.statemachine.base.StateModelInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IStateLogger;
import org.osflash.statemachine.core.IStateModel;
import org.osflash.statemachine.core.IStateModelInjector;
import org.osflash.statemachine.core.IStateModelOwner;
import org.osflash.statemachine.decoding.SignalXMLStateDecoder;
import org.osflash.statemachine.transitioning.SignalTransitionController;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

/**
	 * A helper class that wraps the injection of the Signal StateMachine
	 * to simplify creation.
	 */
	public class SignalFSMInjector {

		/**
		 * @private
		 */
		private var _decoder:SignalXMLStateDecoder;

		/**
		 * @private
		 */
		private var _injector:IInjector;

		/**
		 * @private
		 */
		private var _signalCommandMap:IGuardedSignalCommandMap;

		/**
		 * @private
		 */
		private var _fsmInjector:IStateModelInjector;

		/**
		 * @private
		 */
		private var _stateMachine:BaseStateMachine;

		/**
		 * @private
		 */
		private var _model:IStateModelOwner;

		/**
		 * Creates an instance of the injector
		 * @param injector the IInjector into which the StateMachine elements will be injected
		 * @param signalCommandMap the ISignalCommandMap in which the commands will be mapped
		 * to each states' Signals
		 */
		public function SignalFSMInjector( injector:IInjector, signalCommandMap:IGuardedSignalCommandMap ){
			_injector = injector;
			_signalCommandMap = signalCommandMap;
		}

		/**
		 * Initiates the Injector
		 * @param stateDefinition the StateMachine declaration
		 */
		public function initiate( stateDefinition:XML, logger:IStateLogger=null ):void{
			// create a SignalStateDecoder and pass it the State Declaration
			_decoder = new SignalXMLStateDecoder( stateDefinition, _injector, _signalCommandMap );
			// add it the FSMInjector
			_fsmInjector = new StateModelInjector( _decoder );

            _model = new StateModel();
			_stateMachine = new SignalTransitionController( _model, logger );
		}

		/**
		 * Adds a commandClass to the decoder.
		 *
		 * Any Command declared in the StateDeclaration must be added before the StateMachine is injected
		 * @param commandClass a command Class reference
		 * @return Whether the command Class was added successfully
		 */
		public function addClass( commandClass:Class ):Boolean{
			return _decoder.addClass( commandClass );
		}

		/**
		 * Injects the StateMachine
		 */
		public function inject():void{

             _fsmInjector.inject( _model );

			// inject the statemachine (mainly to make sure that it doesn't get GCd )
			_injector.mapValue( IFSMController, _stateMachine );

			// inject the fsmController to allow actors to control fsm
			_injector.mapValue( IFSMProperties, _stateMachine );

            _injector.mapValue( IStateModel, _model );

            _stateMachine.transitionToInitialState();

		}

		/**
		 * The destroy method for GC.
		 *
		 * NB Once injected the instance is no longer needed, so it can be destroyed
		 */
		public function destroy():void{
			_fsmInjector.destroy();
			_fsmInjector = null;
			_decoder = null;
			_injector = null;
			_signalCommandMap = null;

			_stateMachine = null;
			_model = null;
		}
	}
}