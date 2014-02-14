﻿/*
  Copyright (c) 2010, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.facebook.graph {

  import com.adobe.serialization.json.JSON;
  import com.adobe.serialization.json.JSONParseError;
  import com.facebook.graph.core.AbstractFacebook;
  import com.facebook.graph.core.FacebookURLDefaults;
  import com.facebook.graph.data.FacebookSession;

  import flash.external.ExternalInterface;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.net.navigateToURL;
  import flash.utils.Dictionary;

  /**
   * Main class to connect to Facebook Graph API services.
   * For use on the web or mobile to call Facebook API methods.
   *
   * This class abstracts the Facebook Javascript SDK
   * to handle authentication showing sharing windows and
   * maintaining the current session.
   *
   */
  public class Facebook extends AbstractFacebook {

    protected var jsCallbacks:Object;
    protected var applicationId:String;
    protected static var _instance:Facebook;
    protected static var _canInit:Boolean = false;
    protected var _initCallback:Function;
    protected var _loginCallback:Function;
    protected var _logoutCallback:Function;

    /**
     * Creates an instance of Facebook.
     *
     */
    public function Facebook() {
      super();

      if (_canInit == false) {
        throw new Error(
          'Facebook is an singleton and cannot be instantiated.'
        );
      }

      jsCallbacks = {};
    }

    //Public API
    /**
     * Initializes this Facebook singleton with your Application ID.
     * You must call this method first.
     *
     * @param applicationId The application ID you created at
     * http://www.facebook.com/developers/apps.php
     *
     * @param callback Method to call when initialization is complete.
     * The handler must have the signature of callback(success:Object, fail:Object);
     * Success will be a FacebookSession if successful, or null if not.
     *
     * @param options (Optional)
     * Object of options used to instantiate the underling Javascript SDK
     *
     * @see http://developers.facebook.com/docs/reference/javascript/FB.init
     *
     */
    public static function init(applicationId:String,
                  callback:Function,
                  options:Object = null
    ):void {

      getInstance().init(applicationId, callback, options);
    }

    /**
     * Shows the Facebook login window to the end user.
     *
     * @param callback The method to call when login is successful.
     * The handler must have the signature of callback(success:Object, fail:Object);
     * Success will be a FacebookSession if successful, or null if not.
     *
     * @param options Values to modify the behavior of the login window.
     * http://developers.facebook.com/docs/reference/javascript/FB.login
     *
     */
    public static function login(callback:Function, options:Object = null):void {
      getInstance().login(callback, options);
    }

    /**
     * Re-directs the user to a mobile-friendly login form.
     *
     * @param redirectUri After a successful login,
     * Facebook will redirect the user back to this URL,
     * where the underlying Javascript SDK will notify this swf
     * that a valid login has occurred.
     *
     * @param display Type of login form to show to the user.
     * <ul>
     *	<li>touch Default; (Recommended)
     * 		Smartphone, full featured web browsers.
     * 	</li>
     *
     *	<li>wap;
     *		Older mobile web browsers,
     * 		shows a slimmer UI to the end user.
     * 	</li>
     * </ul>
     *
     * @see http://developers.facebook.com/docs/guides/mobile/
     *
     */
    public static function mobileLogin(redirectUri:String,
                       display:String = 'touch'
    ):void {

      var data:URLVariables = new URLVariables();
      data.client_id = getInstance().applicationId;
      data.redirect_uri = redirectUri;
      data.display = display;

      var req:URLRequest = new URLRequest(FacebookURLDefaults.AUTH_URL);
      req.method = URLRequestMethod.GET;
      req.data = data;

      navigateToURL(req, '_self');
    }

    /**
     * Logs the user out of their current session.
     *
     * @param callback Method to call when logout is complete.
     *
     */
    public static function logout(callback:Function):void {
      getInstance().logout(callback);
    }

    /**
     * Shows a Facebook sharing dialog.
     *
     * @param method The related method for this dialog
     *	(ex. stream.publish).
     * @param display The type of dialog to show (iframe or popup).
     * @param data Data to pass to the dialog, date will be JSON encoded.
     * @see http://developers.facebook.com/docs/reference/javascript/FB.ui
     *
     */
    public static function ui(method:String,
                    display:String,
                    data:Object
       ):void {

      getInstance().ui(method, display, data);
    }

    /**
     * Makes a new request on the Facebook Graph API.
     *
     * @param method The method to call on the Graph API.
     * For example, to load the user's current friends, pass: /me/friends
     *
     * @param calllback Method that will be called when this request is complete
     * The handler must have the signature of callback(result:Object, fail:Object);
     * On success, result will be the object data returned from Facebook.
     * On fail, result will be null and fail will contain information about the error.
     *
     * @param params Any parameters to pass to Facebook.
     * For example, you can pass {file:myPhoto, message:'Some message'};
     * this will upload a photo to Facebook.
     * @param requestMethod
     * The URLRequestMethod used to send values to Facebook.
     * The graph API follows correct Request method conventions.
     * GET will return data from Facebook.
     * POST will send data to Facebook.
     * DELETE will delete an object from Facebook.
     *
     * @see flash.net.URLRequestMethod
     * @see http://developers.facebook.com/docs/api
     *
     */
    public static function api(method:String,
                     callback:Function = null,
                     params:* = null,
                     requestMethod:String = 'GET'
    ):void {

      return getInstance().api(method,
        callback,
        params,
        requestMethod
      );
    }

    /**
     * Shortcut method to post data to Facebook.
     * Alternatively,
     * you can call Facebook.request and use POST for requestMethod.
     *
     * @see com.facebook.graph.net.Facebook#api()
     */
    public static function postData(
      method:String,
      callback:Function = null,
      params:Object = null
    ):void {

      api(method, callback, params, URLRequestMethod.POST);
    }

    /**
     * Executes an FQL query on api.facebook.com.
     *
     * @param query The FQL query string to execute.
     * @see http://developers.facebook.com/docs/reference/fql/
     * @see com.facebook.graph.net.Facebook#callRestAPI()
     *
     */
    public static function fqlQuery(query:String, callback:Function):void {
      getInstance().fqlQuery(query, callback);
    }

    /**
     * Used to make old style RESTful API calls on Facebook.
     * Normally, you would use the Graph API to request data.
     * This method is here in case you need to use an old method,
     * such as FQL.
     *
     * @param methodName Name of the method to call on api.facebook.com
     * (ex, fql.query).
     * @param values Any values to pass to this request.
     * @param requestMethod URLRequestMethod used to send data to Facebook.
     *
     */
    public static function callRestAPI(methodName:String,
                       callback:Function,
                       values:* = null,
                       requestMethod:String = 'GET'
    ):void {

      return getInstance().callRestAPI(methodName, callback, values, requestMethod);
    }

    /**
     * Utility method to format a picture URL,
     * in order to load an image from Facebook.
     *
     * @param id The ID you wish to load an image from.
     * @param type The size of image to display from Facebook
     * (square, small, or large).
     *
     * @see http://developers.facebook.com/docs/api#pictures
     *
     */
    public static function getImageUrl(id:String,
                       type:String = null
    ):String {

      return getInstance().getImageUrl(id, type);
    }

    /**
     * Deletes an object from Facebook.
     * The current user must have granted extended permission
     * to delete the corresponding object,
     * or an error will be returned.
     *
     * @param method The ID and connection of the object to delete.
     * For example, /POST_ID/like to remove a like from a message.
     *
     * @see http://developers.facebook.com/docs/api#deleting
     * @see com.facebook.graph.net.FacebookDesktop#api()
     *
     */
    public static function deleteObject(method:String, callback:Function = null):void {
      getInstance().deleteObject(method, callback);
    }

    /**
     * Utility method to add listeners to the underlying Facebook library.
     * @param event Name of the Javascript event to listen for.
     * @param listener Name of function to call when event is fired.
     *
     * This method will need to accept an optional result:Object,
     * that will be the decoded JSON result, if one exists.
     *
     * @see http://developers.facebook.com/docs/reference/javascript/FB.Event.subscribe
     *
     */
    public static function addJSEventListener(event:String,
                          listener:Function
    ):void {

      getInstance().addJSEventListener(event, listener);
    }

    /**
     * Removes a Javascript event listener,
     * added by Facebook.addJSEventListener();
     *
     * @see #addJSEventListener();
     *
     */
    public static function removeJSEventListener(event:String,
                           listener:Function
    ):void {

      getInstance().removeJSEventListener(event, listener);
    }

    /**
     * Checks to see if a specified event listener exists.
     *
     */
    public static function hasJSEventListener(event:String,
                          listener:Function
    ):Boolean {

      return getInstance().hasJSEventListener(event, listener);
    }

    /**
     * @see http://developers.facebook.com/docs/reference/javascript/FB.Canvas.setAutoResize
     *
     */
    public static function setCanvasAutoResize(autoSize:Boolean = true,
                           interval:uint = 100
    ):void {

      getInstance().setCanvasAutoResize(autoSize, interval);
    }

    /**
     * @see http://developers.facebook.com/docs/reference/javascript/FB.Canvas.setSize
     *
     */
    public static function setCanvasSize(width:Number, height:Number):void {
      getInstance().setCanvasSize(width, height);
    }

    /**
     * Calls an arbitrary Javascript method on the underlying HTML page.
     *
     */
    public static function callJS(methodName:String, params:Object):void {
      getInstance().callJS(methodName, params);
    }

    /**
     * Synchronous method to retrieve the current user's session.
     *
     */
    public static function getSession():FacebookSession {
      return getInstance().getSession();
    }

    /**
    * Asynchronous method to get the user's current session from Facebook.
    *
    * This method calls out to the underlying Javascript SDK
    * to check what the current user's login status is.
    * You can listen for a javscript event by using
    * Facebook.addJSEventListener('auth.sessionChange', callback)
    * @see http://developers.facebook.com/docs/reference/javascript/FB.getLoginStatus
    *
    */
    public static function getLoginStatus():void {
      getInstance().getLoginStatus();
    }

    //Protected methods

    protected function init(applicationId:String,
              callback:Function,
              options:Object = null
    ):void {
	
		if (ExternalInterface.available)
		{
      ExternalInterface.addCallback('handleJsEvent', handleJSEvent);
      ExternalInterface.addCallback('sessionChange', handleSessionChange);
		}
      _initCallback = callback;
      this.applicationId = applicationId;

      if (options == null) { options = {};}
      options.appId = applicationId;
	
	  	if (ExternalInterface.available)
		{
      ExternalInterface.call('fb_init', JSON.encode(options));
		}
      getLoginStatus();
    }

    protected function getLoginStatus():void {
		if (ExternalInterface.available)
		{
      ExternalInterface.call('fb_getLoginStatus');
		}
    }

    protected function callJS(methodName:String, params:Object):void {
      ExternalInterface.call(methodName, params);
		
    }

    protected function setCanvasSize(width:Number, height:Number):void {
      ExternalInterface.call('fb_setCanvasSize', width, height);
    }

    protected function setCanvasAutoResize(autoSize:Boolean = true,
                         interval:uint = 100
    ):void {

      ExternalInterface.call('fb_setCanvasAutoResize',
        autoSize,
        interval
      );
    }

    protected function login(callback:Function, options:Object = null):void {
      _loginCallback = callback;

      ExternalInterface.call('fb_login', JSON.encode(options));
    }

    protected function logout(callback:Function):void {
      _logoutCallback = callback;
      ExternalInterface.addCallback('logout', handleLogout);
      ExternalInterface.call('fb_logout');
    }

    protected function getSession():FacebookSession {
      var result:String = ExternalInterface.call('fb_getSession');
      var sessionObj:Object;

      try {
        sessionObj = JSON.decode(result);
      } catch (e:*) {
        return null;
      }

      var s:FacebookSession = new FacebookSession();
      s.fromJSON(sessionObj);
      this.session = s;

      return session;
    }

    protected function ui(method:String,
                  display:String,
                  data:Object
    ):void {

      data.method = method;

      if (display) {
        data.display = display;
      }

      ExternalInterface.call('fb_ui', JSON.encode(data));
    }

    protected function addJSEventListener(event:String,
                        listener:Function
    ):void {

      if (jsCallbacks[event] == null) {
        jsCallbacks[event] = new Dictionary();
        ExternalInterface.call('fb_addEventListener', event);
      }

      jsCallbacks[event][listener] = null;
    }

    protected function removeJSEventListener(event:String,
                         listener:Function
    ):void {

      if (jsCallbacks[event] == null) { return; }

      delete jsCallbacks[event][listener];
    }

    protected function hasJSEventListener(event:String,
                        listener:Function
    ):Boolean {

      if (jsCallbacks[event] == null
        || jsCallbacks[event][listener] !== null
      ) {
        return false;
      }

      return true;
    }

    protected function handleLogout():void {
      if (_logoutCallback != null) {
        _logoutCallback(true);
        _logoutCallback = null;
      }
    }

    protected function handleJSEvent(event:String,
                     result:String = null
    ):void {

      if (jsCallbacks[event] != null) {
        var decodedResult:Object;
        try {
          decodedResult = JSON.decode(result);
        } catch (e:JSONParseError) { }

        for (var func:Object in jsCallbacks[event]) {
          (func as Function)(decodedResult);
          delete jsCallbacks[event][func];
        }
      }
    }

    protected function handleSessionChange(result:String,
                         permissions:String = null
    ):void {
      var resultObj:Object;
      var success:Boolean = true;

      if (result != null) {
        try {
          resultObj = JSON.decode(result);
        } catch (e:JSONParseError) {
          success = false;
        }
      } else {
        success = false;
      }

      if (success) {
        if (session == null) {
          session = new FacebookSession();
          session.fromJSON(resultObj);
        } else {
          session.fromJSON(resultObj);
        }

        if (permissions != null) {
          try {
            session.availablePermissions = JSON.decode(permissions);
          } catch (e:JSONParseError) {
            session.availablePermissions = null;
          }
        }
      }
 
      if (_initCallback != null) {
        _initCallback(session, null);
        _initCallback = null;
      }

      if (_loginCallback != null) {
        _loginCallback(session, null);
        _loginCallback = null;
      }
    }

    protected static function getInstance():Facebook {
      if (_instance == null) {
        _canInit = true;
        _instance = new Facebook();
        _canInit = false;
      }
      return _instance;
    }
  }
}
