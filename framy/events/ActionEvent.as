package framy.events {
	import flash.events.Event;
	
	/**
	* A collection for all the custom event names in Framy
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class ActionEvent extends Event{
		static public const TEXT_CHANGED:String = "ActionTextChangeComplete"
		static public const EFFECT_COMPLETE:String = "TextEffectComplete"
		static public const EFFECT_PROGRESS:String = "TextEffectProgress"
		static public const EFFECT_PROGRESS_ROUND:String = "TextEffectProgressRound"
		
		static public const ROUTE_TRIGGERED:String = "TriggerRouterEvent"
		
		static public const BUILD_COMPLETE:String = "ModuleBuildComplete"
		static public const PREPARE_COMPLETE:String = "ModulePrepareComplete"
		static public const TRANSLATE_COMPLETE:String = "ModuleTranslateComplete"
		static public const DESTROY_COMPLETE:String = "ModuleDestroyComplete"	
		static public const RESTORE_COMPLETE:String = "ModuleRestoreComplete"
		
		static public const BUILD_STARTED:String = "ModuleBuildStarted"
		static public const TRANSLATE_STARTED:String = "ModuleTranslateStarted"
		static public const PREPARE_STARTED:String = "ModulePrepareStarted"
		static public const DESTROY_STARTED:String = "ModuleDestroyStarted"	
		static public const RESTORE_STARTED:String = "ModuleRestoreStarted"	
		static public const QUICK_DESTROY_STARTED:String = "ModuleQuickDestroyStarted"
		
		static public const THUMB_ZOOM:String = "ThumbModuleZoomStarted"
		static public const THUMB_ZOOM_NOT_CURRENT:String = "ThumbModuleZoomNotCurrentStarted"
		static public const THUMB_SHRINK:String = "ThumbModuleShrinkStarted"
		static public const THUMB_BUILD_STARTED:String = "ThumbModuleBuildStarted"
		static public const THUMB_DESTROY_STARTED:String = "ThumbModuleDestroyStarted"
		
		static public const I18N_CHANGE:String = "I18nLanguageChangeStarted"
		static public const I18N_CHANGE_COMPLETE:String = "I18nLanguageChangeCompleted"
		
		static public var INIT_RESIZE:String = "Resizable_Init_Resize"
		static public var RESIZE_STARTED:String = "Resizable_Resize_Started"
		
		static public var ROUTE_MATCHED:String = "RouteMatched"
		static public var CALCULATE_POSITIONS:String = "PositionerCalculate"
		
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean = false) {
			super(type,bubbles,cancelable)
		}
	}
}