package org.osflash.statemachine.decoding.helpers {

import flash.events.Event;

import mockolate.mock;

import mockolate.nice;

import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;
import mockolate.verify;

import mx.events.ItemClickEvent;

import org.flexunit.async.Async;
import org.hamcrest.collection.array;
import org.hamcrest.core.anything;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.support.GrumpyGuard;
import org.osflash.statemachine.support.HappyGuard;
import org.osflash.statemachine.support.SampleCommandA;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class MapGuardedCmdsTest {

    private var _testSubject:MapGuardedCmds;
    private var _signal:ISignal;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _cmdClassDeclaration:ICmdClassDeclaration;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( IGuardedSignalCommandMap, ISignal, ICmdClassDeclaration ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        initSupporting();
        initTestSubject();
    }

    [After]
    public function after():void {
        _testSubject = null;
        _signal = null;
        _signalCommandMap = null;
        _cmdClassDeclaration = null;
    }

    [Test]
    public function args_are_passed_correctly_to_mapGuardedSignal_on_signalCommandMap():void {
        stubCmdClassDeclaration();
        mockSignalCmdMap();
        _testSubject.mapToPhaseSignal( _cmdClassDeclaration, _signal );
        verify( _signalCommandMap );
    }

    [Test]
    public function null_commandClass():void {
        stubNullCmdClassDeclaration();
        mockSignalCmdMapForNull();
        _testSubject.mapToPhaseSignal( _cmdClassDeclaration, _signal );
        verify( _signalCommandMap );
    }

    private function stubCmdClassDeclaration():void {
        stub( _cmdClassDeclaration ).getter( "commandClass" ).returns( SampleCommandA );
        stub( _cmdClassDeclaration ).getter( "guardClasses" ).returns( [GrumpyGuard, HappyGuard] );
    }

     private function stubNullCmdClassDeclaration():void {
        stub( _cmdClassDeclaration ).getter( "commandClass" ).returns( null );
        stub( _cmdClassDeclaration ).getter( "guardClasses" ).returns( [GrumpyGuard, HappyGuard] );
    }

    private function mockSignalCmdMap():void {
        mock( _signalCommandMap )
        .method( "mapGuardedSignal" )
        .args( strictlyEqualTo( _signal ), SampleCommandA, array( strictlyEqualTo( GrumpyGuard ), strictlyEqualTo( HappyGuard ) ) )
        .once();
    }

     private function mockSignalCmdMapForNull():void {
        mock( _signalCommandMap )
        .method( "mapGuardedSignal" )
        .args( anything() )
        .never();
    }

    private function initSupporting():void {
        _signalCommandMap = strict( IGuardedSignalCommandMap );
        _signal = nice( ISignal );
        _cmdClassDeclaration = nice( ICmdClassDeclaration );
    }

    private function initTestSubject():void {
        _testSubject = new MapGuardedCmds();
        _testSubject.signalCommandMap = _signalCommandMap;
    }
}
}
