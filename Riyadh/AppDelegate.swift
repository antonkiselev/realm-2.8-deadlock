import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            let models: [CBModel.Type] = [
                RDArticle.self,
                ]
            for model in models {
                model.migrate(migration, oldSchemaVersion)
            }
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIStoryboard(name: "News", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsController")
        self.window = window
        window.makeKeyAndVisible()

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    }
}

