import SwiftUI

struct UpcomingVisitCardView: View {
    let point: ForestPoint
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48)
                .fill(Color.greenCardBackground)
                .frame(width: 350, height: 234)

            VStack(spacing: 0) {
                Spacer().frame(height: 16)

                if let imageData = point.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 310, height: 135)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.greenLight)
                        .frame(width: 310, height: 135)
                        .overlay(
                            Image(.camera)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        )
                }

                Spacer().frame(height: 10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(point.name.uppercased())
                        .font(.signikaBold(size: 22))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    if let desiredDate = point.desiredDate {
                        HStack(spacing: 8) {
                            Image(.calendar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 27, height: 28)

                            Text(formattedDate(desiredDate))
                                .font(.signikaBold(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(width: 350, height: 234)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

