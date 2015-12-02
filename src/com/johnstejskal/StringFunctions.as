package com.johnstejskal 
{
	import com.thirdsense.utils.StringTools;
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
		
		
		//----------------------------------------------o
		//--- last Character of String
		//----------------------------------------------o
		public static function getLastCharInString($s:String):String
		{
		return $s.substr($s.length-1,$s.length);
		}
		//----------------------------------------------o
		//--- First Character of String
		//----------------------------------------------o		
		public static function getFirstCharInString($s:String):String
		{
		return $s.substr(0, 1);
		}		
		
		
		//----------------------------------------------o
		//--- Convert 24 hr time string to 12 hour: ie 0600 =  6:00am
		//----------------------------------------------o		
		public static function convertTo12Hr(time:String):String
		{	
			var amPm:String;
			var output:String;
			
			if(time.charAt(0) == "0")
			time = time.substr(1)
			
			if (int(time) >= 1200)
			{
			time = String(int(time) - 1200)
			amPm = "pm";
			}
			else
			{
			amPm = "am";
			}
			
			if (time.length == 3)
			output = time.slice(0, 1) + ":" + time.slice(1)+amPm;
			if (time.length == 4)
			output = time.slice(0, 2) + ":" + time.slice(2) + amPm;
			
			if (output == "0:00am")
			output = "12:00am"
			else if (output == "0:00pm")
			output = "12:00pm"
			
			return output;

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
		
		
		public static function fn(input:*):String // Format Number
		{
			var matchArray:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-"];
			var isNumber:Boolean = true;
			var returnString:String = "";
			
			var tString:String = String(input);
			
			for (var i:int = 0; i < tString.length; i++)
			{
				if (matchArray.indexOf(tString.charAt(i)) < 0) isNumber = false;
			}
			
			//trace("is it a number?", isNumber);
			
			if (isNumber)
			{
				var isMinus:Boolean = false;
				if (tString.indexOf("-") >= 0)
				{
					isMinus = true;
					tString = tString.slice(1);
				}
				
				var decimalString:String = "";
				var decimalid:int = tString.indexOf(".");
				
				if (decimalid >= 0)
				{
					decimalString = tString.slice(decimalid);
					tString = tString.slice(0, decimalid);
				}
				
				var nString:String = tString;
				
				switch(tString.length)
				{
					case 4:
						nString = tString.slice(0, 1) + "," + tString.slice(1);
						break;
					case 5:
						nString = tString.slice(0, 2) + "," + tString.slice(2);
						break;
					case 6:
						nString = tString.slice(0, 3) + "," + tString.slice(3);
						break;
					case 7:
						nString = tString.charAt(0) + "," + tString.slice(1, 4) + "," + tString.slice(4);
						break;
					case 8:
						nString = tString.slice(0,2) + "," + tString.slice(2, 5) + "," + tString.slice(5);
						break;
					case 9:
						nString = tString.slice(0,3) + "," + tString.slice(3, 6) + "," + tString.slice(6);
						break;
					case 10:
						nString = tString.slice(0, 1) + "," + tString.slice(1, 4) + "," + tString.slice(4, 7) + "," + tString.slice(7);
						break;
				}
				
				returnString = nString + decimalString;
			}
			
			if (returnString == "") returnString = tString;
			
			if (isMinus) returnString = "-" + returnString;
			
			return returnString;
		}
		
		//----------------------------------------------o
		//--- Make First Letter Uppercase
		//----------------------------------------------o		
		public static function upperCaseFirst(str:String) : String 
		{
		 var firstChar:String = str.substr(0, 1); 
		 var restOfString:String = str.substr(1, str.length); 
		 return firstChar.toUpperCase() + restOfString;
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
		


		
		public static function validatePassword( input:String ):Boolean
		{
/*			var conditionals:Array = [ (input.length >= 6), false, false ];
			
			for ( var i:uint = 0; i < input.length; i++ )
			{
				var c:String = input.charAt(i);
				if ( StringTools.checkIfAlphabetic(c) )
				{
					conditionals[1] = true;
				}
				else if ( StringTools.checkIfNumeric(c) )
				{
					conditionals[2] = true;
				}
				else
				{
					return false;
				}
			}
			
			for ( i = 0; i < conditionals.length; i++ )
			{
				if ( !conditionals[i] )
				{
					return false;
				}
			}*/
			
			return true;
			
		}
		
		//----------------------------------------------o
		//--- Validate Australian PostCode
		//----------------------------------------------o	
		public static function validateAusPostcode(value:String):Boolean
		{
			/*Australian postal code verification. Australia 
			 * has 4-digit numeric postal codes with the following 
			 * ACT: 0200-0299 and 2600-2639. 
			 * NSW: 1000-1999, 2000-2599 and 2640-2914. NT: 0900-0999 and 0800-0899.
			 * QLD: 9000-9999 and 4000-4999. SA: 5000-5999. TAS: 7800-7999 and 7000-7499. 
			 * VIC: 8000-8999 and 3000-3999. WA: 6800-6999 and 6000-6799*/
			//var postcode:RegExp = new RegExp("^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$");

			//return postcode.test(value);
/*			var answer:Boolean = true;
			
			if (value.length != 4)
			answer = false;
		
		    if (!StringTools.checkIfNumeric(value))
			answer = false;
			*/
			
			return "sss";
			
			
		}		
			
		//----------------------------------------------o
		//--- Validate Phone
		//----------------------------------------------o	
		public static function validatePhoneNumber(value:String):Boolean
		{
/*
			var answer:Boolean = true;
			
			if (value.length < 7 || value.length > 12)
			answer = false;
		
		    if (!StringTools.checkIfNumeric(value))
			answer = false;
			
			*/
			return true;
			
			
		}	
	
		//----------------------------------------------o
		//--- Validate URL
		//----------------------------------------------o	
		public static function validateWebAddress(address:String):Boolean
		{
			var protocol:String     = "(https?:\/\/|ftp:\/\/)?";
			var domainName:String   = "([a-z0-9.-]{2,})";
			var domainExt:String    = "([a-z]{2,6})";
			var web:RegExp          = new RegExp('^' + protocol + '?' + domainName + "\." + domainExt + '$', "i");
			 
			return web.test(address);
		}
		
		//----------------------------------------------o	
		//Replaces all the characters in the textfield with "•"
		//----------------------------------------------o	
		static public function makeSecure(label:String):String 
		{
			var password:RegExp = new RegExp("^[a-zA-Z0-9_]*$");
			label = label.replace(password, "•"); 
			
			trace("label :" + label);
			return label;
		}
	}

}