
import SwiftUI

private enum AppFontWeight: String {
    case regular = "-Regular"
    case medium = "-Medium"
    case light = "-Light"
    case semibold = "-SemiBold"
}

// MARK: - SwiftUI
extension Font {
    static let light12: Font = .ibmp(ofSize: 12, weight: .light)
    static let light13: Font = .ibmp(ofSize: 13, weight: .light)
    static let light14: Font = .ibmp(ofSize: 14, weight: .light)
    static let light15: Font = .ibmp(ofSize: 15, weight: .light)
    static let light16: Font = .ibmp(ofSize: 16, weight: .light)
    static let light17: Font = .ibmp(ofSize: 17, weight: .light)
    static let light18: Font = .ibmp(ofSize: 18, weight: .light)
    static let light20: Font = .ibmp(ofSize: 20, weight: .light)
    static let light24: Font = .ibmp(ofSize: 24, weight: .light)
    static let light28: Font = .ibmp(ofSize: 28, weight: .light)
    static let light32: Font = .ibmp(ofSize: 32, weight: .light)
    static let light48: Font = .ibmp(ofSize: 48, weight: .light)

    static let regular12: Font = .ibmp(ofSize: 12, weight: .regular)
    static let regular13: Font = .ibmp(ofSize: 13, weight: .regular)
    static let regular14: Font = .ibmp(ofSize: 14, weight: .regular)
    static let regular15: Font = .ibmp(ofSize: 15, weight: .regular)
    static let regular16: Font = .ibmp(ofSize: 16, weight: .regular)
    static let regular17: Font = .ibmp(ofSize: 17, weight: .regular)
    static let regular18: Font = .ibmp(ofSize: 18, weight: .regular)
    static let regular20: Font = .ibmp(ofSize: 20, weight: .regular)
    static let regular24: Font = .ibmp(ofSize: 24, weight: .regular)
    static let regular28: Font = .ibmp(ofSize: 28, weight: .regular)
    static let regular32: Font = .ibmp(ofSize: 32, weight: .regular)
    static let regular48: Font = .ibmp(ofSize: 48, weight: .regular)

    static let medium12: Font = .ibmp(ofSize: 12, weight: .medium)
    static let medium13: Font = .ibmp(ofSize: 13, weight: .medium)
    static let medium14: Font = .ibmp(ofSize: 14, weight: .medium)
    static let medium15: Font = .ibmp(ofSize: 15, weight: .medium)
    static let medium16: Font = .ibmp(ofSize: 16, weight: .medium)
    static let medium17: Font = .ibmp(ofSize: 17, weight: .medium)
    static let medium18: Font = .ibmp(ofSize: 18, weight: .medium)
    static let medium20: Font = .ibmp(ofSize: 20, weight: .medium)
    static let medium24: Font = .ibmp(ofSize: 24, weight: .medium)
    static let medium28: Font = .ibmp(ofSize: 28, weight: .medium)
    static let medium32: Font = .ibmp(ofSize: 32, weight: .medium)
    static let medium48: Font = .ibmp(ofSize: 48, weight: .medium)

    static let semibold12: Font = .ibmp(ofSize: 12, weight: .semibold)
    static let semibold13: Font = .ibmp(ofSize: 13, weight: .semibold)
    static let semibold14: Font = .ibmp(ofSize: 14, weight: .semibold)
    static let semibold15: Font = .ibmp(ofSize: 15, weight: .semibold)
    static let semibold16: Font = .ibmp(ofSize: 16, weight: .semibold)
    static let semibold17: Font = .ibmp(ofSize: 17, weight: .semibold)
    static let semibold18: Font = .ibmp(ofSize: 18, weight: .semibold)
    static let semibold20: Font = .ibmp(ofSize: 20, weight: .semibold)
    static let semibold24: Font = .ibmp(ofSize: 24, weight: .semibold)
    static let semibold28: Font = .ibmp(ofSize: 28, weight: .semibold)
    static let semibold32: Font = .ibmp(ofSize: 32, weight: .semibold)
    static let semibold48: Font = .ibmp(ofSize: 48, weight: .semibold)
}

private extension Font {
    static func ibmp(ofSize size: CGFloat, weight: AppFontWeight = .regular) -> Font {
        let ctFont = CTFontCreateWithName(("IBMPlexSans" + weight.rawValue) as CFString, size, nil)
        return .init(ctFont)
    }
}
