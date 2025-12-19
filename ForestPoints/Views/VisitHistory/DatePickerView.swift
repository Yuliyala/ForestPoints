import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @State private var tempSelectedDate: Date
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._tempSelectedDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Spacer()
            
            datePickerSection
            
            Spacer()
            
            confirmButton
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            Image(.closeButton)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .opacity(0)
            
            Text("SELECT DATE")
                .font(.signikaBold(size: 30))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var datePickerSection: some View {
        DatePicker("", selection: $tempSelectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.greenBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .colorScheme(.dark)
    }
    
    private var confirmButton: some View {
        Button(action: {
            selectedDate = tempSelectedDate
        }) {
            Image(.doneButton)
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 108)
        }
        .padding(.bottom, 20)
    }
}
