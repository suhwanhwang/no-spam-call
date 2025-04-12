import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("전화번호 입력 또는 붙여넣기", text: $viewModel.phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()

                HStack {
                    Button("검색") {
                        viewModel.search()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("클립보드") {
                        viewModel.searchFromClipboard()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("스팸등록") {
                        viewModel.registerSpam()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    NavigationLink(destination: SpamListView()) {
                        Text("등록번호조회")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                if let url = viewModel.searchURL {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Spacer()
                }
            }
            .navigationTitle("No Spam Call")
            .alert(isPresented: $viewModel.showClipboardAlert) {
                Alert(
                    title: Text("유효한 전화번호가 아닙니다"),
                    message: Text("클립보드에 올바른 번호가 없습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
            .alert(isPresented: $viewModel.showRegisterAlert) {
                Alert(
                    title: Text("등록 완료"),
                    message: Text("스팸 번호로 저장했어요."),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
}
