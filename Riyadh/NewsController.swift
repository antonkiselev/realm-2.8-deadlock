import Foundation
import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import SwiftyJSON

class NewsController: UIViewController {
    
    var dao: Dao = Dao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()

        
        // loop is to ensure bug reproducing, most of the time it happens on first iteration
        for i in 2...10 {
            
            // this is analog of pull to refresh initiated by user
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(i), execute: {
                print("first")
                self.dao.reloadAll(callback: { _ in
                    
                })
            })
            
            // this is analog of request in another controller, opened by user from first controller
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(i), execute: {
                
                // !!!! 0.1 is magic number for iphone 7 and iphone 6 in debug builds, when set to 0.2 everything works fine
                let magicDispatchTime: DispatchTime = DispatchTime.now() + 0.1
                
                // here we simulate request to backend, wich executes in background thread
                DispatchQueue.global(qos: .background).asyncAfter(deadline: magicDispatchTime, execute: {
                    let json: JSON = JSON([
                        "type": "newsCategories",
                        "json": "ewgwegwegewge"
                    ])
                    
                    // and now we map models to render them in main thread
                    DispatchQueue.main.async {
                        
                        print("second")
//                        let realm = try! Realm()
                        
                        if let model: RDJsonCache = RDJsonCache.initFrom(JSON: json) {
                            try? realm.write {
                                realm.add(model, update: true)
                            }
                        }
                    }
                })
            })
        }
    }
}
