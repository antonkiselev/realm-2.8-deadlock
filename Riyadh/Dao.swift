import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm
import SwiftyJSON

class Dao {
    func reloadAll(fullReload: Bool? = nil, callback: @escaping (_ hasNext: Bool, _ error: Error?) -> Void) {
        requestItems() { [weak self] (json: JSON, error: Error?) in
            guard error == nil else { return }
            guard let _ = self else { return }
            
            let realm = try! Realm()
            realm.beginWrite()
            
            realm.deleteAll()
            
            for j: JSON in json.arrayValue {
                if let model: RDArticle = RDArticle.initFrom(JSON: j) {
                    realm.add(model, update: true)
                }
            }
            
            try! realm.commitWrite()
            
            DispatchQueue.main.async {
                if let _ = self {
                    callback(false, nil)
                }
            }
        }
    }

    func requestItems(callback: @escaping (JSON, Error?) -> Void) {
        // simulation of request, but here we just read from file
        DispatchQueue.global(qos: .background).async {
            let jsonString = try! String(contentsOfFile: Bundle.main.path(forResource: "sampleNews", ofType: "json")!)
            callback(JSON(parseJSON: jsonString)["result"]["items"], nil)
        }
    }
}
