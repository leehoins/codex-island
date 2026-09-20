import SwiftUI
import Combine

@MainActor
final class IslandModel: ObservableObject {
    enum State {
        case compact
        case peek
        case expanded
    }

    /// Fired when a swipe tries to page past either end of the carousel.
    /// `PagedContent` turns it into a small rubber-band nudge so the
    /// dead-end gesture gets visible feedback instead of silently doing
    /// nothing. Fresh id per attempt so repeated over-swipes re-trigger.
    struct EdgeBump: Equatable {
        let id: UUID
        let direction: Int
    }

    @Published var state: State = .compact
    @Published var size: CGSize = .zero
    @Published var notch: NotchInfo
    @Published var edgeBump: EdgeBump?

    /// Side extension that houses each brand logo in compact state.
    let tabWidth: CGFloat = 38

    /// Per-side readout wing for 3–4 providers. RENDER-ONLY: it is
    /// deliberately NOT part of `size`, so the black silhouette stays at the
    /// bare physical notch while the marks draw on the menu bar pixels just
    /// outside it. Folding it into the silhouette (as an extended tab) made
    /// the island read as a hugely widened notch.
    let multiTabWidth: CGFloat = 78

    /// Per-side outboard slot that houses the peek-state percentage pill.
    /// Sized for "100% · Nd Nh" worst case at the chosen pill typography
    /// (weekly Codex windows can land at e.g. `6d 23h`). Fixed (not
    /// text-measured) so percentage updates don't jitter the silhouette
    /// width during refresh. Grown symmetrically on both sides regardless
    /// of which provider is visible — keeps the silhouette balanced over
    /// the physical notch.
    let pillSlotWidth: CGFloat = 96

    /// Compact cell used when 3–4 providers share the peek strip (`O 32%`).
    let multiPeekCellWidth: CGFloat = 54

    /// How many providers are currently selected for the island chrome.
    @Published private(set) var selectedCount: Int = 2

    /// Mouse-facing bounds. Identical to `size` except in 3–4 provider mode:
    /// there the silhouette is only the bezel notch (no pixels, impossible to
    /// aim at) and the readout renders on the menu bar outside it, so hover
    /// and click must accept those wings or the island becomes unclickable.
    var interactiveSize: CGSize {
        guard state != .expanded, selectedCount > 2 else { return size }
        return CGSize(width: size.width + multiTabWidth * 2, height: size.height)
    }

    /// Visible expanded panel width — must stay inside the floating window.
    private var expandedWidth: CGFloat { selectedCount >= 3 ? 880 : 800 }

    /// Silhouette-extending tab. In 3–4 provider mode the readout lives
    /// outside the silhouette (see `multiTabWidth`), so the shape must not
    /// grow at all — it stays exactly the physical notch.
    private var sideTabWidth: CGFloat {
        selectedCount > 2 ? 0 : tabWidth
    }

    // Mirrors measured content for hit testing; it does not constrain expanded layout.
    private var expandedHeight: CGFloat = 0

    /// Detection-pure notch from `NotchInfo.detect`. Kept separate from
    /// `notch` (which has the user's spacing override applied) so
    /// `updateNotch`'s diff guard isn't confused by override-induced
    /// width changes that originate from the store, not the screen.
    private var rawNotch: NotchInfo

    private var subs: Set<AnyCancellable> = []

    init(notch: NotchInfo) {
        self.rawNotch = notch
        self.notch = Self.applyOverride(to: notch, width: IslandSpacingStore.shared.width)
        self.selectedCount = ProviderVisibilityStore.shared.selected.count
        recomputeSize()
        subscribeToSpacingStore()
        subscribeToVisibilityStore()
    }

    func setState(_ new: State) {
        guard new != state else { return }
        if new == .expanded, expandedHeight < 80 {
            // Seed before the first layout pass so openMorph doesn't
            // start at notch-height then jump when GeometryReader reports.
            expandedHeight = estimatedExpandedHeight
        }
        state = new
        recomputeSize()
    }

