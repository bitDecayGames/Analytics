package com.bitdecaygames.analytics;

import hx.concurrent.executor.Executor;
import net.lion123dev.GameAnalytics;
import net.lion123dev.events.Events.GAPlatform;

class Analytics {
	private static var ga:GameAnalytics;
	private static var exec:Executor;
	private static var analyticsStarter:TaskFuture<Bool>;

	public static function Instance():GameAnalytics {
		if (ga == null) {
			trace("Analytics not init'ed. Creating Sandbox instance");
			Init("5c6bcb5402204249437fb5a7a80a4959", "16813a12f718bc5c620f56944e1abc3ea13ccbac", true);
			analyticsStarter.waitAndGet(-1);
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

	public static function Init(gameKey:String, secret:String, sandbox:Bool) {
		if (ga != null) {
			trace("already initialized. this call will do nothing");
			return;
		}

		ga = new GameAnalytics(gameKey, secret, sandbox);
		setExitHandler(function() {
			trace("closing down analytics");
			Close();
		});

		exec = Executor.create();
		analyticsStarter = exec.submit(startAnalytics, Schedule.ONCE(0));
	}

	private static function startAnalytics():Bool {
		trace("init'ing analytics");
		ga.Init(onSuccess, onFail, GAPlatform.WINDOWS, GAPlatform.WINDOWS + " 10", "unknown", "unknown");

		ga.OnSubmitFail = onFail;
		ga.OnSubmitSuccess = onSuccess;
		ga.StartPosting();
		return true;
	}

	public static function Ready():Bool {
		// make sure we have an instance to BE ready
		Instance();

		// report if our starter has finished
		return analyticsStarter != null && analyticsStarter.isStopped;
	}

	// Now we need to initialize it with success and fail callbacks, platform, os version, device and manufacturer. Some of these parameters may be removed later and auto generated instead.
	private static function onSuccess():Void {
		// Success callback is called when init request return success.
		trace("game analytics request sucessful");
	}

	private static function onFail(error:String):Void {
		// Fail callback basically means that GameAnalytics can't work right now. Offline event caching is not yet available.
		// String parameter may contain useful information on why fail happened
		trace("game analytics experienced request failure");
		trace(error);
	}
}
