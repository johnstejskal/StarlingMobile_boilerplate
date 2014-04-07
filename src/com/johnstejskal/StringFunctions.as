package com.johnstejskal 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author john Stejskal	
	 * www.johnstejskal.com
	 * "Why walk when you can ride"
	 */
	public class StringFunctions 
	{
		
		public function StringFunctions() 
		{
			
		}
		
		
		//==============================================o
		//--- last Character of String
		//==============================================o
		public static function getLastCharInString($s:String):String
		{
		return $s.substr($s.length-1,$s.length);
		}
		//==============================================o
		//--- First Character of String
		//==============================================o		
		public static function getFirstCharacter($s:String):String
		{
		return $s.substr(0, 1);
		}			
		
		//==============================================o
		//--- Generate Random String
		//==============================================o		
		public static function randomString(_length:Number):String
		{
			var alphabet:String = "qwertyuiopasdfghjklzxcvbnm123456789QWERTYUIOPASDFGHJKLZXCVBNM";
			var temp:Array = alphabet.split("");
			var tempString:String = "";
			
			for(var i:Number = 0; i<_length; i++){
				tempString+= temp[ Math.ceil( Math.random()*alphabet.length - 1 )]
			}
			
			return tempString;
		}
		
		//==============================================o
		//--- Make First Letter Uppercase
		//==============================================o		
		public static function upperCaseFirst(str:String) : String 
		{
		 var firstChar:String = str.substr(0, 1); 
		 var restOfString:String = str.substr(1, str.length); 
			trace("restOfString :" + restOfString);
		 return firstChar.toUpperCase() + restOfString;//.toLowerCase(); 
		}
		
		//==============================================o
		//--- String As Class
		//==============================================o		
		public static function stringAsClass(str:String) : Class 
		{		
			var ClassReference:Class = getDefinitionByName(str) as Class;
			return ClassReference;
			
		}	
		
		//==============================================o
		//--- Get Class of an object
		//==============================================o			
		public static function getClass(obj:Object):Class {
			  return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}	
		

		//==============================================o
		//-- check if is an email
		//==============================================o
		public static function isValidEmailFormat( email:String ):Boolean
		{
			if ( email.indexOf("@") < 1 || email.length < 6 || email.indexOf(".") < 1 || email.lastIndexOf(".") == email.length-1 || email.indexOf("@.") >= 0 || email.indexOf(".@") >= 0 ) {
				return false;
			}
			
			return true;
		}	
		
		//==============================================o
		//-- Generates Lorem Ipsum text
		//==============================================o
		public static function generateLoremIpsum( max_chars:int = 100 ):String
		{
			var str:String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam quis ipsum lacinia libero convallis semper. Ut vulputate sem id leo. In sollicitudin aliquet eros. Duis ornare sodales lorem. Duis ullamcorper. Donec ac magna. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
			
			if ( max_chars < 0 )
			{
				return str;
			}
			else
			{
				return str.substr( 0, max_chars - 1 );
			}
		}
		
		
		
	}

}