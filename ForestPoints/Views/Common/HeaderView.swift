import SwiftUI

struct HeaderView: View {
    let title: String
    var backTapped: (() -> Void)?
    
    var body: some View {
        ZStack {
            Image(.headerBg)
                .resizable()
                .frame(height: 155)
                .padding(.horizontal, 56)
            
            AttributedTextLabel(
                attributedString: createAttributedString(
                    from: title,
                    fontSize: 32,
                    lineHeight: 34,
                    lineSpacing: -0.41
                )
            )
            
            HStack {
                Button {
                    backTapped?()
                } label: {
                    Image(.back)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .disabled(backTapped == nil)
                .opacity(backTapped == nil ? 0 : 1)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 155)
    }
}
