# Mulimi Drop — v3

물방울 몸체와 작은 눈·미소로 구성한 캐릭터 아이콘입니다. 볼과 팔은 제외하고, 몸체에 민트→청록 그라데이션과 Liquid Glass를 적용했습니다.

**`Mulimi-Drop.icon`을 Icon Composer로 열면 됩니다.** 크기·배치·외관별 색이 이미 설정돼 있습니다.

## 앱 적용

iOS 앱의 기본 아이콘으로 v3를 사용합니다. `Project/App/Project.swift`에서 이 폴더의 `Mulimi-Drop.icon`을 앱 리소스로 직접 참조하고, Debug·Release 공통 `ASSETCATALOG_COMPILER_APPICON_NAME`을 `Mulimi-Drop`으로 지정합니다. 아이콘을 수정할 때는 이 원본을 편집하고 `tuist generate`로 프로젝트를 갱신하세요.

적용 검증 환경은 Xcode 27.0 (`27A266a`), Tuist 4.205.0입니다. 프로젝트 생성과 `actool`의 iPhone·iPad 아이콘 컴파일을 통과했고, 생성된 `CFBundleIconName`이 `Mulimi-Drop`인지 확인했습니다. 전체 Release 앱 빌드는 기존 `MulimiWatchExtension`의 `watchkit2-extension` 제품 형식을 Xcode 27이 지원하지 않아 완료하지 못했습니다.

## 레이어

두 원본 PNG는 모두 **1024 × 1024, 알파 투명 배경**입니다.

| 뒤 → 앞 | 파일 | Composer 배치 |
| --- | --- | --- |
| 1 | `Mulimi-Drop.icon/Assets/01-body.png` | Scale 100%, X 0 / Y 0 |
| 2 | `Mulimi-Drop.icon/Assets/02-face.png` | Scale 62%, X 0 / Y 44pt |

표정 원본은 재사용하고 Composer의 비파괴 변환으로 작게 배치했습니다. PNG만 새 문서로 가져오면 위 배치를 함께 적용하세요. `.icon`으로 열면 추가 작업이 없습니다.

## 배경과 외관

- 고정 배경 이미지·색·그라디언트가 없습니다. 현재 문서의 Background Fill은 `automatic`입니다.
- 미리보기에 나타나는 흰색·검정·틴트색 사각 면은 Apple 렌더러가 그리는 아이콘 외관입니다. 원본 PNG에 포함된 배경이 아닙니다.
- 몸체의 라이트 Fill은 위 `#B3F4DE` → 아래 `#23B6C3`, 다크 Fill은 위 `#CAF9E8` → 아래 `#4CC5C4`의 선형 그라데이션입니다. PNG에 굽지 않고 Composer의 `01 - Mint glass body` 레이어에서 편집할 수 있습니다.
- Mono는 몸체 명도 1, 표정 명도 0으로 분리합니다. 실제 틴트 색은 시스템/사용자 선택에 따라 적용됩니다. 미리보기의 녹색은 테스트용 색이며 문서에 고정하지 않았습니다.
- 현재 저장된 표정 설정은 Glass 켜짐, Specular·Shadow·Translucency 꺼짐입니다. 몸체에는 Glass·Specular, Translucency 25%, Shadow 14%를 적용했습니다. 이번 그라데이션 수정은 몸체의 라이트·다크 Fill만 변경했습니다.

## 확인한 결과

Apple Icon Composer의 `ictool`로 iOS, design generation 26을 렌더링했습니다. 그라데이션 적용 후 6가지 외관과 64px 미리보기를 갱신하고, 라이트·다크 그라데이션 및 64px 틴트 라이트·다크 표정을 직접 확인했습니다.

| 외관 | 1024px 미리보기 |
| --- | --- |
| 라이트 | [preview-light.png](preview-light.png) |
| 다크 | [preview-Dark.png](preview-Dark.png) |
| 틴트 라이트 | [preview-TintedLight.png](preview-TintedLight.png) |
| 틴트 다크 | [preview-TintedDark.png](preview-TintedDark.png) |
| 클리어 라이트 | [preview-ClearLight.png](preview-ClearLight.png) |
| 클리어 다크 | [preview-ClearDark.png](preview-ClearDark.png) |

64px 원본 크기의 라이트·틴트 라이트·틴트 다크 결과도 `preview-64-*.png`에 포함했습니다. 확인한 틴트 미리보기 값은 `--tint-color 0.48 --tint-strength 0.8`입니다. 실제 기기 설치 검증은 포함하지 않습니다.

## 제작 기록

내장 `image_gen`으로 생성한 v1의 몸체·표정 PNG를 재사용했습니다. 이번 수정은 Icon Composer 문서의 레이어 구성, 배치, 색·재질 설정으로 처리했으며 이미지를 다시 생성하지 않았습니다. [원본 생성 프롬프트와 변경 기록](GENERATION.md)

- [Apple Icon Composer](https://developer.apple.com/icon-composer/): Default/Dark/Mono 외관과 시스템 재질
- [문서 필드 참고](https://github.com/peterpoliwoda/icon-composer-template/blob/main/README.md): fill, glass, appearance specializations. 적용 결과는 Apple 렌더러로 확인했습니다.
