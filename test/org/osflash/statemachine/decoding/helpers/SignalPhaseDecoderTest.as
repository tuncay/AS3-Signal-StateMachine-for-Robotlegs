package org.osflash.statemachine.decoding.helpers {

import flash.events.Event;

import mockolate.mock;
import mockolate.nice;
import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;
import mockolate.verify;

import org.flexunit.async.Async;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

public class SignalPhaseDecoderTest {

    private var _testSubject:SignalPhaseDecoder;
    private var _factory:ICreatable;
    private var _mapper:ISignalPhaseCmdMapper;
    private var _decoder:ICmdClassDeclaration;
    private var _signal:ISignal;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( SignalPhaseDecoderFactory, MapGuardedCmds, CmdClassDeclaration, Signal ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        initSupporting();
        initTestSubject();
    }

    [After]
    public function after():void {
        disposeMembers();
    }

    [Test]
    public function each_commandClass_element_is_passed_to_decoder__entered_phase():void {
        mockDecoderForEnteredPhase();
        mockMapperForEnteredPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.entered );
        verify( _decoder );
    }

    [Test]
    public function each_CmdClassDefinition_and_Signal_is_passed_to_mapper__entered_phase():void {
        mockDecoderForEnteredPhase();
        mockMapperForEnteredPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.entered );
        verify( _mapper );
    }

    [Test]
    public function each_commandClass_element_is_passed_to_decoder__enteringGuard_phase():void {
        mockDecoderForEnteringGuardPhase();
        mockMapperForEnteringGuardPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.enteringGuard );
        verify( _decoder );
    }

    [Test]
    public function each_CmdClassDefinition_and_Signal_is_passed_to_mapper__enteringGuard_phase():void {
        mockDecoderForEnteringGuardPhase();
        mockMapperForEnteringGuardPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.enteringGuard );
        verify( _mapper );
    }

    [Test]
    public function each_commandClass_element_is_passed_to_decoder__tearDown_phase():void {
        mockDecoderForTearDownPhase();
        mockMapperForTearDownPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.tearDown );
        verify( _decoder );
    }

    [Test]
    public function each_CmdClassDefinition_and_Signal_is_passed_to_mapper__tearDown_phase():void {
        mockDecoderForTearDownPhase();
        mockMapperForTearDownPhase();
        stubFactoryReturnsThenDecodePhase( STATE_DECLARATION.tearDown );
        verify( _mapper );
    }

    private function stubFactoryReturnsThenDecodePhase( xmllist:XMLList ):void {
        stub( _factory ).method( "create" ).args( ICmdClassDeclaration ).returns( _decoder );
        stub( _factory ).method( "create" ).args( ISignalPhaseCmdMapper, ICmdClassDeclaration ).returns( _mapper );

        _testSubject.decodePhase( xmllist, _signal );
    }

    private function mockDecoderForEnteredPhase():void {
        mock( _decoder ).method( "decode" ).args( strictlyEqualTo( STATE_DECLARATION.entered.commandClass[0] ) ).once();
        mock( _decoder ).method( "decode" ).args( strictlyEqualTo( STATE_DECLARATION.entered.commandClass[1] ) ).once();
    }

    private function mockMapperForEnteredPhase():void {
        mock( _mapper ).method( "mapToPhaseSignal" ).args( strictlyEqualTo( _decoder ), strictlyEqualTo( _signal ) ).times( 2 );
    }

    private function mockDecoderForEnteringGuardPhase():void {
        mock( _decoder ).method( "decode" ).never();
    }

    private function mockMapperForEnteringGuardPhase():void {
        mock( _mapper ).method( "mapToPhaseSignal" ).args( strictlyEqualTo( _decoder ), strictlyEqualTo( _signal ) ).never();
    }

    private function mockDecoderForTearDownPhase():void {
        mock( _decoder ).method( "decode" ).args( strictlyEqualTo( STATE_DECLARATION.tearDown.commandClass[0] ) ).once();
        mock( _decoder ).method( "decode" ).args( strictlyEqualTo( STATE_DECLARATION.tearDown.commandClass[1] ) ).once();
        mock( _decoder ).method( "decode" ).args( strictlyEqualTo( STATE_DECLARATION.tearDown.commandClass[2] ) ).once();
    }

    private function mockMapperForTearDownPhase():void {
        mock( _mapper ).method( "mapToPhaseSignal" ).args( strictlyEqualTo( _decoder ), strictlyEqualTo( _signal ) ).times( 3 );
    }

    private function initSupporting():void {
        _factory = nice( SignalPhaseDecoderFactory );
        _signal = nice( Signal );
        _mapper = strict( MapGuardedCmds );
        _decoder = strict( CmdClassDeclaration );
    }

    private function initTestSubject(  ):void {
         _testSubject = new SignalPhaseDecoder();
        _testSubject.factory = _factory
    }

    private function disposeMembers():void {
        _testSubject = null;
        _factory = null;
        _signal = null;
        _mapper = null;
        _decoder = null;
    }


    private const STATE_DECLARATION:XML =
                  <state name="state/testing">
                      <entered>
                          <commandClass classPath="SampleCommandC" fallback="SampleCommandF">
                              <guardClass classPath="HappyGuard" />
                              <guardClass classPath="HappyGuard" />
                          </commandClass>
                          <commandClass classPath="SampleCommandD" fallback="SampleCommandF">
                              <guardClass classPath="GrumpyGuard" />
                              <guardClass classPath="HappyGuard" />
                          </commandClass>
                      </entered>
                      <enteringGuard/>
                      <tearDown>
                          <commandClass classPath="SampleCommandA" fallback="SampleCommandF" >
                              <guardClass classPath="GrumpyGuard" />
                              <guardClass classPath="HappyGuard" />
                          </commandClass>
                          <commandClass classPath="SampleCommandT" fallback="SampleCommandF" >
                              <guardClass classPath="GrumpyGuard" />
                              <guardClass classPath="HappyGuard" />
                          </commandClass>
                          <commandClass classPath="SampleCommandZ" fallback="SampleCommandF">
                              <guardClass classPath="HappyGuard" />
                          </commandClass>
                      </tearDown>

                  </state>

}
}
