import SwiftUI
import WatchDependencyInjection

@main
@MainActor
struct MulimiWatchApp: App {
    private let rootView = WatchDIContainer().makeRootView()

    var body: some Scene {
        WindowGroup {
            rootView
        }
    }
}
