package org.osflash.statemachine.decoding {

import flash.events.Event;

import mockolate.prepare;
import mockolate.received;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.core.anything;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.decoding.helpers.ICreatable;
import org.osflash.statemachine.decoding.helpers.ISignalPhaseDecoder;
import org.osflash.statemachine.support.CommandA;

public class SignalXMLStateDecoderTest {

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( ICreatable, ISignalPhaseDecoder, IClassMap ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        initSupport();
        initTestSubject();
    }

    [After]
    public function after():void {
        _stateDecoder = null;
        _factory = null;
        _phaseDecoder = null;
        _classMap = null;
    }

    [Test]
    public function phase_declaration_undefined__signals_are_not_created():void {
        const expected:String = "false,false,false,false,false";
        const state:ISignalState = _stateDecoder.decodeState( UNDEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function entered_phase_declaration__only_entered_signal_created():void {
        const expected:String = "true,false,false,false,false";
        const state:ISignalState = _stateDecoder.decodeState( ENTERED_DEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function enteringGuard_phase_declaration__only_enteringGuard_signal_created():void {
        const expected:String = "false,true,false,false,false";
        const state:ISignalState = _stateDecoder.decodeState( ENTERING_GUARD_DEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function exitingingGuard_phase_declaration__only_exitingingGuard_signal_created():void {
        const expected:String = "false,false,true,false,false";
        const state:ISignalState = _stateDecoder.decodeState( EXITING_GUARD_DEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function tearDown_phase_declaration__only_tearDown_signal_created():void {
        const expected:String = "false,false,false,true,false";
        const state:ISignalState = _stateDecoder.decodeState( TEARDOWN_DEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function cancelled_phase_declaration__only_cancelled_signal_created():void {
        const expected:String = "false,false,false,false,true";
        const state:ISignalState = _stateDecoder.decodeState( CANCELLED_DEFINED_PHASES, 16 ) as ISignalState;
        const got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function phase_declaration_undefined__phaseDecoder_never_created():void {
        const state:ISignalState = _stateDecoder.decodeState( UNDEFINED_PHASES, 16 ) as ISignalState;
        assertThat( _factory, received().method( "create" ).args( ISignalPhaseDecoder ).never() );
    }

    [Test]
    public function phase_declaration___signals_are_not_created():void {
        const expected:String = "true,false,true,false,true";
        const state:ISignalState = _stateDecoder.decodeState( THREE_DEFINED_PHASES, 16 ) as ISignalState;
        var got:String = stringifyHasStateAllSignals( state );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function phase_declaration__phaseDecoder_called_for_each_declared_phase():void {
        const state:ISignalState = _stateDecoder.decodeState( THREE_DEFINED_PHASES, 16 ) as ISignalState;
        assertThat( _factory, received().method( "create" ).args( ISignalPhaseDecoder ).times( 3 ) );
    }

    [Test]
    public function index_passed_to_state():void {
        const state:ISignalState = _stateDecoder.decodeState( THREE_DEFINED_PHASES, 16 ) as ISignalState;
        assertThat( state.index, equalTo( 16 ) );
    }

    [Test]
    public function hasClass_calls_hasClass_on_classMap():void {
        _stateDecoder.hasClass( "CommandA" );
        assertThat( _classMap, received().method( "hasClass" ).args( equalTo( "CommandA" ) ) );
    }

    [Test]
    public function getClass_calls_getClass_on_classMap():void {
        _stateDecoder.getClass( "CommandA" );
        assertThat( _classMap, received().method( "getClass" ).args( equalTo( "CommandA" ) ) );
    }

    [Test]
    public function addClass_calls_addClass_on_classMap():void {
        _stateDecoder.addClass( CommandA );
        assertThat( _classMap, received().method( "addClass" ).args( strictlyEqualTo( CommandA ) ) );
    }


    private function stringifyHasStateAllSignals( state:ISignalState ):String {
        const got:String = [
            state.hasEntered,
            state.hasEnteringGuard,
            state.hasExitingGuard,
            state.hasTearDown ,
            state.hasCancelled
        ].join( "," );
        return got;
    }

    private function initSupport():void {
        _factory = strict( ICreatable );
        _phaseDecoder = strict( ISignalPhaseDecoder );
        _classMap = strict( IClassMap );

        stub( _classMap ).method( "addClass" ).args( instanceOf( Class ) ).returns( true );
        stub( _classMap ).method( "hasClass" ).args( instanceOf( String ) ).returns( true );
        stub( _classMap ).method( "getClass" ).args( instanceOf( String ) ).returns( CommandA );

        stub( _phaseDecoder ).method( "decodePhase" ).args( instanceOf( XMLList ), instanceOf( ISignal ) );

        stub( _factory ).method( "create" ).args( ISignalPhaseDecoder ).returns( _phaseDecoder );
        stub( _factory ).method( "create" ).args( IClassMap ).returns( _classMap );
        stub( _classMap ).getter( "hasErrors" ).returns( false );
    }

    private function initTestSubject():void {
        _stateDecoder = new SignalXMLStateDecoder( _factory );
    }

      private var _stateDecoder:SignalXMLStateDecoder;
    private var _factory:ICreatable;
    private var _phaseDecoder:ISignalPhaseDecoder;
    private var _classMap:IClassMap;
    private const UNDEFINED_PHASES:XML = <state name="state/testing"/>;
    private const ENTERED_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <entered/>
                  </state>;

    private const ENTERING_GUARD_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <enteringGuard/>
                  </state>;

    private const EXITING_GUARD_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <exitingGuard/>
                  </state>;

    private const TEARDOWN_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <tearDown/>
                  </state>;

    private const CANCELLED_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <cancelled/>
                  </state>;

    private const THREE_DEFINED_PHASES:XML =
                  <state name="state/testing">
                      <entered/>
                      <exitingGuard/>
                      < cancelled/>
                  </state>
    ;
}
}
