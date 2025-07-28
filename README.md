## 💧 물리미

<p align="center">
<img src="https://github.com/gaeng2y/Mulimi/blob/main/Images/app%20icon.png?raw=true" width="300" height="300">
</p>

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

### Core Technologies
- **Swift & SwiftUI**: Apple의 최신 프레임워크를 사용하여 선언적이고 현대적인 UI를 구현했습니다.
- **Tuist**: 모듈화된 프로젝트 구조를 효율적으로 관리하고 빌드 시간을 단축하기 위해 사용합니다.
- **Combine**: 비동기적인 데이터 흐름을 처리합니다.

### Architecture
- **모듈형 클린 아키텍처 (Modular Clean Architecture)**: 프로젝트를 여러 개의 독립적인 모듈(Framework)로 분리하여 유지보수성과 확장성을 높였습니다. 의존성 방향이 `App` -> `Presentation` -> `Domain` -> `Data`로 흐르도록 설계하여 각 레이어의 역할을 명확히 했습니다.

### External Libraries
- **[Swinject](https://github.com/Swinject/Swinject)**: 의존성 주입(DI)을 관리하여 코드의 결합도를 낮추고 테스트 용이성을 확보합니다.
- **[supabase-swift](https://github.com/supabase/supabase-swift)**: Supabase와의 연동을 통해 백엔드 기능을 구현합니다. (필요시 사용)
- 
---

## 🏗️ 프로젝트 구조

프로젝트는 Tuist를 통해 관리되는 여러 모듈로 구성되어 있습니다.

```
Mulimi/
├── XCConfig/             # 빌드 설정 (팀 ID 등)
├── Project/
│   ├── App/              # 앱의 진입점, DI 컨테이너 설정
│   ├── Data/             # 데이터 소스 구현 (UserDefaults, HealthKit, API 등)
│   ├── Domain/           # 핵심 비즈니스 로직, UseCase, Repository 인터페이스
│   ├── Presentation/     # UI (Views, ViewModels), 화면 흐름 관리
│   └── Widget/           # 홈 화면 위젯
└── Tuist/
    ├── ProjectDescriptionHelpers/
    └── Package.swift       # 외부 라이브러리 의존성 관리
```

- **`App`**: 앱의 생명주기를 관리하고, `Swinject`를 사용해 각 모듈의 의존성을 조립하는 최종 단계입니다.
- **`Presentation`**: SwiftUI로 작성된 뷰와 뷰 로직을 포함합니다. `Domain` 레이어의 UseCase를 사용하여 비즈니스 로직을 실행합니다.
- **`Domain`**: 앱의 핵심 규칙과 UseCase를 정의합니다. 다른 레이어에 의존하지 않는 순수한 Swift 모듈입니다.
- **`Data`**: `Domain` 레이어의 Repository 인터페이스에 대한 구체적인 구현을 제공합니다. `HealthKit`, `UserDefaults`, `Supabase` API 등 실제 데이터 소스와의 통신을 담당합니다.
- **`Widget`**: `WidgetKit`을 사용하여 홈 화면에 표시될 위젯의 뷰와 타임라인을 정의합니다.

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
