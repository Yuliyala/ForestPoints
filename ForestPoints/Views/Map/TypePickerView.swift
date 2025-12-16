import SwiftUI

struct TypePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedType: PointType
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TYPE")
                .font(.signikaSC(size: 28))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(PointType.allCases, id: \.self) { type in
                    Button {
                        selectedType = type
                        dismiss()
                    } label: {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedType == type ? Color.yellow.opacity(0.8) : Color.greenLight)
                                .frame(height: 80)
                                .overlay(
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                            
                            Text(type.title)
                                .font(.signikaSC(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.greenBg)
    }
}

