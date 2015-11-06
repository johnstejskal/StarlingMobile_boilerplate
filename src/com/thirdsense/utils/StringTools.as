package com.thirdsense.utils 
{
	import com.thirdsense.utils.getClassVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * A variety of tools to help with formatting of String data
	 * @author Ben Leffler
	 */
	
	public class StringTools 
	{
		/**
		 * Checks if a string is a valid email format
		 * @param	email	The email address to check
		 * @return	Boolean value that indicates if it is a valid email format
		 */
		
		public static function isValidEmailFormat( email:String ):Boolean
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
		
		public static function isValidPhoneFormat( phone:String, allowSpecialCharacters:Boolean = true ):Boolean
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
		
		/**
		 * Adds a string in to another string at a designated position
		 * @param	target_string	The target string to append to
		 * @param	pos	The position of where to place the insert_string value. (0 to n-1)
		 * @param	insert_string	The string to append to target_string
		 * @return	The resulting string
		 */
		
		public static function insertAt( target_string:String, pos:int, insert_string:String ):String
		{
			var str:String;
			var str1:String = target_string.substr(0, pos);
			var str3:String = target_string.substr(pos);
			str = str1 + insert_string + str3;
			
			return str;
		}
		
		/**
		 * Replaces instances of certain characters in a string with a desired character set
		 * @param	target_string	The target string to analyse and replace
		 * @param	searchFor	The character combination to search for
		 * @param	replaceWith	The character combination that will be replaced with
		 * @return	The resulting string
		 */
		
		public static function replaceAll( target_string:String, searchFor:String, replaceWith:String ):String
		{
			if ( searchFor == replaceWith ) {
				trace( "Illegal replace call - searchFor and replaceWith params can not be the same" );
				return "";
			}
			
			var index:int = 0;
			
			while ( target_string.indexOf(searchFor, index) >= 0 ) {
				
				var pos:int = target_string.indexOf(searchFor, index);
				
				var s1:String = target_string.substr( 0, pos );
				var s3:String = target_string.substr( pos + searchFor.length );
				target_string = s1 + replaceWith + s3;
				
				index = pos + 1;
			}
			
			return target_string;
			
		}
		
		/**
		 * Shortens a number with a suffix representation (K for thousands, M for millions and B for billions)
		 * @param	value	The value to shorten
		 * @param	digits	The minimum number of digits to allow before creating a suffix
		 * @param	decimals	The number of decimals to allow
		 * @param	long	If passed as true, 'B', 'M' and 'K' will be replaced with "Billion", "Million" and "Thousand"
		 * @return	The string representation of the number
		 */
		
		public static function shortenNumber( value:Number, digits:int=5, decimals:int = 2, long:Boolean=false ):String
		{
			var str:String = "1";
			for ( var i:uint = 1; i < digits; i++ ) {
				str += "0";
			}
			var max:Number = Number(str);
			var dec:int = Math.pow(10, decimals);
			
			if ( value < max ) {
				return String(value);
			}
			
			if ( value >= 1000000000000 ) {
				value /= 1000000000000;
				value = Math.round( value * dec );
				value /= dec;
				if ( long ) return Trig.formatNumber(value) + " Trillion";
				return Trig.formatNumber(value) + "T";
			}
			
			if ( value >= 1000000000 ) {
				value /= 1000000000;
				value = Math.round( value * dec );
				value /= dec;
				if ( long ) return value + " Billion";
				return value + "B";
			}
			
			if ( value >= 1000000 ) {
				value /= 1000000;
				value = Math.round( value * dec );
				value /= dec;
				if ( long ) return value + " Million";
				return value + "M";
			}
			
			if ( value >= 1000 ) {
				value /= 1000;
				value = Math.round( value );
				if ( long ) return value + ",000";
				return value + "K";
			}
			
			return String(value);
		}
		
		/**
		 * Converts an integer value in to a place (ie 1 converts to 1st, 2 converts to 2nd etc.)
		 * @param	value	The value to convert from
		 * @return	The string result
		 */
		
		public static function convertToPlace( value:int ):String
		{
			if ( value < 1 ) {
				return String(value);
			}
			
			if ( value > 3 && value < 21 ) {
				return value + "th";
			}
			
			var str:String = String(value);
			
			if ( str.length > 1 && str.charAt(str.length - 2) != "1" ) {
				
				if ( str.charAt(str.length - 1) == "1" ) {
					return value + "st";
				}
				
				if ( str.charAt(str.length - 1) == "2" ) {
					return value + "nd";
				}
				
				if ( str.charAt(str.length - 1) == "3" ) {
					return value + "rd";
				}
				
			} else {
			
				if ( str.charAt(str.length - 1) == "1" ) {
					return value + "st";
				}
				
				if ( str.charAt(str.length - 1) == "2" ) {
					return value + "nd";
				}
				
				if ( str.charAt(str.length - 1) == "3" ) {
					return value + "rd";
				}
				
			}
			
			return value + "th";
		}
		
		/**
		 * Creates a string representation of a class or an instance of a class object.
		 * @param	cl	The class or object to analyse
		 * @param	accessorType	The type of accessor to include in the result
		 * @return	A string representation of the object 'cl'
		 * @see	com.thirdsense.utils.AccessorType
		 */
		
		public static function toString( cl:*, accessorType:String="" ):String
		{
			var arr:Array = getClassVariables(cl, accessorType);
			var str:String = "{";
			
			for ( var i:uint = 0; i < arr.length; i++ ) {
				if ( i ) {
					str += ", ";
				}
				str += arr[i] + ":" + cl[arr[i]];
			}
			
			str += "}";
			
			return str;
			
		}
		
		/**
		 * Generates a Lorem Ipsum placeholder string for use with temporary textfield content
		 * @param	max_chars	The maximum number of characters the string is to return
		 * @return	A String representing the Lorem Ipsum text
		 */
		
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
		
		/**
		 * Generates a Bogan Ipsum placeholder string for use with temporary textfield content
		 * @param	max_chars	Maximum number of characters the string is to return
		 * @return	A string representing the Bogan Ipsum text
		 */
		public static function generateBoganIpsum( max_chars:int = 100 ):String
		{
			var str:String = "As cross as a dag no dramas as cross as a mickey mouse mate. Shazza got us some cab sav piece of piss as dry as a brickie. Trent from punchy ambo where she'll be right plonk. Shazza got us some fair go to as dry as a cockie. Come a gobsmacked where shazza got us some offsider. Stands out like a galah mate we're going hoon. Shazza got us some cat burying shit also lets get some cobber. Get a dog up ya spewin' cooee. As cunning as a bradman piece of piss lets get some ocker. It'll be bail up my as cross as a daks. grundies bloody flat out like a dead horse. Mad as a freckle no dramas you little ripper budgie smugglers. You little ripper stickybeak when she'll be right slacker. Flat out like a pig's arse when flat out like a chokkie. flanno piece of piss as cunning as a two pot screamer. She'll be right ropeable no worries mad as a bushie. Gutful of flick bloody he hasn't got a chuck a yewy. He's got a massive chokkie where he's got a massive feral. Shazza got us some bogan no dramas it'll be crook. Grab us a swagger heaps mad as a ten clicks away. As cunning as a deadset where shazza got us some chuck a sickie. Mad as a good oil mate come a strides. As busy as a clacker when lets throw a decent nik. Gutful of wuss heaps built like a durry. Shazza got us some decent nik how lets throw a chewie. As cross as a sleepout my we're going yabber. Lets get some pozzy also she'll be right spit the dummy. As cunning as a maccas with he's got a massive porky. As stands out like ford my he's got a massive blue. We're going op shop how mozzie. Come a chewie heaps come a bushie. As busy as a chewie to as cunning as a down under. Stands out like a scratchy where stands out like a compo.";
			
			if ( max_chars < 0 )
			{
				return str;
			}
			else
			{
				return str.substr( 0, max_chars - 1 );
			}
		}
		
		/**
		 * Obtains a gregorian calender name for the desired month (0 = January)
		 * @param	month	The integer representation of the month
		 * @param	shorten	Should the result be the shortened format of the month name?
		 * @return	The name of the month
		 */
		
		public static function getMonthName( month:int, shorten:Boolean = false ):String
		{
			var arr:Array = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemeber" ];
			var arr2:Array = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
			
			if ( shorten ) return arr2[month];
			else return arr[month];
		}
		
		/**
		 * Retrieves a string representation of a given day
		 * @param	day	The day as an integer (from the Date.getDay call)
		 * @param	shorten	Shorten the result to an abbreviated form
		 * @return	The name of the day
		 */
		
		public static function getDayName( day:int, shorten:Boolean = false ):String
		{
			if ( shorten )
			{
				var arr:Array = [ "Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat" ];
			}
			else
			{
				arr = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
			}
			
			return arr[day];
		}
		
		/**
		 * Returns a random one or two word praise/adulation for use with UI titles
		 * @return	String
		 */
		
		public static function getRandomPraise():String
		{
			var arr:Array = [
				"Congratulations",
				"Well Done",
				"Terrific Job",
				"Nice Work",
				"Awesome Effort",
				"Great Work",
				"Great Job",
				"Well Played",
				"Fine Work",
				"Fine Job",
				"Fine Effort",
				"Nice Job",
				"Good Going",
				"Good Show",
				"Amazing",
				"Inspirational"
			];
			
			return arr[ Math.floor(Math.random() * arr.length) ];
		}
		
		/**
		 * Returns a random one or two word praise/adulation for use with UI titles
		 * @return	String
		 */
		
		public static function getRandomEncouragement():String
		{
			var arr:Array = [
				"Bad Luck",
				"Hard Luck",
				"Good Effort",
				"Unlucky",
				"Not Bad",
				"Pretty Good",
				"Almost There",
				"Better Luck Next Time",
				"Worth Another Try",
				"You're Getting There",
				"Coming Along Nicely"
			];
			
			return arr[ Math.floor(Math.random() * arr.length) ];
		}
		
		public static function convertToTimeCounter( ms:Number ):String
		{
			var secs:int = Math.floor( ms / 1000 );
			ms -= secs * 1000;
			
			var mins:int = Math.floor( secs / 60 );
			secs -= mins * 60;
			
			var time_str:String = mins + ":";
			if ( secs < 10 ) time_str += "0";
			time_str += secs;
			
			if ( ms > 0 )
			{
				time_str += ".";
				if ( ms < 100 ) time_str += "0";
				if ( ms < 10 ) time_str += "0";
				time_str += ms;
			}
			
			return time_str;
		}
		
		public static function capitalizeByWord( str:String ):String
		{
			if ( !str ) return str;
			
			str = str.toLowerCase();
			var arr:Array = str.split("");
			str = "";
			
			for ( var i:int = 0; i < arr.length; i++ )
			{
				if ( !i || arr[i - 1].charCodeAt(0) < String("a").charCodeAt(0) || arr[i - 1].charCodeAt(0) > String("z").charCodeAt(0) )
				{
					str += arr[i].toUpperCase();
				}
				else
				{
					str += arr[i];
				}
			}
			return str;
		}
		
		public static function getTimeRemaining( ms:Number ):String
		{
			var elapsed:Number = ms;
			
			elapsed /= 1000;
			if ( elapsed < 60 )
			{
				var val:int = Math.floor( elapsed );
				if ( val > 1 )
				{
					return val + " secs";
				}
				else if ( val == 1 )
				{
					return val + " sec";
				}
				else
				{
					return "Now";
				}
			}
			
			elapsed /= 60;
			if ( elapsed < 60 )
			{
				val = Math.floor( elapsed );
				if ( val > 1 )
				{
					return val + " mins";
				}
				else
				{
					return val + " min";
				}
			}
			
			elapsed /= 60;
			if ( elapsed < 24 )
			{
				val = Math.floor( elapsed );
				if ( val > 1 )
				{
					return val + " hours";
				}
				else
				{
					return val + " hour";
				}
			}
			
			elapsed /= 24;
			if ( elapsed < 7 )
			{
				val = Math.floor( elapsed );
				if ( val > 1 )
				{
					return val + " days";
				}
				else
				{
					return val + " day";
				}
			}
			
			elapsed /= 7;
			val = Math.floor( elapsed );
			if ( val > 1 )
			{
				return val + " weeks";
			}
			else
			{
				return val + " week";
			}
		}
		
		public static function shortenTextField( tf:TextField, max_width:Number ):void
		{
			if ( tf.multiline )
			{
				trace( "LaunchPad - StringTools.shortenTextField :: Error - This call will not work with a multiline textfield" );
				return void;
			}
			else if ( tf.autoSize == TextFieldAutoSize.NONE )
			{
				trace( "LaunchPad - StringTools.shortenTextField :: Error - You must set the TextFieldAutoSize property of the textfield to a value other than NONE" );
				return void;
			}
			
			var str:String = tf.text;
			
			while ( tf.width > max_width )
			{
				tf.text = str + "...";
				str = str.substr(0, str.length - 1);
			}
		}
	}

}