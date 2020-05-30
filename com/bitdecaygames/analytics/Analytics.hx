package com.bitdecaygames.analytics;

import net.lion123dev.GameAnalytics;
import net.lion123dev.events.Events.GAPlatform;

class Analytics {
	private static var ga:GameAnalytics;

	public static function Instance():GameAnalytics {
		if (ga == null) {
			trace("Analytics not init'ed. Creating Sandbox instance");
			Init("5c6bcb5402204249437fb5a7a80a4959", "16813a12f718bc5c620f56944e1abc3ea13ccbac");
		}

		return ga;
	}

	static function setExitHandler(func:Void->Void):Void {
		openfl.Lib.current.stage.application.onExit.add(function(code) {
			func();
		});
	}

	public static function Close() {
		Instance().EndSession();
		Instance().ForcePost();
	}

	public static function Init(gameKey:String, secret:String, sandbox:Bool = true) {
		if (ga != null) {
			trace("already initialized. this call will do nothing");
			return;
		}

		ga = new GameAnalytics(gameKey, secret, false);

		ga.Init(onSuccess, onFail, GAPlatform.WINDOWS, GAPlatform.WINDOWS + "10", "unknown", "unknown");
		ga.StartPosting();

		setExitHandler(function() {
			Close();
		});
	}

	// Now we need to initialize it with success and fail callbacks, platform, os version, device and manufacturer. Some of these parameters may be removed later and auto generated instead.
	private static function onSuccess():Void {
		// Success callback is called when init request return success.
	}

	private static function onFail(error:String):Void {
		// Fail callback basically means that GameAnalytics can't work right now. Offline event caching is not yet available.
		// String parameter may contain useful information on why fail happened
		trace(error);
	}
}
