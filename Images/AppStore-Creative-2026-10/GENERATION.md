# 생성 프롬프트

제작일: 2026-10-27. 내장 `image_gen` 도구를 사용했다. CLI/API 대체 경로는 사용하지 않았다.

최종 생성 원본은 `sources/`에 보존했다. 제출용 크기와 sRGB 프로파일은 macOS `sips`로 정규화했다. 이미지 편집·구도 변경은 모두 내장 이미지 생성 도구로 수행했다.

## 헤더 최초 생성

참조: `../AppIcon-339-v3/preview-light.png`

```text
Use case: ads-marketing.
Asset type: Apple App Store PRODUCT PAGE HEADER for Mulimi, a calm water-drinking tracker. Create one premium finished wide raster artwork, landscape approximately 21:9, target 3840 x 1646 pixels (3840 x 1648 is acceptable as source).
Input image 1 is ONLY the exact brand character reference, not a layout to copy. Preserve this mascot's distinctive rounded water-drop silhouette, two small dark vertical oval eyes, single small relaxed U-shaped smile, mint-to-teal color. No cheeks, arms, legs, accessories, or app-icon rounded-square tile.
Scene: a serene pale mint water surface under soft morning studio light, with a warm ivory #EBEAE6 atmosphere. A single small sculptural translucent mint-glass smiling water drop rests lightly on the water at the exact horizontal center. Soft broad concentric ripples expand around its base, subtly refracting aqua light. Sophisticated tactile 3D editorial advertising artwork, carefully controlled translucency, clear silhouette, friendly understated expression, beautiful gentle caustics, immaculate soft material rendering, calm and inviting, no clutter.
CRITICAL APPLE SAFE AREA: at a 3840 x 1646 canvas ALL of the main mascot including apex, face and bottom must fit x=1650..2190 and y=520..1120. It is intentionally only 600px tall, about 36% of full canvas height. Keep the face near y=900. The surrounding image is generous atmospheric negative space; decorative shallow ripples may expand across the image. Outer 28% left/right and outer 30% top/bottom must contain background and nonessential water patterns only. Do not make the mascot a giant closeup. Do not add extra droplets or objects. Render a soft low ellipse reflection, not a second face.
Color: body top #B3F4DE fading to #23B6C3 at base, deep teal-black face. Background off-white and very pale seafoam, soft turquoise water accents. Visually cohesive with the supplied app icon.
No text, letters, labels, borders, logos, badges, UI, device, frame, watermark, collage, safe-area guides. Completely opaque background. Fill the entire rectangular image edge to edge.
```

## 헤더 안전 영역 보정

참조: 위 최초 생성 이미지.

```text
Use case: precise-object-edit. Asset: Mulimi App Store header. Edit the supplied wide artwork with only one compositional correction: reduce the entire central smiling glass water-drop character to 80% of its current size, keeping the visual center of the drop at exactly 50% canvas width and 50% canvas height. The top of the character must be at 33% canvas height, and its base at 67% canvas height, leaving both a top 33% and bottom 33% band free of the character. Fit the character fully inside that central band. Preserve the exact mint-teal glass material, small black oval eyes and tiny U smile, no limbs or cheeks. Adjust the contact ripples/reflection to the smaller character. Keep the same warm ivory and pale aqua water setting, soft light, broad ripples, gentle caustics, and generous empty space. No text, logos, badges, UI or guides. Fully opaque. Wide 21:9 aspect ratio, export at the highest available resolution, intended production size 3840x1646.
```

## 검색 결과 최초 생성

참조 1: `../../Docs/product-specs/assets/issue-350/recovered.png`. 참조 2: 최초 생성 헤더의 색·조명.

```text
Use case: ads-marketing.
Asset: Apple App Store SEARCH RESULTS creative image for Mulimi hydration tracker, 3:2 landscape. Intended production size 3840x2560; render at the highest available resolution. This is one polished advertisement, not a phone screenshot, not a contact sheet.
Input image 1: actual app screenshot; use ONLY its lower portion from y=700 to bottom (original1170x2532). This source crop shows a white water-drop silhouette partly filled with turquoise water, the exact readings "2잔 500ml" and "목표: 2,000ml", and the turquoise "마시기" button with the small ellipsis button. Faithfully reproduce that existing crop as an inset flat panel. EXCLUDE source top navigation title, status bar and top next-action card. Do not redesign the actual crop, add UI or change its words or quantities.
Input image 2: STYLE reference for warm ivory/seafoam palette, soft light and faint water caustics. Do not copy or include its smiling character.
Scene: exceptionally clean warm ivory #EBEAE6 background, a very pale mint glow on the right and delicate out-of-focus aqua water caustics along the bottom corners. A restrained premium editorial composition. No busy sparkles.
CRITICAL COMPOSITION / APPLE SAFE AREA: all headline letters and the entire app crop panel MUST fit inside x=836..3004, y=765..1795 on the intended3840x2560 canvas. Outer 30% at top and bottom remain empty atmospheric background only. Center the entire main composition as a compact horizontal group. LEFT headline at x=950..2060 and y=1090..1470, very large bold clean modern Korean sans-serif, dark deep teal #123F47, exact two lines:
"물 마시고,"
"한 번에 기록."
No other marketing copy. RIGHT place the flat cropped actual UI panel at approximately x=2240..2840,y=815..1755, scaled proportionally as a single intact crop (600px wide,940px high). Soft tiny shadow with subtly rounded corners to separate the screenshot crop from the background. No smartphone hardware, no perspective tilt, no new UI, no fingers. The app panel is clearly an excerpt of the functional UI. Preserve the original visual order: partially filled droplet, "2잔 500ml", gray goal, turquoise "마시기", ellipsis. Keep "2잔" and "500ml" as source. The headline and app crop are optically balanced within the CENTRAL safe region; do NOT move them toward the outer canvas edges or fill full canvas height.
Do not add a logo, app icon, face to the UI droplet, badges, ticks, buttons outside the actual source crop, device frame, price, URL, watermark, captions, or safe-area outline. One cohesive restrained visual, sharp typography, opaque RGB background.
```

## 검색 결과 안전 영역 보정

참조: 위 최초 생성 검색 결과 이미지.

```text
Use case: precise-object-edit. Edit this Mulimi search-results marketing artwork. Keep the existing artwork style, words, colors and faithful UI detail EXACTLY. Make only this correction: scale DOWN the entire foreground group (both the Korean headline and the UI card together, preserving their mutual layout) to 65% of its current width and height, then center that whole group at the exact image center. The resulting overall foreground bounding box should be x=28%..73% of canvas width and y=31%..69% of canvas height. The TOP of the UI card must be at 31% canvas height and the BOTTOM of that card at 69% height. All of the headline stays inside that same box. This means much MORE blank background around the compact center group, not zooming in. Extend the existing softly lit ivory/seafoam background and water caustics around it. Preserve every letter of the exact headline "물 마시고," and "한 번에 기록." on two lines. Preserve the UI's exact water-drop shape/25%-filled aqua water, "2잔 500ml", "목표: 2,000ml", "마시기", and ellipsis button. Preserve an upright flat card, no perspective, no phone, no extra badges/labels. Do not change font, add new text, or add a character. Maintain 3:2 landscape aspect ratio, highest possible resolution, opaque background, no watermarks or safe-area guides.
```
