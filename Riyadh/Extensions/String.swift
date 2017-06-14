import Foundation
import UIKit

extension String {
    public func decodeHtml() -> String {
        if let stringData: Data = self.data(using: String.Encoding.utf8) {
        
            if let decodedString: NSAttributedString = try? NSAttributedString(data: stringData, options: [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
                ], documentAttributes: nil) {
                
                return decodedString.string
            }
        }
        return self
    }
}
