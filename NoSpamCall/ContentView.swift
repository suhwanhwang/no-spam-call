import SwiftUI
import WebKit
import Foundation
import CallKit

let appGroupID = "group.dev.shwang.app.NoSpamCall"
let extensionBundleID = "dev.shwang.app.NoSpamCall.SpamCallDirectoryExtension"

struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var searchURL: URL? = nil
    @State private var showClipboardAlert = false
    @State private var showRegisterAlert = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("전화번호 입력 또는 붙여넣기", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            HStack {
                Button("검색") {
                    search(with: phoneNumber)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("📋 클립보드 검색") {
                    searchFromClipboard()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("📛 스팸 등록") {
                    registerSpam(from: phoneNumber)
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            if let url = searchURL {
                WebView(url: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Spacer()
            }
        }
        .alert(isPresented: $showClipboardAlert) {
            Alert(title: Text("유효한 전화번호가 아닙니다"), message: Text("클립보드에 올바른 번호가 없습니다."), dismissButton: .default(Text("확인")))
        }
        .alert(isPresented: $showRegisterAlert) {
            Alert(title: Text("등록 완료"),
                  message: Text("스팸 번호로 저장했어요."),
                  dismissButton: .default(Text("확인")))
        }
    }

    func search(with number: String) {
        let query = number.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.google.com/search?q=\(query)") {
            searchURL = url
        }
    }

    func searchFromClipboard() {
        if let clipboard = UIPasteboard.general.string {
            phoneNumber = clipboard
            search(with: clipboard)
        } else {
            showClipboardAlert = true
        }
    }
    
    func registerSpam(from number: String) {
        // 숫자만 추출
        let numberOnly = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // 최소 8자리 이상일 때 등록
        guard numberOnly.count >= 8 else {
            return
        }

        // 국가번호 붙이기 (예: 01012345678 → 821012345678)
        let formatted = numberOnly.hasPrefix("82") ? numberOnly : "82" + numberOnly.dropFirst()

        let defaults = UserDefaults(suiteName: appGroupID)
        var spamList = defaults?.array(forKey: "spamList") as? [String] ?? []

        if !spamList.contains(formatted) {
            spamList.append(formatted)
            defaults?.set(spamList, forKey: "spamList")
            print("✅ 번호 저장 완료: \(formatted)")
        } else {
            print("ℹ️ 이미 등록된 번호: \(formatted)")
        }

        // Extension 리로드
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: extensionBundleID) { error in
            if let error = error {
                print("❌ 리로드 실패: \(error.localizedDescription)")
            } else {
                print("🔄 Call Directory Extension 리로드 성공")
            }
        }

        showRegisterAlert = true
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
