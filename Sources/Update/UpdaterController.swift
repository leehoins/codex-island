import AppKit
import Sparkle
import SwiftUI

/// Thin wrapper around `SPUStandardUpdaterController` so the rest of the app
/// can talk to Sparkle without importing it directly. Holds Sparkle's UI
/// driver (alert + download window) too — no extra delegate plumbing needed.
///
/// Auto-check cadence and the "automatically download" preference are stored
/// by Sparkle itself in NSUserDefaults under SU* keys, so we don't duplicate
/// that state here.
@MainActor
final class UpdaterController: ObservableObject {
    static let shared = UpdaterController()

    /// False in personal builds made with `SU_FEED_URL= ./build.sh`, which
    /// embed no Sparkle feed. Starting the updater without a feed fails at
    /// launch, so the updater is left unstarted and the UI hides itself.
    static let updatesEnabled: Bool = {
        let feed = Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") as? String
        return !(feed ?? "").isEmpty
    }()

    private let controller: SPUStandardUpdaterController

    @Published var automaticallyChecks: Bool {
        didSet { controller.updater.automaticallyChecksForUpdates = automaticallyChecks }
    }

    private init() {
        controller = SPUStandardUpdaterController(
            startingUpdater: Self.updatesEnabled,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        automaticallyChecks = Self.updatesEnabled && controller.updater.automaticallyChecksForUpdates
    }

    func checkForUpdates() {
        guard Self.updatesEnabled else { return }
        controller.checkForUpdates(nil)
    }
}
