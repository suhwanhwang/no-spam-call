import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Country selection and phone number input
                HStack {
                    // Country code selection button
                    Button(action: {
                        viewModel.showCountryPicker = true
                    }) {
                        let countryName = viewModel.availableCountryCodes.first(where: { $0.code == viewModel.selectedCountryCode })?.name ?? ""
                        Text(countryName)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                    .sheet(isPresented: $viewModel.showCountryPicker) {
                        countryPickerView
                    }
                    
                    TextField("phone_input".localized, text: $viewModel.phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()

                HStack {
                    Button("search_button".localized) {
                        viewModel.search()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("clipboard_button".localized) {
                        viewModel.searchFromClipboard()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("register_spam_button".localized) {
                        viewModel.registerSpam()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    NavigationLink(destination: SpamListView()) {
                        Text("view_list_button".localized)
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
            .navigationTitle("app_title".localized)
            .alert(isPresented: $viewModel.showClipboardAlert) {
                Alert(
                    title: Text("invalid_number_title".localized),
                    message: Text("invalid_number_message".localized),
                    dismissButton: .default(Text("ok_button".localized))
                )
            }
            .alert(isPresented: $viewModel.showRegisterAlert) {
                Alert(
                    title: Text("registered_title".localized),
                    message: Text("registered_message".localized),
                    dismissButton: .default(Text("ok_button".localized))
                )
            }
        }
    }
    
    // Country code selection sheet
    private var countryPickerView: some View {
        NavigationView {
            List {
                ForEach(viewModel.availableCountryCodes, id: \.code) { country in
                    Button(action: {
                        viewModel.selectCountryCode(country.code)
                    }) {
                        Text(country.name)
                    }
                }
            }
            .navigationTitle("country_picker_title".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ok_button".localized) {
                        viewModel.showCountryPicker = false
                    }
                }
            }
        }
    }
}
