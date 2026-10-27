# App Store 헤더·검색 결과 에셋

2026-10-27 제작. 두 영역 모두 정적 이미지로 선택했다. Mulimi의 핵심 경험인 물 마시기·간편한 기록은 한 장으로 전달할 수 있고, 민트색 물방울 브랜드를 반복 재생 없이 인식할 수 있기 때문이다. 영상보다 전환율이 높다는 실험 결과를 의미하지 않는다.

## 사용할 파일

| 배치 | 파일 | 규격 | 내용 |
| --- | --- | --- | --- |
| 제품 페이지 헤더 | [header-3840x1646.png](header-3840x1646.png) | 3840×1646, RGB PNG, sRGB, 알파 없음 | 기존 v3 캐릭터의 민트 물방울·잔잔한 물결. 문구가 없어 공통 사용 가능 |
| 검색 결과 — 한국어 | [search-ko-1920x1280.png](search-ko-1920x1280.png) | 1920×1280, 3:2, RGB PNG, sRGB, 알파 없음 | “물 마시고, 한 번에 기록.”과 수분 기록 UI 표현 |

App Store Connect 에셋 라이브러리에서 각각 헤더와 한국어 검색 결과 배치에 사용한다. 앱 스크린샷·앱 미리보기 업로드 슬롯과는 별개다. 생성 원본과 문서는 업로드 대상이 아니다.

## 디자인 근거와 원본

- 브랜드 기준: [현재 앱 아이콘](../AppIcon-339-v3/preview-light.png), 민트→청록 물방울, 작은 눈·미소, 앱의 따뜻한 회백색 배경.
- 검색 UI 참고: [실제 DrinkWaterView 테스트 캡처](../../Docs/product-specs/assets/issue-350/recovered.png)의 아래쪽 물방울·섭취량·기록 버튼. 상단 임시 호스트 제목과 안내 카드는 제외했다.
- 검색 이미지는 캡처를 참고해 **생성한 홍보용 UI 표현**이다. 원본 스크린샷을 픽셀 그대로 붙인 결과나 앱 전체 화면이 아니다. 표시된 500ml는 테스트 데이터이며, 2잔·목표 2,000ml·마시기 액션은 참조 화면과 일치한다.
- 내장 `image_gen`을 사용했다. [전체 프롬프트 및 보정 기록](GENERATION.md).
- [헤더 생성 원본](sources/header-source.png)은 1916×821, [검색 생성 원본](sources/search-ko-source.png)은 1536×1024이다. 제출용 파일은 각각 약 2.00배·1.25배 리샘플링한 결과이며, 네이티브 4K 생성물은 아니다. `sips`로 규격과 sRGB를 맞췄다.

## 안전 영역과 확인 사항

Apple 공식 PSD의 `Art Safe Area` 레이어를 기준으로 핵심 요소를 중앙에 모았다. 여백이 넓은 것은 다양한 배치의 잘림을 고려한 것이다.

| 배치 | 제출 이미지에서의 안전 영역 |
| --- | --- |
| 헤더 | x=1097–2743, y=493–1154 |
| 검색 결과 | x=418–1502, y=382.5–897.5 |

캐릭터, 검색 문구와 UI 카드를 위 영역 안에 두고 물결과 조명만 외부로 확장했다. 최종 PNG의 해상도, 8비트 RGB, 알파·투명 청크 없음, sRGB 프로파일을 검사했다. 문구·수치·구도를 눈으로 확인했다.

App Store Connect 업로드·기기별 Preview·심사는 수행하지 않았다. 업로드 후 실제 크롭과 작은 배치에서 UI 텍스트 가독성을 확인해야 한다. 검색 문구는 한국어이므로 다른 언어 배치에는 현지화가 필요하다. 앱 코드 변경이 없어 빌드·테스트·Graphify 갱신은 수행하지 않았다.

## Apple 공식 근거

- [에셋 모범 사례](https://developer.apple.com/kr/app-store/asset-best-practices/): 헤더는 명확한 한 가지 아이디어, 검색 결과는 앱의 목적과 경험을 강조한다.
- [크리에이티브 에셋 규격](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications): 헤더 3840×1646, 검색 결과 1920×1280–3840×2560, 이미지 알파·투명도 금지.
- [에셋 관리](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-your-app-store-assets): 배치·미리보기·제출 절차.
- [헤더 PSD](https://devimages-cdn.apple.com/design/resources/download/app-store/creative_assets-product_page_header_template-static.psd), [검색 결과 PSD](https://devimages-cdn.apple.com/design/resources/download/app-store/creative_assets-search_results_template-static.psd): 안전 영역 기준. 템플릿 파일은 이 묶음에 재배포하지 않는다.
