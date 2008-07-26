/**
 * SWFAddress 2.0: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

package framy.routing {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
	import framy.events.SWFAddressEvent;

    /**
     * SWFAddress is distributed as a top level class. Projects that utilize 
     * code packages should use it with the com.asual.swfaddress package.
     */ 
    public class SWFAddress {
    
        private static var _init:Boolean = false;
        private static var _strict:Boolean = true;
        private static var _value:String = '';
        private static var _interval:Number;
        private static var _availability:Boolean = ExternalInterface.available;
        private static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static var wait:Number = 0.1

        /**
         * Init event.
         */
        public static var onInit:Function;
        
        /**
         * Change event.
         */
        public static var onChange:Function;

        private static function _initialize():Boolean {
            if (_availability) {
                ExternalInterface.addCallback('getSWFAddressValue', 
                    function():String {return _value});
                ExternalInterface.addCallback('setSWFAddressValue', 
                    _setValue);
            }
            _interval = setInterval(_check, wait*1000);
            return true;
        }
        private static var _initializer:Boolean = _initialize();
        
        private static function _check():void {
            if ((typeof SWFAddress['onInit'] == 'function' || _dispatcher.hasEventListener('init')) && !_init) {
                _dispatchEvent(SWFAddressEvent.INIT);
				
            }
            if (typeof SWFAddress['onChange'] == 'function' || _dispatcher.hasEventListener('change')) {
                clearInterval(_interval);
                SWFAddress._setValue(_getValue());
            }
        }
        
        private static function _strictCheck(value:String, force:Boolean):String {
            if (_strict) {
                if (force) {
                    if (value.substr(0, 1) != '/') value = '/' + value;
                    var qi:Number = value.indexOf('?');
                    if (qi != -1) {
                        value = value.substr(qi - 1, 1) != '/' ? value.substr(0, qi) + '/' + value.substr(qi) : value;
                    } else {
                        if (value.substr(value.length - 1) != '/') value += '/';
                    }
                } else {
                    if (value == '') value = '/';
                }
            }
            return value;
        }

        private static function _getValue():String {
            var value:String, id:String = null;
            if (_availability) { 
                value = ExternalInterface.call('SWFAddress.getValue') as String;
                id = ExternalInterface.call('SWFAddress.getId') as String;
            }
            if (id == null || !_availability) {
                value = SWFAddress._value;
            } else {
                if (value == 'undefined' || value == null) value = '';
            }
            return _strictCheck(value, false);
        }

        private static function _setValue(value:String):void {        
            if (value == 'undefined' || value == null) value = '';
            if (SWFAddress._value == value && SWFAddress._init) return;
            SWFAddress._value = value;
            SWFAddress._init = true;
            _dispatchEvent(SWFAddressEvent.CHANGE);
        }        
        
        private static function _dispatchEvent(type:String):void {
            if (_dispatcher.hasEventListener(type)) {
                _dispatcher.dispatchEvent(new SWFAddressEvent(type));
            }
            type = type.substr(0, 1).toUpperCase() + type.substring(1);
            if (typeof SWFAddress['on' + type] == 'function') {
                SWFAddress['on' + type]();
            }
        }

        /**
         * Loads the previous URL in the history list.
         */
        public static function back():void {
            if (_availability)
                ExternalInterface.call('SWFAddress.back');
        }

        /**
         * Loads the next URL in the history list.
         */
        public static function forward():void {
            if (_availability)
                ExternalInterface.call('SWFAddress.forward');
        }

        /**
         * Loads a URL from the history list.
         * @param delta An integer representing a relative position in the history list.
         */
        public static function go(delta:Number):void {
            if (_availability)
                ExternalInterface.call('SWFAddress.go', delta);
        }

        /**
         * Opens a new URL in the browser. 
         * @param url The resource to be opened.
         * @param target Target window.
         */
        public static function href(url:String, target:String):void {
            if (_availability) {
                ExternalInterface.call('SWFAddress.href', url, target);
            }
        }

        /**
         * Opens a browser popup window. 
         * @param url Resource location.
         * @param name Name of the popup window.
         * @param options Options which get evaluted and passed to the window.open() method.
         * @param handler Optional JavsScript handler code for popup handling.    
         */
        public static function popup(url:String, name:String, options:String, handler:String):void {
            if (_availability) {
                ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
            }
        }

        /**
         * Registers an event listener..
         * @param type Event type.
         * @param listener Event listener.
         */
        public static function addEventListener(type:String, listener:Function):void {
            _dispatcher.addEventListener(type, listener, false, 0, false);
        }

        /**
         * Removes an event listener.
         * @param type Event type.
         * @param listener Event listener.
         */
        public static function removeEventListener(type:String, listener:Function):void {
            _dispatcher.removeEventListener(type, listener, false);
        }

        /**
         * Dispatches an event to all the registered listeners. 
         * @param event Event object.
         */
        public static function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
        }

        /**
         * Checks the existance of any listeners registered for a specific type of event. 
         * @param event Event type.
         */
        public static function hasEventListener(type:String):Boolean {
            return _dispatcher.hasEventListener(type);
        }

        /**
         * Provides the state of the strict mode setting. 
         */
        public static function getStrict():Boolean {
            return (_availability) ? 
                ExternalInterface.call('SWFAddress.getStrict') : _strict;
        }

        /**
         * Enables or disables the strict mode.
         * @param {Boolean} strict Strict mode state.
         */
        public static function setStrict(strict:Boolean):void {
            if (_availability)
                ExternalInterface.call('SWFAddress.setStrict', strict);
            _strict = strict;
        }

        /**
         * Provides the state of the history setting. 
         */
        public static function getHistory():Boolean {
            return (_availability) ? 
                ExternalInterface.call('SWFAddress.getHistory') : false;
        }

        /**
         * Enables or disables the creation of history entries.
         * @param {Boolean} history History state.
         */
        public static function setHistory(history:Boolean):void {
            if (_availability)
                ExternalInterface.call('SWFAddress.setHistory', history);
        }

        /**
         * Provides the tracker function.
         */
        public static function getTracker():String {
            return (_availability) ? 
                ExternalInterface.call('SWFAddress.getTracker') as String : '';
        }

        /**
         * Sets a function for page view tracking. The default value is 'urchinTracker'.
         * @param tracker Tracker function.
         */
        public static function setTracker(tracker:String):void {
            if (_availability)
                ExternalInterface.call('SWFAddress.setTracker', tracker);
        }

        /**
         * Provides the title of the HTML document.
         */
        public static function getTitle():String {
            var title:String = (_availability) ? 
                ExternalInterface.call('SWFAddress.getTitle') as String : '';
            if (title == 'undefined' || title == null) title = '';
            return title;
        }

        /**
         * Sets the title of the HTML document.
         * @param title Title value.
         */
        public static function setTitle(title:String):void {
            if (_availability) ExternalInterface.call('SWFAddress.setTitle', title);
        }

        /**
         * Provides the status of the browser window.
         */
        public static function getStatus():String {
            var status:String = (_availability) ? 
                ExternalInterface.call('SWFAddress.getStatus') as String : '';
            if (status == 'undefined' || status == null) status = '';
            return status;
        }

        /**
         * Sets the status of the browser window.
         * @param status Status value.
         */
        public static function setStatus(status:String):void {
            if (_availability) ExternalInterface.call('SWFAddress.setStatus', status);
        }

        /**
         * Resets the status of the browser window.
         */
        public static function resetStatus():void {
            if (_availability) ExternalInterface.call('SWFAddress.resetStatus');
        }

        /**
         * Provides the current deep linking value.
         */
        public static function getValue():String {
            if (_init)
                return _strictCheck(_value, false);
            else
                return _strictCheck(_availability ? ExternalInterface.call('SWFAddress.getValue') as String : '', false);
        }

        /**
         * Sets the current deep linking value.
         * @param value A value which will be appended to the base link of the HTML document.
         */
        public static function setValue(value:String):void {
			
            if (value == 'undefined' || value == null) value = '';
            value = _strictCheck(value, true);
            if (SWFAddress._value == value) return;
            SWFAddress._value = value;
			
            if (_availability && SWFAddress._init) ExternalInterface.call('SWFAddress.setValue', value);
            _dispatchEvent(SWFAddressEvent.CHANGE);
        }

        /**
         * Provides the deep linking value without the query string.
         */
        public static function getPath():String {
            var value:String = SWFAddress.getValue();
            if (value.indexOf('?') != -1) {
                return value.split('?')[0];
            } else {
                return value;
            }
        }

        /**
         * Provides the query string part of the deep linking value.
         */
        public static function getQueryString():String {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            if (index != -1 && index < value.length) {
                return value.substr(index + 1);
            }
            return '';
        }

        /**
         * Provides the value of a specific query parameter.
         * @param param Parameter name.
         */
        public static function getParameter(param:String):String {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            if (index != -1) {
                value = value.substr(index + 1);
                var params:Array = value.split('&');
                var p:Array;
                var i:Number = params.length;
                while(i--) {
                    p = params[i].split('=');
                    if (p[0] == param) {
                        return p[1];
                    }
                }
            }
            return '';
        }

        /**
         * Provides a list of all the query parameter names.
         */
        public static function getParameterNames():Array {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            var names:Array = new Array();
            if (index != -1) {
                value = value.substr(index + 1);
                if (value != '' && value.indexOf('=') != -1) {
                    var params:Array = value.split('&');
                    var i:Number = 0;
                    while(i < params.length) {
                        names.push(params[i].split('=')[0]);
                        i++;
                    }
                }
            }
            return names;
        }
    }
}