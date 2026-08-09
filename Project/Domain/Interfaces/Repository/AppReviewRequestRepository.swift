public protocol AppReviewRequestRepository: Sendable {
    func fetchState() -> AppReviewRequestState
    func saveState(_ state: AppReviewRequestState)
}
