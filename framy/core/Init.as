package framy.core {
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import framy.loading.I18n;
	import framy.tools.CustomCursor;
	import framy.tools.Grawl;
	import framy.tools.Tooltips;
	import com.pixelbreaker.ui.osx.MacMouseWheel;

	/**
	 * Basic initialization - passes the stage object to the static classes dependent on it,
	 * sets the stage alignemnt and scale ( StageScaleMode.NO_SCALE, StageAlign.TOP_LEFT)
	 * 
	 * @author Ivan K
	 */
	public class Init {
		public static function init(stage:Stage):void {
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			I18n.stage = stage
			Grawl.stage = stage
			Tooltips._stage = stage
			MacMouseWheel.setup(stage)
			CustomCursor.init(stage)
		}
		
	}
	
}
