package org.osflash.statemachine.decoding {

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.statemachine.signals.CancelledTest;
import org.osflash.statemachine.signals.EnteredTest;
import org.osflash.statemachine.signals.TearDownTest;

public class ClassMapTest {

    private var _testSubject:ClassMap;

    [Before]
    public function before():void {
        _testSubject = new ClassMap();
    }

    [After]
    public function after():void {
        _testSubject = null;
    }

    [Test]
    public function default_hasClass_returns_false():void {
        assertThat( _testSubject.hasClass( ClassMapTest ), isFalse() );
    }

    [Test]
    public function addClass_success_returns_true():void {
        assertThat( _testSubject.addClass( ClassMapTest ), isTrue() );
    }

    [Test]
    public function hasClass_returns_true_if_class_registered():void {
        addThreeClasses();
        assertThat( _testSubject.hasClass( CancelledTest ), isTrue() );
    }

    [Test]
    public function addClass_returns_false_if_class_already_registered():void {
        addThreeClasses();
        assertThat( _testSubject.addClass( CancelledTest ), isFalse() );
    }

    [Test]
    public function getClass_returns_null_if_empty():void {
        assertThat( _testSubject.getClass( CancelledTest ), nullValue() );
    }

    [Test]
    public function getClass_returns_null_if_class_not_registered():void {
        addThreeClasses();
        assertThat( _testSubject.getClass( TearDownTest ), nullValue() );
    }

    [Test]
    public function getClass_returns_Class_against_itself():void {
        addThreeClasses();
        assertThat( _testSubject.getClass( CancelledTest ), strictlyEqualTo( CancelledTest ) );
    }

    [Test]
    public function getClass_returns_Class_against_name():void {
        addThreeClasses();
        assertThat( _testSubject.getClass( "CancelledTest" ), strictlyEqualTo( CancelledTest ) );
    }

    [Test]
    public function getClass_returns_Class_against_full_package_name():void {
        addThreeClasses();
        assertThat( _testSubject.getClass( "org.osflash.statemachine.signals.CancelledTest" ), strictlyEqualTo( CancelledTest ) );
    }

    [Test]
    public function getClass_returns_Class_against_FQCN():void {
        addThreeClasses();
        assertThat( _testSubject.getClass( "org.osflash.statemachine.signals::CancelledTest" ), strictlyEqualTo( CancelledTest ) );
    }

    [Test]
    public function addClass_does_not_log_any_errors():void {
        addThreeClasses();
        assertThat( _testSubject.hasErrors, isFalse() );
    }

    [Test]
    public function addClass__sets_hasErrors_true__when_none_registered():void {
        addThreeClasses();
        _testSubject.getClass( "NoneExistentClass" );
        assertThat( _testSubject.hasErrors, isTrue() );
    }

    [Test]
    public function getErrors__returns_list_of_classRefName_not_registered():void {
        addThreeClasses();
        _testSubject.getClass( "NoneExistentClassA" );
        _testSubject.getClass( "NoneExistentClassB" );
        _testSubject.getClass( "NoneExistentClassC" );
        assertThat( _testSubject.errors, array( equalTo( "NoneExistentClassA" ), equalTo( "NoneExistentClassB" ), equalTo( "NoneExistentClassC" ) ) );
    }

    private function addThreeClasses():void {
        _testSubject.addClass( ClassMapTest );
        _testSubject.addClass( CancelledTest );
        _testSubject.addClass( EnteredTest );
    }
}
}
