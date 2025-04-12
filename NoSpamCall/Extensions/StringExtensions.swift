import Foundation
import SwiftUI

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

extension Text {
    static func localized(_ key: String, comment: String = "") -> Text {
        return Text(NSLocalizedString(key, comment: comment))
    }
} 