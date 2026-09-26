# Generation and editing — Mulimi Drop v3

Source generation mode: built-in `image_gen` from v1. No fallback CLI and no new image-generation calls in v3.

Reused assets:
- v1 `01-body.png` → v3 `01-body.png`
- v1 `03-face.png` → v3 `02-face.png`

The two 1024 × 1024 RGBA PNGs are byte-for-byte copies. Cheeks and arms are not included. Facial scale and placement, color overrides, light/dark/mono annotations, and glass settings are stored in the editable Icon Composer document. Preview images are actual Apple `ictool` exports, not generated concept renders.

The body was subsequently changed to a native top-to-bottom linear gradient: light `#B3F4DE` → `#23B6C3`, dark `#CAF9E8` → `#4CC5C4`. The current saved facial settings, placement, automatic background, and solid grayscale mono annotation were preserved. No bitmap repainting or new image generation was needed.

## Original master prompt

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

## Original body layer prompt

```text
Use case: background-extraction. Asset: one registration-aligned foreground layer of a 1024x1024 Apple Icon Composer app icon.
The input is the exact composed master. Output the SAME SQUARE FULL CANVAS, retaining the same relative positions, dimensions and margins; do not crop to content, center the surviving element, zoom, shift, or reinterpret anything.
Output PNG, genuine transparent RGBA outside the specified surviving shapes, exactly 1024 x 1024 pixels. No fake checkerboard, black backdrop, white backdrop, frame, text, numbers, layout, or watermark. All surviving shape interiors must be flat, uniformly colored and fully opaque, clean anti-aliased silhouette boundaries. No texture, noise, gradients, baked-in shadows, highlights or lighting.
Extract ONLY the pale mint/aqua WATER-DROP BODY. Preserve its exact outside silhouette and position from the master. REMOVE both eyes, the mouth and both pink cheeks COMPLETELY by filling their old areas with the identical solid body color (#9EE6DF). The finished image must contain only a single featureless mint water-drop silhouette, with no face and no details. Everything outside the body is fully transparent. This is backmost foreground layer 01.
```

## Original face layer prompt

```text
Use case: background-extraction. Asset: one registration-aligned foreground layer of a 1024x1024 Apple Icon Composer app icon.
The input is the exact composed master. Output the SAME SQUARE FULL CANVAS, retaining the same relative positions, dimensions and margins; do not crop to content, center the surviving element, zoom, shift, or reinterpret anything.
Output PNG, genuine transparent RGBA outside the specified surviving shapes, exactly 1024 x 1024 pixels. No fake checkerboard, black backdrop, white backdrop, frame, text, numbers, layout, or watermark. All surviving shape interiors must be flat, uniformly colored and fully opaque, clean anti-aliased silhouette boundaries. No texture, noise, gradients, baked-in shadows, highlights or lighting.
Extract ONLY the TWO dark teal EYES and the single U-shaped SMILE from the supplied master. Preserve their exact silhouettes and full-canvas positions. Remove the entire water-drop body and both cheeks, making all those regions completely transparent. The finished image has exactly three solid dark teal (#174D57) features: two small vertical oval eyes and the curved smiling mouth. No body, no cheeks, no residual cyan color. Do not crop tightly or recenter. This is topmost foreground layer 03.
```
