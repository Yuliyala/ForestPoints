import SwiftUI

struct MarkAsCardView: View {
    let type: MarkAsType
    
    var body: some View {
        NavigationLink(destination: MarkAsListView(type: type)) {
            ZStack {
                Image(.plansView)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 172, height: 155)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                VStack(spacing: 8) {
                    Spacer()
                    
                    Image(type.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 73, height: 72)
                    
                    Text(type.title.uppercased())
                        .font(.signikaBold(size: 20))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .frame(width: 172, height: 155)
            }
        }
    }
}

