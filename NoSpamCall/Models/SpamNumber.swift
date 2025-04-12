import Foundation

struct SpamNumber: Identifiable, Hashable {
    let id: UUID = UUID()
    let value: String
    
    var formattedNumber: String {
        formatPhoneNumber(value)
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        // Extract only digits
        let digits = number.filter { $0.isNumber }
        
        // Too short numbers are returned as-is
        guard digits.count >= 7 else { return number }
        
        // For Korean numbers (starting with 82)
        if digits.hasPrefix("82") {
            let localNumber = String(digits.dropFirst(2))
            let lastFourDigits = localNumber.suffix(4)
            let remainingDigits = localNumber.dropLast(4)
            
            // Seoul area code (single digit - 2)
            if localNumber.hasPrefix("2") {
                return "+82 2-\(localNumber.dropFirst(1).prefix(localNumber.count - 5))-\(lastFourDigits)"
            }
            
            // Two-digit area codes (metropolitan cities and provinces)
            if remainingDigits.count >= 2 {
                let areaCode = remainingDigits.prefix(2)  // 31, 32, 33, etc.
                let middlePart = remainingDigits.dropFirst(2)
                
                if middlePart.isEmpty {
                    return "+82 \(areaCode)-\(lastFourDigits)"
                } else {
                    return "+82 \(areaCode)-\(middlePart)-\(lastFourDigits)"
                }
            }
            
            // Other cases (mobile phones, etc.)
            if remainingDigits.count <= 3 {
                return "+82 \(remainingDigits)-\(lastFourDigits)"
            } else {
                let areaCode = remainingDigits.prefix(3)  // Carrier code, etc.
                let middlePart = remainingDigits.dropFirst(3)
                
                if middlePart.isEmpty {
                    return "+82 \(areaCode)-\(lastFourDigits)"
                } else {
                    return "+82 \(areaCode)-\(middlePart)-\(lastFourDigits)"
                }
            }
        }
        
        // For other countries
        // Simple formatting based on length
        let countryCodeLength: Int
        if digits.hasPrefix("1") {       // USA/Canada
            countryCodeLength = 1
        } else if digits.hasPrefix("7") { // Russia
            countryCodeLength = 1
        } else if digits.count >= 10 {    // Most other countries
            countryCodeLength = 2
        } else {
            countryCodeLength = digits.count < 9 ? 1 : 2
        }
        
        let countryCode = digits.prefix(countryCodeLength)
        let localNumber = String(digits.dropFirst(countryCodeLength))
        
        // Always separate the last 4 digits
        let lastDigits = localNumber.suffix(4)
        let firstDigits = localNumber.dropLast(4)
        
        if firstDigits.isEmpty {
            return "+\(countryCode) \(lastDigits)"
        } else {
            return "+\(countryCode) \(firstDigits)-\(lastDigits)"
        }
    }
}
