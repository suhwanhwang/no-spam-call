import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    // MARK: - Published properties

    @Published var phoneNumber: String = ""
    @Published var searchURL: URL? = nil
    @Published var showClipboardAlert = false
    @Published var showRegisterAlert = false
    @Published var selectedCountryCode: String
    @Published var showCountryPicker = false

    // MARK: - Services

    private let spamService = SpamNumberService.shared
    private let searchService = SearchService.shared

    // MARK: - Initialization

    init() {
        // 현재 로케일에 따라 초기 국가 코드 설정
        let locale = Locale.current
        let regionCode = locale.regionCode?.lowercased() ?? ""
        
        switch regionCode {
        case "kr":
            selectedCountryCode = Constants.CountryCode.korea
        case "us":
            selectedCountryCode = Constants.CountryCode.usa
        default:
            selectedCountryCode = Constants.CountryCode.korea
        }
    }

    // MARK: - Country codes

    var availableCountryCodes: [(code: String, name: String)] {
        [
            (Constants.CountryCode.korea, "country_code_korea".localized),
            (Constants.CountryCode.usa, "country_code_usa".localized)
        ]
    }

    func selectCountryCode(_ code: String) {
        selectedCountryCode = code
        showCountryPicker = false
    }

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
        let success = spamService.addSpamNumber(from: phoneNumber, countryCode: selectedCountryCode)
        if success {
            showRegisterAlert = true
        }
    }
}
