# Mulimi — Water Glass v2

물 한 잔이 차오르는 순간을 유리잔·물결·물방울로 단순화한 시안입니다. 캐릭터 요소 없이 물을 마시는 앱이라는 의미를 전달합니다.

`Mulimi-Water-Glass.icon`을 Icon Composer로 열면 바로 편집할 수 있습니다.

| 뒤 → 앞 | 레이어 | 파일 / 설정 |
| --- | --- | --- |
| 0 | 코발트 배경 | Composer Automatic Gradient, `#0C49A6` |
| 1 | 유리잔 | `Mulimi-Water-Glass.icon/Assets/01-glass.png` |
| 2 | 차오르는 물 | `Mulimi-Water-Glass.icon/Assets/02-water.png` |
| 3 | 물방울 | `Mulimi-Water-Glass.icon/Assets/03-droplet.png` |

PNG 3장은 모두 **1024 × 1024, 실제 알파 투명 배경**이며 동일한 캔버스 좌표를 공유합니다. 별도로 가져올 때도 Scale 1, X/Y 이동 0을 유지하고 내용 영역으로 자르지 않습니다.

몸체·물·물방울의 시작 Translucency 값은 각각 65%·25%·20%입니다. 각 그룹의 배경색, 반투명도, 그림자를 Composer에서 조절할 수 있습니다. 요청한 정사각형 1024 캔버스용 구성입니다.

`preview-default.png`와 `preview-dark.png`는 Apple의 Icon Composer `ictool`로 실제 문서를 렌더링한 1024px iOS 26 미리보기입니다. 두 결과를 직접 확인했습니다. 최종 선택 시 Clear/Tinted 외관도 Composer에서 확인하면 됩니다.

내장 이미지 생성 도구로 제작했으며 전체 프롬프트는 [GENERATION.md](GENERATION.md)에 기록했습니다. 광택과 그림자는 원본 PNG에 굽지 않고 Composer 문서에서 적용했습니다.

[Apple Icon Composer 제작 가이드](https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer)

