package org.osflash.statemachine.decoding.helpers {

import flash.events.Event;

import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.decoding.ClassMap;
import org.osflash.statemachine.decoding.IClassMap;
import org.osflash.statemachine.support.GrumpyGuard;
import org.osflash.statemachine.support.HappyGuard;
import org.osflash.statemachine.support.SampleCommandA;
import org.osflash.statemachine.support.SampleCommandB;

public class CmdClassDeclarationTest {

    private var _testSubject:CmdClassDeclaration;
    private var _classMap:IClassMap;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void {
        Async.proceedOnEvent( this,
        prepare( ClassMap ),
        Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void {
        initSupporting();
        initTestSubject();
        stubClassMapForFullDeclaration();
    }


    [After]
    public function after():void {
        _testSubject = null;
        _classMap = null;
    }

    [Test]
    public function hasFallback__if_no_fallback_declared__returns_false():void {
       _testSubject.decode( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function hasFallback__if_fallback_declared_but_no_guards__returns_false():void {
         _testSubject.decode( COMMAND_CLASS_DECLARATION_WITH_FALLBACK_ONLY );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function hasFallback__if_guards_declared_but_no_fallback__returns_false():void {
         _testSubject.decode( COMMAND_CLASS_DECLARATION_WITH_GUARDS );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function hasFallback__if_fallback_and_guards_declared__returns_true():void {
         _testSubject.decode( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.hasFallback, isTrue() );
    }

    [Test]
    public function hasGuards__if_no_guards_declared__returns_false():void {
         _testSubject.decode( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.hasGuards, isFalse() );
    }

    [Test]
    public function hasGuards__if_guards_declared__returns_true():void {
         _testSubject.decode( COMMAND_CLASS_DECLARATION_WITH_GUARDS );
        assertThat( _testSubject.hasGuards, isTrue() );
    }


    [Test]
    public function command_class_passed_to_commandClass_getter():void {
         _testSubject.decode( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.commandClass, strictlyEqualTo( SampleCommandA ) );
    }

    [Test]
    public function fallback_command_class_passed_to_fallbackCommandClass_getter():void {
         _testSubject.decode( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.fallbackCommandClass, strictlyEqualTo( SampleCommandB ) );
    }

    [Test]
    public function guard_command_classes_passed_to_guardClasses_getter():void {
         _testSubject.decode( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.guardClasses,
        array(
            strictlyEqualTo( HappyGuard ),
            strictlyEqualTo( GrumpyGuard ),
            strictlyEqualTo( HappyGuard )
        ) );
    }

    public function initTestSubject():void {
        _testSubject = new CmdClassDeclaration();
        _testSubject.classMap = _classMap;
    }

    private function initSupporting():void {
        _classMap = strict( ClassMap );
    }

    private function stubClassMapForFullDeclaration():void {
        stubClassMapWithClassRefAndName( "SampleCommandA", SampleCommandA );
        stubClassMapWithClassRefAndName( "SampleCommandB", SampleCommandB );
        stubClassMapWithClassRefAndName( "HappyGuard", HappyGuard );
        stubClassMapWithClassRefAndName( "GrumpyGuard", GrumpyGuard );
    }

    public function stubClassMapWithClassRefAndName( name:String, classRef:Class ):void {
        stub( _classMap ).method( "getClass" ).args( name ).returns( classRef );
    }


    private const COMMAND_CLASS_ONLY_DECLARATION:XML =
                  <commandClass classPath="SampleCommandA"/>;

    private const COMMAND_CLASS_DECLARATION_WITH_FALLBACK_ONLY:XML =
                  <commandClass classPath="SampleCommandA" fallback="SampleCommandB"/>;

    private const COMMAND_CLASS_DECLARATION_WITH_GUARDS:XML =
                  <commandClass classPath="SampleCommandB">
                      <guardClass classPath="GrumpyGuard" />
                      <guardClass classPath="HappyGuard" />
                  </commandClass>

    private const COMMAND_CLASS_FULL_DECLARATION:XML =
                  <commandClass classPath="SampleCommandA" fallback="SampleCommandB">
                      <guardClass classPath="HappyGuard" />
                      <guardClass classPath="GrumpyGuard" />
                      <guardClass classPath="HappyGuard" />
                  </commandClass>


}
}
