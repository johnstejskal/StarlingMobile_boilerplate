package view.components.ui.buttons 
{
	import com.johnstejskal.Position;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;



	//=======================================o
	/**
	 * @author John Stejskal
	 */
	//=======================================o
	public class ButtonType1 extends SuperButton
	{

		private const SKIN:Class = TA_buttonType1;
		private var _pivotPos:String = Position.CENTER;


		//=======================================o
		//-- Constructor
		//=======================================o
		public function ButtonType1(label:String, callback:Function, ref:String = "", param:String = null) 
		{
			super(SKIN, label, callback, ref, param, _pivotPos);
		}
		
		//=======================================o
		//-- Setters
		//=======================================o		
		public function set pivotPos(value:String):void 
		{
			_pivotPos = value;
		}

		
	}

}