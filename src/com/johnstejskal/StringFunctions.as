package com.johnstejskal 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author john
	 */
	public class StringFunctions 
	{
		
		public function StringFunctions() 
		{
			
		}
		
		
		//----------------------------------------------o
		//--- last Character of String
		//----------------------------------------------o
		
		public static function getLastCharInString($s:String):String
		{
		return $s.substr($s.length-1,$s.length);
		}
		
		public static function getFirstCharInString($s:String):String
		{
		return $s.substr(0, 1);
		}			
		
		//----------------------------------------------o
		//--- Generate Random String
		//----------------------------------------------o		
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
		
		//----------------------------------------------o
		//--- Make First Letter Uppercase
		//----------------------------------------------o		
		public static function upperCaseFirst(str:String) : String 
		{
		 var firstChar:String = str.substr(0, 1); 
		 var restOfString:String = str.substr(1, str.length); 
			trace("restOfString :" + restOfString);
		 return firstChar.toUpperCase() + restOfString;//.toLowerCase(); 
		}
		
		//----------------------------------------------o
		//--- String As Class
		//----------------------------------------------o		
		public static function stringAsClass(str:String) : Class 
		{		
			var ClassReference:Class = getDefinitionByName(str) as Class;
			return ClassReference;
			
		}	
		
		//----------------------------------------------o
		//--- Get Class of an object
		//----------------------------------------------o			
		public static function getClass(obj:Object):Class {
			  return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}		
	}

}