package com.johnstejskal 
{
	import com.thirdsense.utils.StringTools;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Validation 
	{
		
		public function Validation() 
		{
			
		}
		
		//======================================================o
		//--- Validate Date
		//======================================================o	
		public static function isValidDate(date:String):Boolean
		{
			var month:String        = "(0?[1-9]|1[012])";
			var day:String          = "(0?[1-9]|[12][0-9]|3[01])";
			var year:String         = "([1-9][0-9]{3})";
			var separator:String    = "([.\/ -]{1})";
			 
			var usDate:RegExp = new RegExp("^" + month + separator + day + "\\2" + year + "$");
			var ukDate:RegExp = new RegExp("^" + day + separator + month + "\\2" + year + "$");
			 
			return (usDate.test(date) || ukDate.test(date) ? true:false);       
		}
		
		//======================================================o
		//--- Validate Web Address
		//======================================================o	
		public static function isValidWebAddress(address:String):Boolean
		{
			var protocol:String     = "(https?:\/\/|ftp:\/\/)?";
			var domainName:String   = "([a-z0-9.-]{2,})";
			var domainExt:String    = "([a-z]{2,6})";
			var web:RegExp          = new RegExp('^' + protocol + '?' + domainName + "\." + domainExt + '$', "i");
			 
			return web.test(address);
		}
		
		//======================================================o
		//--- Validate Name
		//======================================================o
		public static function isValidName(value:String):Boolean
		{

			var nameEx:RegExp = /^([a-zA-Z])([ \u00c0-\u01ffa-zA-Z'.-]){1,20}+$/;
			return nameEx.test(value);
			
		}	
		
		//======================================================o
		//--- Validate email
		//======================================================o
		public static function isValidEmail( email:String ):Boolean
		{
			if ( email.indexOf("@") < 1 || email.length < 6 || email.indexOf(".") < 1 || email.lastIndexOf(".") == email.length-1 || email.indexOf("@.") >= 0 || email.indexOf(".@") >= 0 ) {
				return false;
			}
			
			var whitelist:String = "0123456789abcdefghijklmnopqrstuvwxyz!#$%&'*+-/=?^_`{|}~.@";
			for ( var i:int = 0; i < email.length; i++ )
			{
				if ( whitelist.indexOf(email.charAt(i).toLowerCase()) < 0 )
				{
					return false;
				}
			}
			
			return true;
		}
		
		//======================================================o
		//--- Validate Phone number
		//======================================================o
		public static function isValidPhoneNumber( phone:String, allowSpecialCharacters:Boolean = true ):Boolean
		{
			var code:Number;
			var char:String;
			
			for ( var i:int = 0; i < phone.length; i++ )
			{
				code = phone.charCodeAt(i);
				char = phone.charAt(i);
				
				if ( code < 48 || code > 57 )
				{
					if ( !allowSpecialCharacters )
					{
						return false;
					}
					else if ( char != "(" && char != ")" && char != "-" && char != "+" && char != " " )
					{
						return false;
					}
				}
			}
			
			return true;
		}		
		
		//======================================================o
		//--- Validate Password
		//======================================================o		
		public static function isValidatePassword( input:String ):Boolean
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
		
		//======================================================o
		//--- Validate Post Code
		//======================================================o
		public static function isValidPostCode(value:*):Boolean
		{
			var isValid:Boolean = true;
			
/*			if (value.length != 4)
			isValid = false;
		
		    if (!isva(value))
			isValid = false;*/
			
			
			return isValid;
		}
		

		
		
		
		
		
	}

}