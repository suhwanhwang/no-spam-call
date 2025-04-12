//
//  SpamListView.swift
//  NoSpamCall
//
//  Created by Suhwan Hwang on 4/12/25.
//

import SwiftUI
import CallKit

struct SpamListView: View {
    @State private var spamList: [String] = []

    var body: some View {
        List {
            ForEach(spamList, id: \.self) { number in
                Text(formatPhoneNumber(number))
            }
            .onDelete(perform: deleteSpam)
        }
        .navigationTitle("스팸 번호 목록")
        .onAppear {
            loadSpamList()
        }
    }

    func loadSpamList() {
        let defaults = UserDefaults(suiteName: appGroupID)
        spamList = defaults?.array(forKey: "spamList") as? [String] ?? []
    }

    func deleteSpam(at offsets: IndexSet) {
        let defaults = UserDefaults(suiteName: appGroupID)
        var list = defaults?.array(forKey: "spamList") as? [String] ?? []
        list.remove(atOffsets: offsets)
        defaults?.set(list, forKey: "spamList")
        spamList = list

        // Reload CallKit Extension
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: extensionBundleID) { error in
            if let error = error {
                print("❌ Reload failed: \(error.localizedDescription)")
            }
        }
    }
    
    func formatPhoneNumber(_ number: String) -> String {
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
