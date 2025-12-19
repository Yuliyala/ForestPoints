import SwiftUI

struct DeleteAlertView: View {
    let title: String
    let message: String
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    init(
        title: String = "DELETE",
        message: String = "ARE YOU SURE YOU WANT TO\nDELETE THE ENTIRE HISTORY?\nTHIS ACTION CANNOT BE UNDONE",
        onDelete: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.onDelete = onDelete
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text(title.uppercased())
                    .font(.signikaBold(size: 35))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    onDismiss()
                }) {
                    Image(.closeButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            
            VStack(spacing: 4) {
                ForEach(message.split(separator: "\n").map(String.init), id: \.self) { line in
                    Text(line.uppercased())
                        .font(.signikaBold(size: 22))
                        .foregroundColor(.white)
                }
            }
            .multilineTextAlignment(.center)
            
            Button(action: {
                onDelete()
            }) {
                Image(.deleteButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 104, height: 106)
            }
            .padding(.bottom, 20)
        }
        .frame(width: 350, height: 300)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenCardBackground)
        )
    }
}

