import SwiftUI

struct DeleteAlertView: View {
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("DELETE")
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
                Text("ARE YOU SURE YOU WANT TO".uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                
                Text("DELETE THE ENTIRE HISTORY?".uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                
                Text("THIS ACTION CANNOT BE UNDONE".uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
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

