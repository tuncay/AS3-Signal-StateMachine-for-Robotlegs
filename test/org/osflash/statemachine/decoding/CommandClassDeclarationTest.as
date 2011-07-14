package org.osflash.statemachine.decoding {

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;

public class CommandClassDeclarationTest {

    private var _testSubject:CommandClassDeclaration;



    public function initTestSubject(xml:XML):void {
        _testSubject = new CommandClassDeclaration( xml );
    }

    [After]
    public function after():void {
        _testSubject = null;
    }

        [Test]
    public function commandClassName__in_command_class_only_declaration__is_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.commandClassName, equalTo( "SampleCommandC" ) );
    }

    [Test]
    public function hasFallBack__in_command_class_only_declaration__returns_false():void {
         initTestSubject( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function fallbackCommandClassName__in_command_class_only_declaration__is_null():void {
        initTestSubject( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.fallbackCommandClassName, nullValue() );
    }

    [Test]
    public function guardCommandClassNames__in_command_class_only_declaration__is_null():void {
        initTestSubject( COMMAND_CLASS_ONLY_DECLARATION );
        assertThat( _testSubject.guardCommandClassNames, nullValue() );
    }

        [Test]
    public function hasFallBack__in_command_class_with_fallback_declaration__returns_false():void {
         initTestSubject( COMMAND_CLASS_DECLARATION_WITH_FALLBACK );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function commandClassName__in_full_declaration__is_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.commandClassName, equalTo( "SampleCommandC" ) );
    }

    [Test]
    public function hasFallBack__in_full_declaration__returns_true():void {
         initTestSubject( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.hasFallback, isTrue() );
    }

    [Test]
    public function fallbackCommandClassName__in_full_declaration__is_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.fallbackCommandClassName, equalTo( "SampleCommandF" ) );
    }

    [Test]
    public function guardCommandClassNames__in_full_declaration__are_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_FULL_DECLARATION );
        assertThat( _testSubject.guardCommandClassNames, array( equalTo("HappyGuard"), equalTo("GrumpyGuard")) );
    }

     [Test]
    public function commandClassName__in_command_class_with_guards_declaration__is_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_DECLARATION_WITH_GUARDS);
        assertThat( _testSubject.commandClassName, equalTo( "SampleCommandC" ) );
    }

    [Test]
    public function hasFallBack__in_command_class_with_guards_declaration__returns_false():void {
         initTestSubject( COMMAND_CLASS_DECLARATION_WITH_GUARDS );
        assertThat( _testSubject.hasFallback, isFalse() );
    }

    [Test]
    public function fallbackCommandClassName__in_command_class_with_guards_declaration__is_null():void {
        initTestSubject( COMMAND_CLASS_DECLARATION_WITH_GUARDS );
        assertThat( _testSubject.fallbackCommandClassName, nullValue() );
    }

    [Test]
    public function guardCommandClassNames__in_command_class_with_guards_declaration__are_decoded_correctly():void {
        initTestSubject( COMMAND_CLASS_DECLARATION_WITH_GUARDS );
        assertThat( _testSubject.guardCommandClassNames, array( equalTo("GrumpyGuard"), equalTo("HappyGuard")) );
    }


    private const COMMAND_CLASS_ONLY_DECLARATION:XML =
                  <commandClass classPath="SampleCommandC"/> ;

     private const COMMAND_CLASS_DECLARATION_WITH_FALLBACK:XML =
                  <commandClass classPath="SampleCommandC" fallback="SampleCommandF"/> ;

      private const COMMAND_CLASS_DECLARATION_WITH_GUARDS:XML =
                  <commandClass classPath="SampleCommandC">
                            <guardClass classPath="GrumpyGuard" />
                            <guardClass classPath="HappyGuard" />
                        </commandClass>

     private const COMMAND_CLASS_FULL_DECLARATION:XML =
                  <commandClass classPath="SampleCommandC" fallback="SampleCommandF">
                            <guardClass classPath="HappyGuard" />
                            <guardClass classPath="GrumpyGuard" />
                        </commandClass>

}
}
