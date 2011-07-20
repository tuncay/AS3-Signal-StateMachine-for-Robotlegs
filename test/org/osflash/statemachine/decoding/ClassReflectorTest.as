package org.osflash.statemachine.decoding {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

public class ClassReflectorTest {

    private var _testSubject:IClassReflector;


    [Before]
    public function before():void {
        _testSubject = new ClassReflector( ClassReflectorTest );
    }

    [After]
    public function after():void {
        _testSubject = null;
    }

    [Test]
    public function name_is_name_of_client_class():void {
        assertThat( _testSubject.name, equalTo( "ClassReflectorTest" ) );
    }

    [Test]
    public function payload_is_client_class():void {
        assertThat( _testSubject.payload, strictlyEqualTo( ClassReflectorTest ) );
    }

    [Test]
    public function pkg_is_client_pkg_name():void {
        assertThat( _testSubject.pkg, equalTo( "org.osflash.statemachine.decoding" ) );
    }


    [Test]
    public function equals_against_self_returns_true():void {
        assertThat( _testSubject.equals( ClassReflectorTest ), isTrue() );
    }


    [Test]
    public function equals_against_name_returns_true():void {
        assertThat( _testSubject.equals( "ClassReflectorTest" ), isTrue() );
    }

    [Test]
    public function equals_against_full_package_name_returns_true():void {
        assertThat( _testSubject.equals( "org.osflash.statemachine.decoding.ClassReflectorTest" ), isTrue() );
    }

    [Test]
    public function equals_against_FQCP_returns_true():void {
        assertThat( _testSubject.equals( "org.osflash.statemachine.decoding::ClassReflectorTest" ), isTrue() );
    }
}
}
