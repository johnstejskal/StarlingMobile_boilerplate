
/**
 * Copyright 2009 (c) , Brooks Andrus
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 */
package com.johnstejskal
{
    public class DateUtil
    {
        private static const DASH:String  = "-";
        private static const COLON:String = ":";
        private static const ZULU:String  = "Z";
        private static const T:String     = "T";
        private static const ZERO:String  = "0";
        

        /**
         * Converts an AS3 Date object into an ISO-8601 UTC extended date and time String (YYYY-MM-HHTHH:MM:SSZ).
         * The zulu designation (Z) at the end of the string indicates the time is UTC (Coordinated Universal Time).
         */
        public static function formatExtendedDateTime( date:Date ):String
        {
            return formatExtendedDate( date )
                   + T
                   + formatExtendedTime( date )
                   + ZULU;
        }
        
        /**
         * Converts an AS3 Date object into an ISO-8601 UTC basic date and time String. The Basic format has no hyphens or 
         * colons, but does have a UTC zulu designation at the end.
         */
        public static function formatBasicDateTime( date:Date ):String
        {
            return formatBasicDate( date )
                 + T
                 + formatBasicTime( date )
                 + ZULU;
        }
        
        /**
         * converts an ISO-8601 date + time (UTC) string of format "2009-02-21T09:00:00Z" to an AS3 Date Object.
         * The zulu designation (Z) at the end of the string indicates the time is UTC (Coordinated Universal Time).
         * Even if the zulu designation is missing UTC will be assumed.
         */
		
		 
        public static function parseDateTimeString(value:String ):Date
        {
			trace("parseDateTimeString");
			
			value = value.split("-").join("/");
			var t : Number = Date.parse(value);
			var date : Date = new Date(t);
			date.setHours(date.hours); 
			
            return date;
        }
        		 
        public static function parseSQLDateTimeString( val:String ):Date
        {
            //first strip all non-numerals from the String ( convert all extended dates to basic)
           
			val = val.replace(/-|:|T|Z|\s/g,"");
            
            var date:Date = parseBasicDate( val.substr( 0, 8 ) );
            date = parseBasicTime( val.substr( 8, 6 ), date );
            
            return date;
        }
		//=======================================o
		//-- get days between two dates
		//=======================================o
		public static function getDaysBetweenDates(date1:Date,date2:Date):int
		{
			var one_day:Number = 1000 * 60 * 60 * 24
			var date1_ms:Number = date1.getTime();
			var date2_ms:Number = date2.getTime();		    
			var difference_ms:Number = Math.abs(date1_ms - date2_ms)		    
			return Math.round(difference_ms/one_day)-1;
		}
		
		public static function checkIfDatesAreSame (date1 : Date, date2 : Date) : Boolean
		{
			var date1Timestamp : Number = date1.getDate ();
			var date2Timestamp : Number = date2.getDate ();

			trace("date1Timestamp:" + date1Timestamp);
			trace("date2Timestamp:" + date2Timestamp);
			
			var result : Boolean = false;

			if (date1Timestamp == date2Timestamp)
			{
				result = true;
			}
			else
			{
				result = false;
			}

			return result;
		}
		
        public static function parseBasicDate( val:String, date:Date = null ):Date
        {
            if ( date == null )
            {
                date = new Date();
            }
            
            date.setUTCFullYear( convertYear( val ), convertMonth( val ), convertDate( val ) );
            
            return date;
        }
        
        public static function parseBasicTime( val:String, date:Date = null ):Date
        {
            if ( date == null )
            {
                date = new Date();
            }
            
            date.setUTCHours( convertHours( val ), convertMinutes( val ), convertSeconds( val ) );
            
            return date;
        }
        
        public static function formatExtendedDate( date:Date ):String
        {
            return formatYear( date.getUTCFullYear() )
                   + DASH 
                   + formatMonth( date.getUTCMonth() )
                   + DASH
                   + formatDate( date.getUTCDate() )
        }
        
        public static function formatBasicDate( date:Date ):String
        {
            return formatYear( date.getUTCFullYear() )
                 + formatMonth( date.getUTCMonth() )
                 + formatDate( date.getUTCDate() );
        }
        
        public static function formatExtendedTime( date:Date ):String
        {
            return formatTimeChunk( date.getUTCHours() )
                 + COLON
                 + formatTimeChunk( date.getUTCMinutes() )
                 + COLON
                 + formatTimeChunk( date.getUTCSeconds() );
        }
        
        public static function formatBasicTime( date:Date ):String
        {
            return formatTimeChunk( date.getUTCHours() )
                 + formatTimeChunk( date.getUTCMinutes() )
                 + formatTimeChunk( date.getUTCSeconds() );
        }
        
        /**
         * assumes an 8601 basic date string (8 characters YYYYMMDD)
         */
        private static function convertYear( val:String ):int
        {
            val = val.substr( 0, 4 );
            return parseInt( val );
        }
        
        /**
         * assumes an 8601 basic date string (8 characters YYYYMMDD)
         */
        private static function convertMonth( val:String ):int
        {
            val = val.substr( 4, 2 );
            var y:int = parseInt( val ) - 1; // months are zero indexed in Date objects so we need to decrement
            return y;
        }
        
        /**
         * assumes an 8601 basic date string (8 characters YYYYMMDD)
         */
        private static function convertDate( val:String ):int
        {
            val = val.substr( 6, 2 );
            
            return parseInt( val );
        }
        
        /**
         * assumes a 8601 basic UTC time string (6 characters HHMMSS)
         */
        private static function convertHours( val:String ):int
        {
            val = val.substr( 0, 2 );
            
            return parseInt( val );
        }
        
        /**
         * assumes a 8601 basic UTC time string (6 characters HHMMSS)
         */
        private static function convertMinutes( val:String ):int
        {
            val = val.substr( 2, 2 );
            
            return parseInt( val );
        }
        
        /**
         * assumes a 8601 basic UTC time string (6 characters HHMMSS)
         */
        private static function convertSeconds( val:String ):int
        {
            val = val.substr( 4, 2 );
            
            return parseInt( val );
        }
        
        // doesn't handle BC dates
        private static function formatYear( year:int ):String
        {
            var y:String = year.toString();
            // 0009 0010 0099 0100
            if ( year < 10 )
            {
                y = ZERO + ZERO + ZERO + y;
            }
            else if ( year < 100 )
            {
                y = ZERO + ZERO + y;
            }
            else if ( year < 1000 )
            {
                y = ZERO + y;
            }
            
            return y;
        }
        
        private static function formatMonth( month:int ):String
        {
            // Date object months are zero indexed so always increment the month up by one
            month++;
            
            // convert the month to a String
            var m:String = month.toString();
            
            if ( month < 10 )
            {
                m = ZERO + m; 
            }
            
            return m;
        }
        
        private static function formatDate( date:int ):String
        {
            var d:String = date.toString()
            if ( date < 10 )
            {
                d = ZERO + d;
            }
            
            return d;
        }
        
        private static function formatTimeChunk( val:int ):String
        {
            var t:String = val.toString();
            
            if ( val < 10 )
            {
                t = ZERO + t;
            }
            
            return t;
        }
    }
}