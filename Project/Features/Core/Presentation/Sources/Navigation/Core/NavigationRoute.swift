public protocol NavigationRoute: Hashable, Identifiable {
    var presentationStyle: NavigationPresentationStyle { get }
}