    /// Stable estimate so the silhouette doesn't bounce on first expand.
    private var estimatedExpandedHeight: CGFloat {
        let header: CGFloat = selectedCount > 2
            ? notch.height + 34
            : max(32, notch.height)
        return header + IslandPanelLayout.tileHeight + IslandPanelLayout.footerHeight + 8
    }

    func updateNotch(_ raw: NotchInfo) {
        guard raw.width != rawNotch.width
            || raw.height != rawNotch.height
            || raw.hasNotch != rawNotch.hasNotch else { return }
        rawNotch = raw
        notch = Self.applyOverride(to: raw, width: IslandSpacingStore.shared.width)
        recomputeSize()
    }

    func updateExpandedHeight(_ height: CGFloat) {
        guard height > 0, abs(expandedHeight - height) > 0.5 else { return }
        expandedHeight = height
        if state == .expanded { recomputeSize() }
    }

    func advanceScreen() {
        let pages = ScreenPref.Screen.allCases
        let index = ScreenPref.shared.screen.pageIndex
        guard index < pages.count - 1 else {
            edgeBump = EdgeBump(id: UUID(), direction: 1)
            return
        }
        showScreen(pages[index + 1])
    }

    func rewindScreen() {
        let pages = ScreenPref.Screen.allCases
        let index = ScreenPref.shared.screen.pageIndex
        guard index > 0 else {
            edgeBump = EdgeBump(id: UUID(), direction: -1)
            return
        }
        showScreen(pages[index - 1])
    }

    func showScreen(_ screen: ScreenPref.Screen) {
        guard ScreenPref.shared.screen != screen else { return }

        withAnimation(.pageSwipe) {
            ScreenPref.shared.screen = screen
        }
    }

    /// Substitutes the user's chosen non-notch width for the detected
    /// fallback. On notched screens the raw notch is returned untouched —
    /// the override is meaningless there (you can't shrink a physical
    /// notch).
    private static func applyOverride(to raw: NotchInfo, width: CGFloat) -> NotchInfo {
        if raw.hasNotch { return raw }
        return NotchInfo(width: width, height: raw.height, hasNotch: false)
    }

    /// Re-applies the override and re-computes size whenever the user
    /// changes spacing mode. The `mode` value here is the *new* value from
    /// the closure parameter — `IslandSpacingStore.shared.mode` would be
    /// the *old* value at this point because `@Published` emits during
    /// willSet, before the property assignment lands. Reading `mode.width`
    /// off the closure parameter sidesteps the race.
    ///
    /// Wrapped in `withAnimation(.openMorph)` so the silhouette springs to
    /// its new width with the same feel as a state morph.
    private func subscribeToSpacingStore() {
        IslandSpacingStore.shared.$mode
            .dropFirst()
            .sink { [weak self] mode in
                guard let self else { return }
                let new = Self.applyOverride(to: self.rawNotch, width: mode.width)
                guard new.width != self.notch.width else { return }
                withAnimation(.openMorph) {
                    self.notch = new
                    self.recomputeSize()
                }
            }
            .store(in: &subs)
    }

    private func subscribeToVisibilityStore() {
        ProviderVisibilityStore.shared.$selected
            .receive(on: RunLoop.main)
            .sink { [weak self] selected in
                guard let self else { return }
                let count = max(1, selected.count)
                guard count != self.selectedCount else { return }
                withAnimation(.openMorph) {
                    self.selectedCount = count
                    self.recomputeSize()
                }
            }
            .store(in: &subs)
    }

    private func recomputeSize() {
        let wing = sideTabWidth
        switch state {
        case .compact:
            // Side tabs sit on real pixels beside the hardware notch
            // (notch.width itself has no display — drawing there is invisible).
            size = CGSize(
                width: notch.width + wing * 2,
                height: notch.height
            )
        case .peek:
            if selectedCount > 2 {
                size = CGSize(
                    width: notch.width + wing * 2,
                    height: notch.height
                )
            } else {
                size = CGSize(
                    width: notch.width + wing * 2 + pillSlotWidth * 2,
                    height: notch.height
                )
            }
        case .expanded:
            size = CGSize(
                width: expandedWidth,
                height: max(notch.height, expandedHeight)
            )
        }
    }
}
