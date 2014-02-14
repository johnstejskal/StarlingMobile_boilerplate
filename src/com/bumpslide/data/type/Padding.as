/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */ 
package com.bumpslide.data.type {
	
	/**
	 * Structure that represents the padding around a rectangular component
	 * 
	 * @author David Knape
	 */
	public class Padding {
		
		public var top:Number = 2;
		public var bottom:Number = 2;
		public var left:Number = 2;
		public var right:Number = 2;
		
		/**
		 * Create a new Padding object
		 * 
		 * parameters are processed just like CSS.
		 * 
		 * If just one value, it's used for all.
		 * If just two, it's top/bottom, left/right.
		 * And, so on...
		 */
		function Padding( t:Number=-1, r:Number=-1, b:Number=-1, l:Number=-1) {
			if(t==-1) return;
			else top=bottom=t;
			
			if(r==-1) { left=right=bottom=top; return; }
			else left=right=r;
			
			if(b!=-1) bottom=b;
			
			if(l!=-1) left=l; 
		}
		
		// top + bottom
		public function get height () : Number {
			return top+bottom;
		}
		
		// left + right
		public function get width () : Number {
			return left+right;
		}
		
		public function clone() : Padding {
			return new Padding( top, right, bottom, left );
		}
		
		public function toString():String {
			return "[Padding top: "+top+" right: "+right+" bottom: "+bottom+" left: "+left+" ]";
		}
	}
}
