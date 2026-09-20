import Foundation

enum IslandProvider: String, CaseIterable, Identifiable, Codable {
    case claude, codex, grok, cursor, antigravity

    var id: String { rawValue }
    var name: String {
        switch self {
        case .claude: return "Claude"
        case .codex: return "Codex"
        case .grok: return "Grok"
        case .cursor: return "Cursor"
        case .antigravity: return "Antigravity"
        }
    }
    var usesLegacyUsage: Bool { self == .claude || self == .codex }
    /// Connected providers that read OpenCodex / CLI quota (not Claude/Codex legacy pollers).
    var usesConnectedUsage: Bool { !usesLegacyUsage }
}
