import Foundation

/// Reads Cursor (and other OpenCodex-cached) quota from the local OpenCodex home.
/// Does not call vendor APIs directly — OpenCodex already probes and caches.
enum CursorConnection {
    private static let separator: Character = "\u{0000}"

    struct QuotaRow {
        var monthlyPercent: Double?
        var monthlyResetAt: Double?
        var fiveHourPercent: Double?
        var fiveHourResetAt: Double?
        var weeklyPercent: Double?
        var weeklyResetAt: Double?
        var customWindows: [CustomWindow] = []
        var updatedAt: Double?
    }

    struct CustomWindow {
        var label: String
        var percent: Double?
        var resetAt: Double?
    }

    static func fetch() async throws -> ConnectedUsage {
        try Task.checkCancellation()
        let home = openCodexHome()
        let cacheURL = home.appendingPathComponent("provider-account-quota-cache.json")
        guard let data = try? Data(contentsOf: cacheURL), data.count <= 2_000_000 else {
            throw ProviderConnectionError.signIn
        }
        return try parse(data: data, provider: "cursor", now: Date())
    }

    static func openCodexHome() -> URL {
        if let override = ProcessInfo.processInfo.environment["OPENCODEX_HOME"], !override.isEmpty {
            return URL(fileURLWithPath: override, isDirectory: true)
        }
        return FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".opencodex", isDirectory: true)
    }

    static func parse(data: Data, provider: String, now: Date) throws -> ConnectedUsage {
        guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let rows = root["rows"] as? [String: Any] else {
            throw ProviderConnectionError.invalidResponse
        }

        let match = rows.first { key, _ in
            key == provider || key.hasPrefix(provider + String(separator))
        }
        guard let (rowKey, raw) = match, let row = raw as? [String: Any] else {
            throw ProviderConnectionError.signIn
        }

        var limits: [ConnectedLimit] = []

        if let percent = number(row["monthlyPercent"]) {
            limits.append(ConnectedLimit(
                id: "monthly",
                label: "month",
                usedFraction: ProviderPayload.fraction(percent / 100),
                resetAt: dateMs(row["monthlyResetAt"]),
                groupLabel: "Cursor",
                kind: .other
            ))
        }
        if let percent = number(row["fiveHourPercent"]) {
            limits.append(ConnectedLimit(
                id: "5h",
                label: "5h",
                usedFraction: ProviderPayload.fraction(percent / 100),
                resetAt: dateMs(row["fiveHourResetAt"]),
                groupLabel: "Cursor",
                kind: .session
            ))
        }
        if let percent = number(row["weeklyPercent"]) {
            limits.append(ConnectedLimit(
                id: "week",
                label: "week",
                usedFraction: ProviderPayload.fraction(percent / 100),
                resetAt: dateMs(row["weeklyResetAt"]),
                groupLabel: "Cursor",
                kind: .weekly
            ))
        }
        if let customs = row["customWindows"] as? [[String: Any]] {
            for (index, window) in customs.enumerated() {
                let label = (window["label"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let percent = number(window["percent"]) else { continue }
                let id = "custom-\(index)"
                limits.append(ConnectedLimit(
                    id: id,
                    label: (label?.isEmpty == false ? label! : "Usage"),
                    usedFraction: ProviderPayload.fraction(percent / 100),
                    resetAt: dateMs(window["resetAt"]),
                    groupID: "custom",
                    groupLabel: "Cursor windows",
                    kind: .other
                ))
            }
        }

        guard limits.contains(where: { $0.usedFraction != nil }) else {
            throw ProviderConnectionError.unavailable
        }

        // Prefer session/week first, then month / custom.
        limits.sort { lhs, rhs in
            if lhs.kind.rank != rhs.kind.rank { return lhs.kind.rank < rhs.kind.rank }
            return lhs.id < rhs.id
        }

        let accountKey = rowKey.split(separator: separator).dropFirst().first.map(String.init)
        return ConnectedUsage(
            limits: limits,
            account: accountKey,
            accountID: accountKey ?? "opencodex-cursor",
            plan: "OpenCodex",
            message: nil,
            needsLogin: false,
            updatedAt: dateMs(row["updatedAt"]) ?? now
        )
    }

    private static func number(_ value: Any?) -> Double? {
        switch value {
        case let n as Double: return n
        case let n as Int: return Double(n)
        case let n as NSNumber: return n.doubleValue
        default: return nil
        }
    }

    private static func dateMs(_ value: Any?) -> Date? {
        guard let ms = number(value), ms > 0 else { return nil }
        // OpenCodex stores epoch ms; reject seconds-scale accidents.
        let seconds = ms > 10_000_000_000 ? ms / 1000 : ms
        return Date(timeIntervalSince1970: seconds)
    }
}
