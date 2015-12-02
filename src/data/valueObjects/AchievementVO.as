package data.valueObjects 
{

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class AchievementVO 
	{
		
		public var id:int;
		public var name:String; 
		public var description:String; 
		public var action:String; 
		public var type:String;
		public var quantity:int;
		public var award:int;
		
		
		
		public var completed:Boolean = false;
		

		
		
		public function AchievementVO() 
		{
			
		}
		
		
		
		
	}

}