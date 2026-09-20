# Mulimi Liquid Glass 아이콘 — #339, v1

기존 물리미의 웃는 물방울을 민트색 몸체, 분홍 볼, 짙은 청록 표정으로 정리한 시안입니다.

`Mulimi-Liquid-Glass.icon`을 Icon Composer로 열면 배경과 전경 3개 그룹을 바로 편집할 수 있습니다. PNG는 모두 **1024 × 1024, 실제 알파 투명 배경**이며 같은 캔버스를 공유합니다.

| 뒤 → 앞 | 구성 | 파일 / 설정 |
| --- | --- | --- |
| 0 | 배경 | Composer의 Automatic Gradient, 기준색 `#168C9C` |
| 1 | 물방울 몸체 | `Mulimi-Liquid-Glass.icon/Assets/01-body.png` |
| 2 | 두 볼 | `Mulimi-Liquid-Glass.icon/Assets/02-cheeks.png` |
| 3 | 눈과 미소 | `Mulimi-Liquid-Glass.icon/Assets/03-face.png` |

## 사용

1. `.icon` 파일을 Icon Composer로 엽니다. 레이어 배치가 이미 설정돼 있습니다.
2. 몸체 그룹은 Translucency 35%, Shadow 18%를 시작값으로 설정했습니다. 볼과 표정은 불투명하게 유지합니다. 모두 편집 가능한 시안 설정입니다.
3. 배경색과 몸체의 투명도를 조절하고 Default / Dark / Clear / Tinted 외관을 확인합니다.
4. 레이어만 가져오려면 `Assets`의 PNG 3개를 새 1024 캔버스에 넣습니다. 전부 Scale 1, X/Y 이동 0을 유지하고 앞뒤 순서를 위 표에 맞춥니다. 레이어별 내용 영역으로 자르지 않습니다.

색과 밝기에는 생성 이미지의 미세한 색상 차이가 포함됩니다. 정확한 브랜드 단색이 필요하면 Composer에서 각 레이어의 Color를 재지정할 수 있습니다. 목표색은 몸체 `#9EE6DF`, 볼 `#FFB5BE`, 표정 `#174D57`입니다.

## 미리보기와 확인

- `preview-default.png`, `preview-dark.png`: Apple Icon Composer의 `ictool`로 실제 `.icon` 문서를 렌더링한 1024 × 1024 iOS 26 미리보기입니다.
- 기본/다크 합성을 직접 확인했습니다. 투명 PNG 크기, 네 모서리의 완전 투명 여부, 볼·표정이 몸체 안에 놓이는지도 검사했습니다.
- 미리보기에는 시스템 아이콘 마스크와 효과가 적용돼 있습니다. 가져올 원본 레이어에는 마스크나 유리 광택을 굽지 않았습니다.
- 이 시안은 요청한 정사각형 1024 캔버스용입니다. Clear/Tinted 외관과 실제 홈 화면의 작은 크기는 최종 선택 시 Composer/기기에서 추가 확인할 항목입니다.

## 제작 기록

레이어 생성은 내장 `image_gen`을 사용했습니다. 생성 프롬프트 전체는 [GENERATION.md](GENERATION.md)에 있습니다. 생성 원본의 캔버스를 macOS `sips`로 1024 정사각형에 맞췄으며, 배경과 유리 효과는 Composer 문서에서 설정했습니다.

문서 형식은 저장소의 기존 `Images/mulimi.icon`을 참고했습니다. 새 문서가 Apple 렌더러에서 열리고 렌더링되는 것까지 확인했습니다.

[Apple의 Icon Composer 제작 가이드](https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer)에 따라 배경, 그림자, 광택, 반투명도는 Composer에서 조정하는 구성입니다.
