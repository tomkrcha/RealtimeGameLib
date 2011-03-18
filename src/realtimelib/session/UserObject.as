/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib.session
{
	
	/**
	 * object used for storing user information in the user list. 
	 */
	public class UserObject
	{
		public var id:String;
		public var name:String;
		public var stamp:Number;
		public var address:String;
		public var idle:Date;
		public var label:String;
		
		public var details:Object;
	}
}