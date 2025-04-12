import CallKit
import Foundation

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

    func addSpamNumber(from phoneNumber: String, countryCode: String? = nil) -> Bool {
        let numberOnly = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard numberOnly.count >= 8 else { return false }

        let code = countryCode ?? getCountryCodeForCurrentLocale()
        let formatted = formatNumberWithCountryCode(numberOnly, countryCode: code)

        var list = userDefaults?.array(forKey: Constants.spamListKey) as? [String] ?? []

        if !list.contains(formatted) {
            list.append(formatted)
            userDefaults?.set(list, forKey: Constants.spamListKey)
            reloadExtension()
            return true
        }

        return false
    }

    private func getCountryCodeForCurrentLocale() -> String {
        let locale = Locale.current
        let regionCode: String
        
        if #available(iOS 16, *) {
            regionCode = locale.region?.identifier.lowercased() ?? ""
        } else {
            // For older iOS versions
            regionCode = locale.regionCode?.lowercased() ?? ""
        }

        switch regionCode {
        case "kr":
            return Constants.CountryCode.korea
        case "us":
            return Constants.CountryCode.usa
        default:
            return Constants.CountryCode.korea
        }
    }

    private func formatNumberWithCountryCode(_ number: String, countryCode: String) -> String {
        if number.hasPrefix(countryCode) {
            return number
        } else if number.hasPrefix("0") {
            return countryCode + number.dropFirst()
        } else {
            return countryCode + number
        }
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
                print("❌ Extension reload failed: \(error.localizedDescription)")
            } else {
                print("🔄 Extension reload successful")
            }
        }
    }
}
