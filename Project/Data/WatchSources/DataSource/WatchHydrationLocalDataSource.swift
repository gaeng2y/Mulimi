import Foundation
import PersistenceWatch
import SwiftData
import WatchDomainLayerInterface

protocol WatchHydrationLocalDataSource: Sendable {
    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent]
    func addDrink(volumeML: Int, consumedAt: Date) async
    func resetEvents(on date: Date) async
}

actor WatchHydrationSwiftDataSource: WatchHydrationLocalDataSource {
    private let modelContainer: ModelContainer
    private let calendar: Calendar

    init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar

        do {
            self.modelContainer = try SharedHydrationStore.makeModelContainer()
        } catch {
            do {
                self.modelContainer = try SharedHydrationStore.makeModelContainer(
                    isStoredInMemoryOnly: true,
                    cloudSyncEnabled: false,
                    shouldFallbackToLocalStore: false
                )
            } catch {
                fatalError("Failed to initialize watch hydration store: \(error)")
            }
        }
    }

    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent] {
        do {
            return try fetchEventModels(on: date, using: makeContext()).map {
                WatchHydrationEvent(
                    id: $0.id,
                    consumedAt: $0.consumedAt,
                    volumeML: $0.volumeML
                )
            }
        } catch {
            assertionFailure("Failed to fetch watch hydration events: \(error)")
            return []
        }
    }

    func addDrink(volumeML: Int, consumedAt: Date) async {
        do {
            let context = makeContext()
            context.insert(
                HydrationEventModel(
                    consumedAt: consumedAt,
                    volumeML: volumeML
                )
            )
            try context.save()
        } catch {
            assertionFailure("Failed to save watch hydration event: \(error)")
        }
    }

    func resetEvents(on date: Date) async {
        do {
            let context = makeContext()
            try fetchEventModels(on: date, using: context).forEach { context.delete($0) }
            try context.save()
        } catch {
            assertionFailure("Failed to reset watch hydration events: \(error)")
        }
    }

    private func makeContext() -> ModelContext {
        ModelContext(modelContainer)
    }

    private func fetchEventModels(
        on date: Date,
        using context: ModelContext
    ) throws -> [HydrationEventModel] {
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)
            ?? dayStart.addingTimeInterval(86_400)

        let descriptor = FetchDescriptor<HydrationEventModel>(
            predicate: #Predicate { model in
                model.consumedAt >= dayStart && model.consumedAt < dayEnd
            },
            sortBy: [SortDescriptor(\.consumedAt, order: .forward)]
        )

        return try context.fetch(descriptor)
    }
}
