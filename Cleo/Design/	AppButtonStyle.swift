import SwiftUI

enum ButtonVariant {
    case primary
    case secondary
    case outline
    case danger
}

struct AppButtonStyle: ButtonStyle {
    let variant: ButtonVariant
    var isDisabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor(configuration: configuration))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: variant == .outline ? 1.5 : 0)
            )
            .cornerRadius(12)
            .opacity(opacity(configuration: configuration))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    // MARK: - Colors

    private var foregroundColor: Color {
        switch variant {
        case .primary: return .white
        case .secondary: return .white
        case .outline: return .blue
        case .danger: return .white
        }
    }

    private var borderColor: Color {
        switch variant {
        case .outline: return .blue
        default: return .clear
        }
    }

    private func backgroundColor(configuration: Configuration) -> Color {
        if isDisabled {
            return Color.gray.opacity(0.4)
        }

        switch variant {
        case .primary:
            return configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue

        case .secondary:
            return configuration.isPressed ? Color.gray.opacity(0.7) : Color.gray

        case .outline:
            return configuration.isPressed ? Color.blue.opacity(0.1) : Color.clear

        case .danger:
            return configuration.isPressed ? Color.red.opacity(0.7) : Color.red
        }
    }

    private func opacity(configuration: Configuration) -> Double {
        isDisabled ? 0.6 : 1.0
    }
}
