import SwiftUI

struct CustomNavigationButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? .brown : .gray)
                .scaleEffect(scale)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5), value: scale)

            Text(label)
                .font(.footnote)
                .foregroundColor(isSelected ? .brown : .gray)
                .scaleEffect(scale)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5), value: scale)
        }
        .padding(.horizontal, 8)
        .onTapGesture {
            action()
            withAnimation {
                scale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    scale = 1.0
                }
            }
        }
    }
}

