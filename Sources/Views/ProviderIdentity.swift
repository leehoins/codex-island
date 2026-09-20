import SwiftUI

extension IslandProvider {
    func planDisplayName(_ plan: String?) -> String? {
        guard let plan else { return nil }
        if self == .codex {
            switch plan.lowercased() {
            case "prolite", "pro": return "Pro"
            case "plus": return "Plus"
            default: break
            }
        }
        return plan
    }

    var color: Color {
        switch self {
        case .claude: return IslandColor.claude
        case .codex: return IslandColor.codex
        case .grok: return IslandColor.grok
        case .cursor: return IslandColor.cursor
        case .antigravity: return IslandColor.antigravity
        }
    }
    var legacy: AlertEngine.Provider? {
        switch self {
        case .claude: return .claude
        case .codex: return .codex
        default: return nil
        }
    }

    /// One-letter peek glyph when packing 3–4 providers into the notch.
    var peekAbbrev: String {
        switch self {
        case .claude: return "A"
        case .codex: return "O"
        case .grok: return "G"
        case .cursor: return "C"
        case .antigravity: return "Y"
        }
    }
}

struct ProviderMark: View {
    let provider: IslandProvider
    var size: CGFloat = 20

    private static let claude = Bundle.main.url(forResource: "claude_logo", withExtension: "pdf").flatMap { NSImage(contentsOf: $0) }
    private static let codex = Bundle.main.url(forResource: "openai_logo", withExtension: "pdf").flatMap { NSImage(contentsOf: $0) }

    private static let grok = Bundle.main.url(forResource: "grok_logo", withExtension: "png").flatMap { NSImage(contentsOf: $0) }
    private static let antigravity = Bundle.main.url(forResource: "antigravity_logo", withExtension: "png").flatMap { NSImage(contentsOf: $0) }

    private var image: NSImage? {
        switch provider {
        case .claude: return Self.claude
        case .codex: return Self.codex
        case .grok: return Self.grok
        case .cursor: return nil
        case .antigravity: return Self.antigravity
        }
    }

    var body: some View {
        Group {
            if let image {
                Image(nsImage: image).resizable().renderingMode(.template).scaledToFit()
            } else if provider == .cursor {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .resizable().scaledToFit()
            } else {
                Image(systemName: provider == .grok ? "asterisk" : "a.circle")
                    .resizable().scaledToFit()
            }
        }
        .foregroundStyle(provider.color)
        .frame(width: size, height: size)
        .accessibilityLabel(provider.name)
    }
}
