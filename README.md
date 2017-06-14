# realm-2.8-deadlock

This is sample project to reproduce Swift Realm deadlock in versions 2.8.1 (and most likely in 2.7 and later)

It is 100% reproducable on my iphone 6 and iphone 7 devices under debug build and in xcode 8.3.3 iphone 7 simulator.

Look into NewsController to check how it's done. There are some comments to explain how this case is appearing in real application. In syntetic case is's just bunch of thread jumps and delays.

In real app i have table view in NewsController populated with models from Dao class, I pull to refresh, which triggers data request, maps data in background thread and data reloads table, and at the same time tap button to open another controller, which on load makes request and caches some RDJsonCache models in realm in main thread, to show it as soon as possible. 
