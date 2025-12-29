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
            headerView
            typeGridView
            doneButton
        }
        .frame(height: 517)
        .background(backgroundView)
    }
    
    private var headerView: some View {
        HStack {
            Text("Type")
                .font(.signikaBold(size: 35))
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
    }
    
    private var typeGridView: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(PointType.allCases, id: \.self) { type in
                typeButton(for: type)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    private func typeButton(for type: PointType) -> some View {
        Button {
            tempSelectedType = type
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(tempSelectedType == type ? Color.yellowButton : Color.greenLight)
                    .frame(height: 140)
                
                VStack(spacing: 8) {
                    Text(type.title)
                        .font(.signikaBold(size: 22))
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
    
    private var doneButton: some View {
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
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color.greenOverlay)
    }
}
