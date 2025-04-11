//
//  CallDirectoryHandler.swift
//  SpamCallDirectoryExtension
//
//  Created by Suhwan Hwang on 4/12/25.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {
    
    let appGroupID = "group.dev.shwang.app.NoSpamCall"

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        // 1. AppGroup에서 UserDefaults 가져오기
        guard let sharedDefaults = UserDefaults(suiteName: appGroupID) else {
            context.completeRequest()
            return
        }
        
        // 2. 저장된 번호 목록 가져오기
        let spamList = sharedDefaults.array(forKey: "spamList") as? [String] ?? []

        // 3. 번호를 시스템에 등록
        for number in spamList {
            if let intValue = Int64(number) {
                context.addIdentificationEntry(
                    withNextSequentialPhoneNumber: intValue,
                    label: "스팸 전화"
                )
            }
        }

        context.completeRequest()
    }
}
