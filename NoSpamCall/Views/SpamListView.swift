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
        .navigationTitle("스팸 번호 목록")
        .onAppear {
            viewModel.loadSpamNumbers()
        }
    }
} 