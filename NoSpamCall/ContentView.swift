import SwiftUI
import WebKit

struct ContentView: View {
    @State private var phoneNumber: String = ""
    @State private var searchURL: URL? = nil
    @State private var showClipboardAlert = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("전화번호 입력 또는 붙여넣기", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            HStack {
                Button("📋 클립보드에서 검색") {
                    searchFromClipboard()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("검색") {
                    search(with: phoneNumber)
                }
                .padding()
                .background(Color.blue)
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
