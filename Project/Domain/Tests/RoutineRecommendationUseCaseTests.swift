import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("RoutineRecommendationUseCase Tests")
struct RoutineRecommendationUseCaseTests {
    @Test("아침 첫 물이 늦어지는 날이 많으면 아침 루틴 추천을 반환한다")
    func morningStartRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 9, hour: 10))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                offsets: [0, 1, 2, 3, 6, 7],
                hours: [13]
            )
        )
        let useCase = RoutineRecommendationUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let recommendations = await useCase.fetchRecommendations(
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(recommendations.contains {
            $0.kind == .morningStart && $0.hour == 9 && $0.minute == 0 && !$0.weekdays.isEmpty
        })
    }

    @Test("오후 공백이 반복되면 오후 보충 루틴 추천을 반환한다")
    func afternoonGapRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 9, hour: 10))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                offsets: [0, 1, 2, 7, 8, 9],
                hours: [9, 19]
            )
        )
        let useCase = RoutineRecommendationUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let recommendations = await useCase.fetchRecommendations(
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(recommendations.contains {
            $0.kind == .afternoonGap && $0.hour == 15 && $0.minute == 0
        })
    }

    @Test("최근 자주 마신 시간대가 있으면 해당 시간 루틴 추천을 반환한다")
    func frequentHydrationRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 9, hour: 10))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                offsets: [0, 2, 4, 7],
                hours: [11],
                minute: 30
            )
        )
        let useCase = RoutineRecommendationUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let recommendations = await useCase.fetchRecommendations(
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(recommendations.first?.kind == .frequentHydrationWindow)
        #expect(recommendations.first?.hour == 11)
        #expect(recommendations.first?.minute == 30)
    }

    @Test("기존 활성 루틴과 겹치는 추천은 제외한다")
    func duplicateRecommendationIsFiltered() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 10, hour: 10))!
        let routineRepository = MockRoutineRepository()
        routineRepository.routines = [
            HydrationRoutine(
                title: "자주 마시는 시간",
                hour: 11,
                minute: 30,
                weekdays: [.monday, .wednesday, .friday],
                isEnabled: true
            )
        ]
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                offsets: [0, 2, 4],
                hours: [11],
                minute: 30
            )
        )
        let useCase = RoutineRecommendationUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let recommendations = await useCase.fetchRecommendations(
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(recommendations.contains(where: { $0.kind == .frequentHydrationWindow }) == false)
    }

    private func makeEvents(
        calendar: Calendar,
        referenceDate: Date,
        offsets: [Int],
        hours: [Int],
        minute: Int = 0
    ) -> [HydrationEvent] {
        offsets.flatMap { offset in
            hours.map { hour in
                let day = calendar.date(byAdding: .day, value: -offset, to: referenceDate) ?? referenceDate
                let consumedAt = calendar.date(
                    bySettingHour: hour,
                    minute: minute,
                    second: 0,
                    of: day
                ) ?? day

                return HydrationEvent(
                    id: UUID(),
                    consumedAt: consumedAt,
                    volumeML: 250
                )
            }
        }
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }
}
