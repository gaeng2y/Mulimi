# Generation prompts

Mode: built-in `image_gen` (no fallback CLI).

Brand reference: `Project/App/Resources/Assets.xcassets/AppIcon.appiconset/app icon.png`.

The generated foreground master was used as the edit reference for all three layers. Each layer was generated separately; its full canvas was resampled from 1254 × 1254 to the requested 1024 × 1024 with macOS `sips`, preserving alpha. No artistic repainting, manual pixel separation, or background removal was performed outside image generation. Background and glass effects in the previews are rendered by Apple's Icon Composer `ictool`, not image generation.

## Master

```text
Use case: logo-brand.
Asset type: layered app-icon source artwork for Apple Icon Composer, 1024 x 1024 PNG.
Primary request: redesign the supplied Mulimi hydration-app mascot into a polished, extremely simple, lovable smiling water-drop app icon. The supplied image is a BRAND/CHARACTER reference; make a new refined rendering, preserving the recognizable smiling water-drop identity, rosy cheeks, and calming teal palette.
Output a single composed FOREGROUND MASTER on a genuinely transparent RGBA background, exactly 1024x1024, NOT a checkerboard drawn into the pixels.
Design: one bold solid pale-aqua water-drop silhouette, fill #9EE6DF. Rounded apex at about (512,156); shoulders flow into the widest part between x218 and x806 at y620; smooth generous rounded bottom reaches y872. Width about 590 px, height about 716px, optically centered. Symmetric, gently inflated, distinctive rounded water-drop silhouette, clean precise vector-like anti-aliased edges.
Face: two simple small vertical dark-deep-teal pill eyes (#174D57), centered at (410,559) and (614,559), about 35px wide and 49px high, a small relaxed U-shaped smiling mouth centered at x512 around y624 with 17px round-ended stroke. Two flat warm-coral/pink oval cheeks (#FFB5BE), centers around (351,620) and (673,620), each about 84x43px. All features must be comfortably inside the drop. No eyebrows, no nose, no text, no hands or arms.
This is intentionally FLAT source artwork. Every shape is fully opaque and uniformly colored. NO gradients, specular highlights, gleams, reflections, baked-in lighting, shadows, blur, glass refraction, texture, outlines around the droplet, background, enclosing app tile, rounded-square border, labels, or watermark. Native Liquid Glass will be applied later in Icon Composer.
Leave the entire canvas around the mascot truly transparent. Make the outline beautifully balanced and the face highly legible at a small icon size. No layout sheet, exactly one centered mascot.
```

## body

```text
Use case: background-extraction. Asset: one registration-aligned foreground layer of a 1024x1024 Apple Icon Composer app icon.
The input is the exact composed master. Output the SAME SQUARE FULL CANVAS, retaining the same relative positions, dimensions and margins; do not crop to content, center the surviving element, zoom, shift, or reinterpret anything.
Output PNG, genuine transparent RGBA outside the specified surviving shapes, exactly 1024 x 1024 pixels. No fake checkerboard, black backdrop, white backdrop, frame, text, numbers, layout, or watermark. All surviving shape interiors must be flat, uniformly colored and fully opaque, clean anti-aliased silhouette boundaries. No texture, noise, gradients, baked-in shadows, highlights or lighting.
Extract ONLY the pale mint/aqua WATER-DROP BODY. Preserve its exact outside silhouette and position from the master. REMOVE both eyes, the mouth and both pink cheeks COMPLETELY by filling their old areas with the identical solid body color (#9EE6DF). The finished image must contain only a single featureless mint water-drop silhouette, with no face and no details. Everything outside the body is fully transparent. This is backmost foreground layer 01.
```

## cheeks

```text
Use case: background-extraction. Asset: one registration-aligned foreground layer of a 1024x1024 Apple Icon Composer app icon.
The input is the exact composed master. Output the SAME SQUARE FULL CANVAS, retaining the same relative positions, dimensions and margins; do not crop to content, center the surviving element, zoom, shift, or reinterpret anything.
Output PNG, genuine transparent RGBA outside the specified surviving shapes, exactly 1024 x 1024 pixels. No fake checkerboard, black backdrop, white backdrop, frame, text, numbers, layout, or watermark. All surviving shape interiors must be flat, uniformly colored and fully opaque, clean anti-aliased silhouette boundaries. No texture, noise, gradients, baked-in shadows, highlights or lighting.
Extract ONLY the TWO pink/coral oval CHEEKS from the supplied master. Preserve both exact shape silhouettes and locations in the full square canvas. Remove the entire teal water-drop body, both eyes, and mouth: those areas must be FULLY TRANSPARENT. The finished image contains exactly two flat solid coral-pink oval shapes (#FFB5BE), left and right, floating in the same positions occupied by the cheeks of the reference. Absolutely no ghost of the body silhouette. Do NOT center the two ovals vertically or enlarge them. This is foreground layer 02.
```

## face

```text
Use case: background-extraction. Asset: one registration-aligned foreground layer of a 1024x1024 Apple Icon Composer app icon.
The input is the exact composed master. Output the SAME SQUARE FULL CANVAS, retaining the same relative positions, dimensions and margins; do not crop to content, center the surviving element, zoom, shift, or reinterpret anything.
Output PNG, genuine transparent RGBA outside the specified surviving shapes, exactly 1024 x 1024 pixels. No fake checkerboard, black backdrop, white backdrop, frame, text, numbers, layout, or watermark. All surviving shape interiors must be flat, uniformly colored and fully opaque, clean anti-aliased silhouette boundaries. No texture, noise, gradients, baked-in shadows, highlights or lighting.
Extract ONLY the TWO dark teal EYES and the single U-shaped SMILE from the supplied master. Preserve their exact silhouettes and full-canvas positions. Remove the entire water-drop body and both cheeks, making all those regions completely transparent. The finished image has exactly three solid dark teal (#174D57) features: two small vertical oval eyes and the curved smiling mouth. No body, no cheeks, no residual cyan color. Do not crop tightly or recenter. This is topmost foreground layer 03.
```
