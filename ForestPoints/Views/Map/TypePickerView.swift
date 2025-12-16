import SwiftUI

struct TypePickerView: View {
    @Binding var selectedType: PointType
    @State private var tempSelectedType: PointType?
    var onDismiss: (() -> Void)?
    var onConfirm: (() -> Void)?
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    init(selectedType: Binding<PointType>, onDismiss: (() -> Void)? = nil, onConfirm: (() -> Void)? = nil) {
        self._selectedType = selectedType
        self._tempSelectedType = State(initialValue: nil)
        self.onDismiss = onDismiss
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Type")
                    .font(.signikaSCBold(size: 35))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    onDismiss?()
                } label: {
                    Image(.closeButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(PointType.allCases, id: \.self) { type in
                    Button {
                        tempSelectedType = type
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(tempSelectedType == type ? Color.yellowButton : Color.greenLight)
                                .frame(height: 140)
                            
                            VStack(spacing: 8) {
                                Text(type.title)
                                    .font(.signikaSC(size: 22))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                
                                Image(type.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 63, height: 63)
                            }
                            .padding(.vertical, 12)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            
            Button {
                if let tempSelectedType = tempSelectedType {
                    selectedType = tempSelectedType
                    onConfirm?()
                    onDismiss?()
                }
            } label: {
                Image(tempSelectedType == nil ? .doneButtonOff : .doneButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 83)
            }
            .disabled(tempSelectedType == nil)
            .padding(.top, 32)
            .padding(.bottom, 24)
        }
        .frame(height: 517)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenOverlay)
        )
    }
}
