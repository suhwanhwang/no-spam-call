import Foundation
import UIKit

class SearchService {
    // MARK: - Shared instance
    static let shared = SearchService()
    
    private init() {}
    
    // MARK: - Methods
    func buildSearchURL(for phoneNumber: String) -> URL? {
        let query = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.google.com/search?q=\(query)")
    }
    
    func getNumberFromClipboard() -> String? {
        return UIPasteboard.general.string
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Implementation could be added if needed to format for display
        return phoneNumber
    }
} 