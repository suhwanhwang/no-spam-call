import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var phoneNumber: String = ""
    @Published var searchURL: URL? = nil
    @Published var showClipboardAlert = false
    @Published var showRegisterAlert = false
    
    // MARK: - Services
    private let spamService = SpamNumberService.shared
    private let searchService = SearchService.shared
    
    // MARK: - Search methods
    func search() {
        searchURL = searchService.buildSearchURL(for: phoneNumber)
    }
    
    func searchFromClipboard() {
        if let clipboard = searchService.getNumberFromClipboard() {
            phoneNumber = clipboard
            search()
        } else {
            showClipboardAlert = true
        }
    }
    
    // MARK: - Spam registration
    func registerSpam() {
        let success = spamService.addSpamNumber(from: phoneNumber)
        if success {
            showRegisterAlert = true
        }
    }
} 