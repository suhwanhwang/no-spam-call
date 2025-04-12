import SwiftUI

struct SpamListView: View {
    @StateObject private var viewModel = SpamListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.spamNumbers) { spamNumber in
                Text(spamNumber.formattedNumber)
            }
            .onDelete(perform: viewModel.deleteSpamNumber)
        }
        .navigationTitle("spam_list_title".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleSortOrder()
                }) {
                    HStack {
                        Text(viewModel.sortOrder.localizedName)
                        Image(systemName: viewModel.sortOrder == .ascending ? "arrow.up" : "arrow.down")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadSpamNumbers()
        }
    }
} 