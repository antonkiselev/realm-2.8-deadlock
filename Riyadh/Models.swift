import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm
import SwiftyJSON

class CBModel: Object, Mappable {
    class func initFrom<Model: CBModel>(JSON: JSON) -> Model? {
        if let dict = JSON.dictionaryObject {
            let model: Model? = initFrom(json: dict)
            return model
        }
        return nil
    }
    class func initFrom<Model: CBModel>(json: [String: Any]) -> Model? {
        if let obj = Mapper<Model>(context: nil).map(JSON: json) {
            return obj
        } else {
            return nil
        }
    }
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {}
    
    class func migrate(_ migration: Migration, _ oldSchemaVersion: UInt64) {
        migration.enumerateObjects(ofType: self.className()) { oldObject, newObject in
            migration.delete(newObject!)
        }
    }
}

class RDArticle: CBModel {
    dynamic var indexNews: Int64 = 0
    dynamic var _id: String = ""
    dynamic var title: String = ""
    dynamic var text: String?
    dynamic var html: String?
    dynamic var date: NSDate = NSDate()
    dynamic var categoryIconName: String?
    dynamic var viewsCount: Int64 = 0
    
    required convenience init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        self.init()
    }
    
    enum ContentType: String {
        case short = "Short"
        case text = "Text"
        case image = "Image"
        case video = "Video"
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["contentType"]
    }
    
    override func mapping(map: Map) {
        _id = (map["id"].currentValue as? Int64)?.description ?? "0"
        title <- map["title"]
        title = title.decodeHtml()
        text <- map["body_summary"]
        html <- map["body"]

        if let timestamp = map["created"].currentValue as? Int64 {
            date = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        categoryIconName <- map["category.0.format"]
        viewsCount <- map["views.count_views"]
    }    
}

class RDJsonCache: CBModel {
    dynamic var type: String = ""
    dynamic var date: NSDate?
    dynamic var json: String = ""
    
    required convenience init?(map: Map) {
        guard let _ = map.JSON["type"] else {
            return nil
        }
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "type"
    }
    
    override func mapping(map: Map) {
        type <- map["type"]
        date <- map["date"]
        json <- map["json"]
    }
}
