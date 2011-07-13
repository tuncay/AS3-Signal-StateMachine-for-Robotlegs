package org.osflash.statemachine.signals {

import org.flexunit.assumeThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.strictlyEqualTo;
import org.osflash.signals.ISignal;
import org.osflash.statemachine.core.IPayload;

public class CancelledTest {

    private var _testSignal:ISignal;

    [Before]
    public function before():void {

        _testSignal = new Cancelled()
    }

    [After]
    public function after():void {
        _testSignal = null;
    }

    [Test]
    public function value_classes_are_of_correct_number_and_type():void {
        assumeThat(_testSignal.valueClasses , array( strictlyEqualTo( String ), strictlyEqualTo( IPayload )) );
    }
}
}
