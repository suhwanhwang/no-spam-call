import Foundation
import SwiftUI

class SpamListViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var spamNumbers: [SpamNumber] = []
    @Published var sortOrder: SortOrder = .ascending
    
    // MARK: - Sort options
    enum SortOrder {
        case ascending
        case descending
        
        var name: String {
            switch self {
            case .ascending: return "A to Z"
            case .descending: return "Z to A"
            }
        }
        
        var localizedName: String {
            switch self {
            case .ascending: return "sort_ascending".localized
            case .descending: return "sort_descending".localized
            }
        }
    }
    
    // MARK: - Services
    private let spamService = SpamNumberService.shared
    
    // MARK: - Initialization
    init() {
        loadSpamNumbers()
    }
    
    // MARK: - Methods
    func loadSpamNumbers() {
        let numbers = spamService.getAllSpamNumbers()
        spamNumbers = sortedNumbers(numbers)
    }
    
    func toggleSortOrder() {
        sortOrder = sortOrder == .ascending ? .descending : .ascending
        spamNumbers = sortedNumbers(spamNumbers)
    }
    
    private func sortedNumbers(_ numbers: [SpamNumber]) -> [SpamNumber] {
        switch sortOrder {
        case .ascending:
            return numbers.sorted { $0.value < $1.value }
        case .descending:
            return numbers.sorted { $0.value > $1.value }
        }
    }
    
    func deleteSpamNumber(at indices: IndexSet) {
        spamService.deleteSpamNumber(at: indices)
        spamNumbers.remove(atOffsets: indices)
    }
} 