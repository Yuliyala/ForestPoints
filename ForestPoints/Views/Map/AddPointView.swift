import SwiftUI

struct AddPointView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "ADD ENTRY") {
                dismiss()
            }
            
            Spacer()
            
            Text("Add Point Form")
                .font(.signikaSC(size: 24))
                .foregroundColor(.white)
            
            Spacer()
        }
        .bgSetup()
    }
}

