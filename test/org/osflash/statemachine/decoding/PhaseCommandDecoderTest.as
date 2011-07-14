package org.osflash.statemachine.decoding {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;
import org.osflash.statemachine.decoding.supporting.SpyPhaseSignalCommandMapper;
import org.osflash.statemachine.supporting.IResultsRegistry;

public class PhaseCommandDecoderTest implements IResultsRegistry {

    private var _testSubject:PhaseCommandDecoder;
    private var _signal:ISignal;
    private var _commandMapper:IPhaseSignalMapper;
    private var _results:Array;


    [Before]
    public function before():void {
        _signal = new Signal(  );
        _commandMapper = new SpyPhaseSignalCommandMapper( this );
        _results = [];
    }

    public function initTestSubject( phaseDef:XMLList ):void {
        _testSubject = new PhaseCommandDecoder( phaseDef );
    }

    [After]
    public function after():void {
        _results = null;
        _testSubject = null;
        _signal = null;
        _commandMapper = null;
    }

    [Test]
    public function isNull__for_an_undefined_phase__returns_true():void {
        initTestSubject( STATE_DECLARATION.cancelled );
        assertThat( _testSubject.isNull, isTrue() );
    }

    [Test]
    public function isNull__for_a_defined_but_empty_phase__returns_true():void {
        initTestSubject( STATE_DECLARATION.enteringGuard );
        assertThat( _testSubject.isNull, isTrue() );
    }

    [Test]
    public function isNull__for_a_defined_phase__returns_false():void {
        initTestSubject( STATE_DECLARATION.entered );
        assertThat( _testSubject.isNull, isFalse() );
    }

    [Test]
    public function mapPhaseCommandsToSignal_calls_IPhaseSignalMapper_and_passes_correct_values_for_entered_phase():void {
        const expected:String = "mTPS:SampleCommandC:[object Signal],mTPS:SampleCommandD:[object Signal]";
        initTestSubject( STATE_DECLARATION.entered );
        _testSubject.mapPhaseCommandsToSignal( _signal, _commandMapper );
        assertThat( got, equalTo( expected ) );
    }

    [Test]
    public function mapPhaseCommandsToSignal_calls_IPhaseSignalMapper_and_passes_correct_values_for_tearDown_phase():void {
        const expected:String = "mTPS:SampleCommandA:[object Signal],mTPS:SampleCommandT:[object Signal],mTPS:SampleCommandZ:[object Signal]";
        initTestSubject( STATE_DECLARATION.tearDown );
        _testSubject.mapPhaseCommandsToSignal( _signal, _commandMapper );
        assertThat( got, equalTo( expected ) );
    }

    public function pushResults( results:Object ):void {
        _results.push( results );
    }

    private function get got():String {
        return _results.toString();
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
