import Foundation
import SwiftUI

class SpamListViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var spamNumbers: [SpamNumber] = []
    
    // MARK: - Services
    private let spamService = SpamNumberService.shared
    
    // MARK: - Initialization
    init() {
        loadSpamNumbers()
    }
    
    // MARK: - Methods
    func loadSpamNumbers() {
        spamNumbers = spamService.getAllSpamNumbers()
    }
    
    func deleteSpamNumber(at indices: IndexSet) {
        spamService.deleteSpamNumber(at: indices)
        spamNumbers.remove(atOffsets: indices)
    }
} 