/*
The MIT License
 
Copyright (c) 2011 Jackson Dunstan
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package com.johnstejskal
{
	/**
	*   A lookup table for trig values (e.g. sine, cosine) to improve on the
	*   performance of the static functions found in the Math class
	*   @author Jackson Dunstan
	*/
	public class TrigLUT
	{
		/** 2 * PI, the number of radians in a circle*/
		public static const TWO_PI:Number = 2.0 * Math.PI;
 
		/** The static TWO_PI cached as a non-static field*/
		private const TWO_PI:Number = TrigLUT.TWO_PI;
 
		/** Table of trig function values*/
		public var table:Vector.<Number>;
 
		/** 10^decimals of precision*/
		public var pow:Number;
 
		/**
		*   Make the look up table
		*   @param numDigits Number of digits places of precision
		*   @param mathFunc Math function to call to generate stored values.
		*                   Must be valid on [0,2pi).
		*   @throws Error If mathFunc is null or invalid on [0,2pi)
		*/
		public function TrigLUT(numDigits:uint, mathFunc:Function)
		{
			var pow:Number = this.pow = Math.pow(10, numDigits);
			var round:Number = 1.0 / pow;
			var len:uint = 1 + this.TWO_PI*pow;
			var table:Vector.<Number> = this.table = new Vector.<Number>(len);
 
			var theta:Number = 0;
			for (var i:uint = 0; i < len; ++i)
			{
				table[i] = mathFunc(theta);
				theta += round;
			}
		}
 
		/**
		*   Look up the value of the given number of radians
		*   @param radians Radians to look up the value of
		*   @return The value of the given number of radians
		*/
		public function val(radians:Number): Number
		{
			return radians >= 0
				? this.table[int((radians%this.TWO_PI)*this.pow)]
				: this.table[int((TWO_PI+radians%this.TWO_PI)*this.pow)];
		}
 
		/**
		*   Look up the value of the given number of radians
		*   @param radians Radians to look up the value of. Must be positive.
		*   @return The sine of the given number of radians
		*   @throws RangeError If radians is not positive
		*/
		public function valPositive(radians:Number): Number
		{
			return this.table[int((radians%this.TWO_PI)*this.pow)];
		}
 
		/**
		*   Look up the value of the given number of radians
		*   @param radians Radians to look up the value of. Must be on (-2pi,2pi).
		*   @return The value of the given number of radians
		*   @throws RangeError If radians is not on (-2pi,2pi)
		*/
		public function valNormalized(radians:Number): Number
		{
			return radians >= 0
				? this.table[int(radians*this.pow)]
				: this.table[int((this.TWO_PI+radians)*this.pow)];
		}
 
		/**
		*   Look up the value of the given number of radians
		*   @param radians Radians to look up the value of. Must be on [0,2pi).
		*   @return The value of the given number of radians
		*   @throws RangeError If radians is not on [0,2pi)
		*/
		public function valNormalizedPositive(radians:Number): Number
		{
			return this.table[int(radians*this.pow)];
		}
	}
}