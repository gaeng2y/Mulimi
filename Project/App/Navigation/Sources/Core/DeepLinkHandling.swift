import Foundation

public protocol DeepLinkHandling: AnyObject {
    func handleDeepLink(_ url: URL)
}
