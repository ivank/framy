package framy.graphics {
	import caurina.transitions.Tweener;
	import framy.tools.Options;
	
	public class CustomEasings {
		
		public static function init():void {
			Tweener.registerTransition("steep", steep)
			Tweener.registerTransition("smooth", smooth)
			Tweener.registerTransition("smooth2", smooth2)
			Tweener.registerTransition("light_steep", light_steep)
		}
		
		public static function steep (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return calculate(t,b,c,d, [{Mx:0,My:0,Nx:0,Ny:-326,Px:37,Py:139},{Mx:37,My:-187,Nx:38,Ny:-16,Px:125,Py:3},{Mx:200, My:-200}], p_params)
		}
		
		public static function light_steep (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return calculate(t,b,c,d, [{Mx:0,My:0,Nx:28,Ny:-284,Px:21,Py:111},{Mx:49,My:-173,Nx:68,Ny:-48,Px:34,Py:23},{Mx:151,My:-198,Nx:60,Ny:-2,Px:-11,Py:0},{Mx:200, My:-200}], p_params)
		}
		
		public static function smooth (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return calculate(t,b,c,d, [{Mx:0,My:0,Nx:62,Ny:-32,Px:-23,Py:-61},{Mx:39,My:-93,Nx:18,Ny:-226,Px:143,Py:119},{Mx:200, My:-200}], p_params)
		}
		
		public static function smooth2 (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return calculate(t,b,c,d, [{Mx:0, My:0, Nx:10, Ny: -182, Px:11, Py:44 }, { Mx:21, My: -138, Nx:40, Ny: -96, Px:47, Py:43 }, { Mx:108, My: -191, Nx:154, Ny: -8, Px: -62, Py: -1 }, { Mx:200, My: -200 } ], p_params)
		}		
		
		private static function calculate(t:Number, b:Number, c:Number, d:Number, points:Array, p_params:Object = null):Number {
			var pl:Array = !Boolean(p_params) ? points : p_params.curve;
			var r:Number = 200 * t/d;
			var i:Number = -1;
			var e:Object;
			while (pl[++i].Mx<=r) e = pl[i];
			var Px:Number = e.Px;
			var Nx:Number = e.Nx;
			var s:Number = (Px==0) ? -(e.Mx-r)/Nx : (-Nx+Math.sqrt(Nx*Nx-4*Px*(e.Mx-r)))/(2*Px);
			return (b-c*((e.My+e.Ny*s+e.Py*s*s)/200));
			
		}		
	}
	
}
