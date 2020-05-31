## Using this library

1. Install the library via haxelib: 

`haxelib git bitdecayanalytics https://github.com/bitDecayGames/Analytics.git`

2. Add the dependency in your project (`project.xml` for HaxeFlixel):

`<haxelib name="bitdecayanalytics" />`

3. Start the initilization of the analytics

`Analytics.Init(<game key>, <secret key>, false);`

4. Make sure this library is ready. `Ready()` is non-blocking and should be called in the game loop to know when things are good to go.

`Analytics.Ready()`

5. Use the instance to report analytics

`Analytics.Instance().<Create/Send functions>`

### Notes

* This library automatically rigs up the shutdown logic to detect when the app is closed and flush any remaining analytics.
