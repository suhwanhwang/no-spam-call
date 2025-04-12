import Foundation

struct SpamNumber: Identifiable, Hashable {
    let id: UUID = UUID()
    let value: String
    
    var formattedNumber: String {
        formatPhoneNumber(value)
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        // 숫자만 남기기
        let digits = number.filter { $0.isNumber }
        
        // 국가번호가 두 자리가 되도록 처리
        if digits.count > 2 {
            let countryCode = digits.prefix(2)  // 국가번호 2자리
            let localNumber = digits.dropFirst(2)
            
            // 지역번호가 2자리 또는 3자리로 구분됨
            if localNumber.count == 9 {
                let areaCode = localNumber.prefix(2)
                let firstPart = localNumber.dropFirst(2).prefix(3)
                let secondPart = localNumber.suffix(4)
                return "+\(countryCode)-\(areaCode)-\(firstPart)-\(secondPart)"
            } else if localNumber.count == 10 {
                let areaCode = localNumber.prefix(2)
                let firstPart = localNumber.dropFirst(2).prefix(4)
                let secondPart = localNumber.suffix(4)
                return "+\(countryCode)-\(areaCode)-\(firstPart)-\(secondPart)"
            } else if localNumber.count == 11 {
                let areaCode = localNumber.prefix(3)
                let firstPart = localNumber.dropFirst(3).prefix(4)
                let secondPart = localNumber.suffix(4)
                return "+\(countryCode)-\(areaCode)-\(firstPart)-\(secondPart)"
            } else {
                return number // 예외 처리: 잘못된 번호
            }
        }
        
        return number
    }
} 