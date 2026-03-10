<p align="center">
<img src="https://github.com/gaeng2y/Mulimi/blob/main/Images/app%20icon.png?raw=true" width="300" height="300">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-18.0%2B-0A84FF?style=for-the-badge&logo=apple&logoColor=white" alt="iOS 18.0+">
  <img src="https://img.shields.io/badge/Swift-6.0-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/SwiftUI-MVVM-1A73E8?style=for-the-badge&logo=swift&logoColor=white" alt="SwiftUI MVVM">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Clean_Architecture-Modular-111111?style=for-the-badge" alt="Modular Clean Architecture">
  <img src="https://img.shields.io/badge/Tuist-Project_Generation-00B4D8?style=for-the-badge" alt="Tuist">
  <img src="https://img.shields.io/badge/SwiftData-CloudKit_Sync-2E7D32?style=for-the-badge&logo=icloud&logoColor=white" alt="SwiftData + CloudKit">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/WidgetKit-Home_Widget-0F766E?style=for-the-badge" alt="WidgetKit">
  <img src="https://img.shields.io/badge/HealthKit-Water_Tracking-D32F2F?style=for-the-badge" alt="HealthKit">
  <img src="https://img.shields.io/badge/Firebase-Analytics%20%26%20Crashlytics-FF6F00?style=for-the-badge&logo=firebase&logoColor=white" alt="Firebase">
</p>

## 물리미 (Mulimi)

- 앱스토어 링크: [링크](https://apps.apple.com/us/app/%EB%AC%BC%EB%A6%AC%EB%AF%B8/id6451200968)

**매일 잊지 않고 물 한 잔, 물리미와 함께 건강한 수분 섭취 습관을 만들어보세요.**

현대인에게 부족한 수분 보충을 위해 매일 8잔(2.0L)의 물을 마실 수 있도록 도와주는 간단하고 직관적인 물 마시기 트래커 앱입니다.

---

## ✨ 주요 기능

- **물 마시기 기록**: 버튼 하나로 간편하게 마신 물의 양을 기록합니다.
- **일일 목표 달성률 시각화**: 귀여운 물방울 애니메이션으로 오늘 얼마나 마셨는지 한눈에 확인하세요.
- **Apple Health 연동**: 기록한 물의 양을 HealthKit에 자동으로 저장하여 건강 데이터를 통합 관리합니다.
- **홈 화면 위젯**: 앱을 켜지 않고도 홈 화면에서 오늘 마신 물의 양을 바로 확인할 수 있습니다.

---

## 🛠️ 기술 스택 및 아키텍처

### Core Stack
- **Swift 6.0 / SwiftUI / iOS 18+**: 최신 Swift Concurrency와 선언형 UI를 기반으로 구현했습니다.
- **Tuist**: 모듈형 프로젝트 생성 및 의존성 관리를 담당합니다.
- **SwiftData + CloudKit**: 물 섭취 이벤트를 앱/위젯 및 기기 간 동기화하며, 실패 시 로컬 저장소로 자동 폴백합니다.
- **HealthKit / WidgetKit**: 건강 데이터 통합 및 홈 화면 위젯 기능을 제공합니다.
- **Firebase Analytics / Crashlytics**: 앱 사용 분석과 크래시 모니터링을 수행합니다.

### Architecture
- **Modular Clean Architecture + MVVM**: 레이어별 책임을 분리하고 테스트 가능한 구조를 유지합니다.
- **Dependency Injection (Swinject)**: 모듈 간 결합도를 낮추고 구현 교체/테스트를 단순화합니다.
---

## 🏗️ 프로젝트 구조

프로젝트는 Tuist를 통해 관리되는 여러 모듈로 구성되어 있습니다.

```
Mulimi/
├── XCConfig/                # 빌드 설정 (팀 ID, 환경값)
├── Project/
│   ├── App/                 # 앱 진입점, AppDelegate, 런타임 조립
│   ├── Presentation/        # SwiftUI 뷰/뷰모델 (MVVM)
│   ├── Domain/              # UseCase, Entity, Repository 인터페이스
│   ├── Data/                # Repository 구현, DataSource (SwiftData/HealthKit 등)
│   ├── Widget/              # WidgetKit 위젯 및 AppIntent
│   └── Shared/
│       ├── DependencyInjection/
│       ├── Persistence/     # SharedHydrationStore, HydrationEventModel
│       ├── DesignSystem/
│       └── Utils/
└── Tuist/
    ├── ProjectDescriptionHelpers/
    └── Package.swift        # 외부 라이브러리 의존성 관리
```

- **`App`**: 앱 생명주기/전역 설정을 관리하고 각 모듈을 연결합니다.
- **`Presentation`**: UI와 상태 관리(MVVM), 사용자 상호작용을 처리합니다.
- **`Domain`**: 순수 비즈니스 규칙과 유스케이스를 정의합니다.
- **`Data`**: Domain 인터페이스의 구현체를 제공하며 SwiftData/HealthKit/인증 데이터 소스와 연결됩니다.
- **`Widget`**: 위젯 타임라인과 위젯 액션(AppIntent)을 담당합니다.
- **`Shared`**: DI, 공통 Persistence, 디자인 시스템, 유틸리티를 제공합니다.

---

## 🚀 시작하기 (Makefile 사용 - 권장)

Makefile을 사용하여 프로젝트 설정을 자동화할 수 있습니다. 아래 명령어를 터미널에 입력하세요.

```bash
make setup TEAM_ID=YOUR_APPLE_DEVELOPER_TEAM_ID
```

위 명령어는 다음 작업을 자동으로 수행합니다:
1.  `Secrets.xcconfig` 파일을 생성하고 팀 ID를 설정합니다.
2.  Tuist 의존성을 설치합니다 (`tuist install`).
3.  Xcode 프로젝트를 생성합니다 (`tuist generate`).


## 🚀 시작하기 (수동 설정)

1. **저장소 복제**:
   ```bash
   git clone https://github.com/gaeng2y/Mulimi.git
   cd Mulimi
   ```

2. **Tuist 설치**:
   ```bash
   curl https://mise.run | sh #mise 설치
   mise install tuist
   ```

3. **팀 설정**:
   - `XCConfig/Secrets.xcconfig.template` 파일을 복사하여 `XCConfig/Secrets.xcconfig` 파일을 생성합니다.
   - 생성된 `Secrets.xcconfig` 파일의 `YOUR_TEAM_ID` 부분을 본인의 Apple Developer 팀 ID로 변경해야 합니다.

4. **의존성 설치 및 프로젝트 생성**:
   ```bash
   tuist install
   tuist generate
   ```

생성된 `Mulimi.xcworkspace` 파일을 Xcode에서 열어주세요.
