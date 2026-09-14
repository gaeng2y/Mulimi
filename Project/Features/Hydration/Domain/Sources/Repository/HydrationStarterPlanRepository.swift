public protocol HydrationStarterPlanRepository: Sendable {
    func fetchPlan() -> HydrationStarterPlan?
    func savePlan(_ plan: HydrationStarterPlan)
}
