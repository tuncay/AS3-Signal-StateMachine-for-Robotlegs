package org.osflash.statemachine.decoding.helpers {

import flash.events.Event;

import mockolate.mock;
import mockolate.nice;
import mockolate.prepare;
import mockolate.received;
import mockolate.strict;
import mockolate.stub;
import mockolate.verify;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.supporting.SampleCommandB;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;

public class MapUnguardedCmdsTest {

    private var _testSubject:MapUnguardedCmds;
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
    public function args_are_passed_correctly_to_mapSignal_on_signalCommandMap():void {
        stubCmdClassDeclaration();
        mockSignalCmdMap();
        _testSubject.mapToPhaseSignal( _cmdClassDeclaration, _signal );
        assertThat( _signalCommandMap, received()
                                       .method( "mapSignal" )
                                       .args( strictlyEqualTo( _signal ), strictlyEqualTo( SampleCommandB ) )
                                       .once() );
    }

    private function stubCmdClassDeclaration():void {
        stub( _cmdClassDeclaration ).getter( "commandClass" ).returns( SampleCommandB );
    }

    private function mockSignalCmdMap():void {
        stub( _signalCommandMap )
        .method( "mapSignal" )
        .args( strictlyEqualTo( _signal ), strictlyEqualTo( SampleCommandB ) )
        .once();
    }

    private function initSupporting():void {
        _signalCommandMap = strict( IGuardedSignalCommandMap );
        _signal = nice( ISignal );
        _cmdClassDeclaration = nice( ICmdClassDeclaration );
    }

    private function initTestSubject():void {
        _testSubject = new MapUnguardedCmds();
        _testSubject.signalCommandMap = _signalCommandMap;
    }
}
}
