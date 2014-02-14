package com.bumpslide.util {

	/**
	 * Date utilities
	 * 
	 * Some of these are modified from adobe core lib's date utils, but this class
	 * doesn't have any mx.* dependencies.  
	 * 
	 * @author David Knape
	 */
	public class DateUtil {

		public static var MONTH_NAMES:Array = [ 
		    "January", "February", "March", "April", "May", "June",
			"July", "August", "September", "October", "November", "December" ];
		
		public static var DAY_NAMES:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

		/**
		 * Parses W3CDTF Time stamps 
		 * 
		 * Modified from adobe as3corelib: 
		 * - david added option to ignore timezone
		 */ 
		public static function parseW3CDTF(str:String, ignoreTimezone:Boolean = false):Date {
			var finalDate:Date;
			try {
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T") + 1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1 || ignoreTimezone) {
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				} else if (timeStr.indexOf("+") != -1) {
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				} else { // offset is -
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				
				if(ignoreTimezone) {
					finalDate = new Date(year, month - 1, date, hour, minutes, seconds, milliseconds);
				} else {
					var utc:Number = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
					var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
					finalDate = new Date(utc - offset);
				}
				if (finalDate.toString() == "Invalid Date") {
					throw new Error("This date does not conform to W3CDTF.");
				}
			} catch (e:Error) {
				var eStr:String = "Unable to parse the string [" + str + "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				trace('[DateUtil] '+eStr);
				//throw new Error(eStr);
			}
			return finalDate;
		} 

		/**
		 * Basic date formatting function 
		 * 
		 * showDate( d ); // == "Saturday, September 15, 2008 9:00pm"
		 * showDate( d, false, false, false); // == "September 2009"
		 */
		static public function getFormatted( d:Date, showTime:Boolean=true, showWeekday:Boolean=true, showDate:Boolean=true ):String {
			// "Saturday, September 15, 2008 9:00pm"
			var s:String = "";			
			if(showWeekday) s+= DAY_NAMES[d.day] + ", ";
			s += MONTH_NAMES[d.month] + " ";
			if(showDate) s += d.date + ", ";
			s += d.fullYear;			
			if(showTime) s += " " + getShortHour(d) + ":" + (d.minutes < 10 ? "0" : "") + d.minutes + getAMPM(d).toLowerCase();
			return s;
		}

		/**
		 *	Returns a short hour (0 - 12) represented by the specified date.
		 */	
		public static function getShortHour(d:Date):int {
			var h:int = d.hours;			
			if(h == 0 || h == 12) {
				return 12;
			} else if(h > 12) {
				return h - 12;
			} else {
				return h;
			}
		}

		/**
		 *	Returns AM or PM for a given date/time;
		 */	
		public static function getAMPM(d:Date):String {
			return (d.hours > 11) ? "PM" : "AM";
		}     
	}
}
