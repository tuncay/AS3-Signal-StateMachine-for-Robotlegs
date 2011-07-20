package org.osflash.statemachine.decoding.helpers {

import flash.events.Event;

import mockolate.nice;
import mockolate.prepare;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.decoding.IClassMap;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class SignalPhaseDecoderFactoryTest {

    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _testSubject:SignalPhaseDecoderFactory;
    private var _cmdClassDeclaration:ICmdClassDeclaration;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( GuardedSignalCommandMap, CmdClassDeclaration ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        _signalCommandMap = nice( GuardedSignalCommandMap );
        _cmdClassDeclaration = nice( CmdClassDeclaration );
        _testSubject = new SignalPhaseDecoderFactory( _signalCommandMap )
    }

    [After]
    public function after():void {
        _signalCommandMap = null;
        _testSubject = null;
        _cmdClassDeclaration = null;
    }

    [Test]
    public function IClassMap_returns_singleton_instance_of_IClassMap():void {
        const getOnce:IClassMap = IClassMap( _testSubject.create( IClassMap ) );
        const getTwice:IClassMap = IClassMap( _testSubject.create( IClassMap ) );
        assertThat( getOnce, strictlyEqualTo( getTwice ) );
    }

    [Test]
    public function ISignalPhaseDecoder_returns_instance_of_ISignalPhaseDecoder():void {
        assertThat( _testSubject.create( ISignalPhaseDecoder ), instanceOf( ISignalPhaseDecoder ) );
    }

    [Test]
    public function ISignalPhaseDecoder_injected_with_factory():void {
        assertThat( _testSubject.create( ISignalPhaseDecoder ).factory, strictlyEqualTo( _testSubject ) );
    }

    [Test]
    public function ICmdClassDeclaration_returns_instance_of_ICmdClassDeclaration():void {
        assertThat( _testSubject.create( ICmdClassDeclaration ), instanceOf( ICmdClassDeclaration ) );
    }

     [Test]
    public function ICmdClassDeclaration_injected_with_IClassMap():void {
        assertThat( _testSubject.create( ICmdClassDeclaration ).classMap, strictlyEqualTo( _testSubject.create(IClassMap) ) );
    }

    [Test]
    public function ISignalPhaseCmdMapper__with_guards_and_fallback__returns_instance_of_MapGuardedCmdsWithFallback():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( true );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( true );
        assertThat( _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration ), instanceOf( MapGuardedCmdsWithFallback ) );
    }

    [Test]
    public function MapGuardedCmdsWithFallback_injected_with_SignalCommandMap():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( true );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( true );
        const product:Object = _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration );
        assertThat( product.signalCommandMap, strictlyEqualTo( _signalCommandMap ) );
    }

    [Test]
    public function ISignalPhaseCmdMapper__with_guards_no_fallback__returns_instance_of_MapGuardedCmds():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( true );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( false );
        assertThat( _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration ), instanceOf( MapGuardedCmds ) );
    }

     [Test]
    public function MapGuardedCmds_injected_with_SignalCommandMap():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( true );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( false );
        const product:Object = _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration );
        assertThat( product.signalCommandMap, strictlyEqualTo( _signalCommandMap ) );
    }

    [Test]
    public function ISignalPhaseCmdMapper__no_guards_no_fallback__returns_instance_of_MapUnguardedCmds():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( false );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( false );
        assertThat( _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration ), instanceOf( MapUnguardedCmds ) );
    }

    [Test]
    public function ISignalPhaseCmdMapper__no_guards_with_fallback__returns_instance_of_MapUnguardedCmds2():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( false );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( true );
        assertThat( _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration ), instanceOf( MapUnguardedCmds ) );
    }

     [Test]
    public function MapUnguardedCmds__no_guards_no_fallback__returns_instance_of_MapUnguardedCmds():void {
        stub( _cmdClassDeclaration ).getter( "hasGuards" ).returns( false );
        stub( _cmdClassDeclaration ).getter( "hasFallback" ).returns( false );
        const product:Object = _testSubject.create( ISignalPhaseCmdMapper, _cmdClassDeclaration );
        assertThat( product.signalCommandMap, strictlyEqualTo( _signalCommandMap ) );
    }
}
}
