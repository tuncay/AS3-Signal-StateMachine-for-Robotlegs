package org.osflash.statemachine.signals {

import org.flexunit.assumeThat;
import org.hamcrest.object.equalTo;
import org.osflash.signals.ISignal;

public class TearDownTest {

    private var _testSignal:ISignal;

    [Before]
    public function before():void {
        _testSignal = new TearDown()
    }

    [After]
    public function after():void {
        _testSignal = null;
    }

    [Test]
    public function value_classes_are_of_correct_number_and_type():void {
        assumeThat( _testSignal.valueClasses.length, equalTo( 0 ) );
    }
}
}
