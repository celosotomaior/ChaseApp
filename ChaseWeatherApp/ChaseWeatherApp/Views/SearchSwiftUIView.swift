import SwiftUI

struct SearchSwiftUIView: View {
    @State var placeholder: String = "Search"
    @Binding var searchTerm: String
    var action: () -> Void
    
    var body: some View {
        HStack {
           
            TextField(placeholder, text: $searchTerm, onCommit: action)
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 5.0, style: .continuous).fill(Color.gray))
            .autocapitalization(.words)
            .keyboardType(.webSearch)
            .multilineTextAlignment(.leading)
            
            Button(action: action, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .padding(.all, 5)
                    .foregroundColor(Color.blue)
            })
            .frame(width: 40, height: 40, alignment: .leading)
           
        }
    }
}
