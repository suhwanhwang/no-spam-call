import Foundation
import CallKit

class SpamNumberService {
    // MARK: - Shared instance
    static let shared = SpamNumberService()
    
    private init() {}
    
    // MARK: - User Defaults
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: Constants.appGroupID)
    }
    
    // MARK: - Methods
    func getAllSpamNumbers() -> [SpamNumber] {
        let rawList = userDefaults?.array(forKey: Constants.spamListKey) as? [String] ?? []
        return rawList.map { SpamNumber(value: $0) }
    }
    
    func addSpamNumber(from phoneNumber: String) -> Bool {
        let numberOnly = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard numberOnly.count >= 8 else { return false }
        
        let formatted = numberOnly.hasPrefix("82") ? numberOnly : "82" + numberOnly.dropFirst()
        
        var list = userDefaults?.array(forKey: Constants.spamListKey) as? [String] ?? []
        
        if !list.contains(formatted) {
            list.append(formatted)
            userDefaults?.set(list, forKey: Constants.spamListKey)
            reloadExtension()
            return true
        }
        
        return false
    }
    
    func deleteSpamNumber(at indices: IndexSet) {
        var list = userDefaults?.array(forKey: Constants.spamListKey) as? [String] ?? []
        list.remove(atOffsets: indices)
        userDefaults?.set(list, forKey: Constants.spamListKey)
        reloadExtension()
    }
    
    func reloadExtension() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: Constants.extensionBundleID) { error in
            if let error = error {
                print("❌ Extension 리로드 실패: \(error.localizedDescription)")
            } else {
                print("🔄 Extension 리로드 성공")
            }
        }
    }
} 