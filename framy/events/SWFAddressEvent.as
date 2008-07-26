/**
 * SWFAddress 2.0: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

package framy.events{

    import flash.events.Event;
	import framy.routing.SWFAddress
    /**
     * Event class for SWFAddress.
     */
    public class SWFAddressEvent extends Event {
        
        /**
         * Init event
         */
        public static const INIT:String = 'init';

        /**
         * Change event
         */
        public static const CHANGE:String = 'change';
        
        private var _value:String;
        private var _path:String;
        private var _parameters:Object;
        
        /**
         * Creates a new SWFAddress event
         * @param type Type of the event 
         * @constructor
         */
        public function SWFAddressEvent(type:String) {
            super(type, false, false);
            _value = SWFAddress.getValue();
            _path = SWFAddress.getPath();
            _parameters = new Object();
            var names:Array = SWFAddress.getParameterNames();
            for (var i:Number = 0, n:String; n = names[i]; i++) {
                _parameters[n] = SWFAddress.getParameter(n);
            }
        }

        /**
         * The target of this event
         */
        public override function get type():String {
            return super.type;
        }

        /**
         * The target of this event
         */
        public override function get target():Object {
            return SWFAddress;
        }

        /**
         * The value of this event
         */
        public function get value():String {
            return _value;
        }

        /**
         * The path of this event
         */
        public function get path():String {
            return _path;
        }

        /**
         * The parameters of this event
         */
        public function get parameters():Object {
            return _parameters;
        }

        /**
         * Clones this event
         */
        public override function clone():Event {
            return new SWFAddressEvent(type);
        }
    }
}
