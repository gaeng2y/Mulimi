# Generation — Mulimi Water Glass v2

Mode: built-in `image_gen`, not the fallback CLI.

The master was generated without image references. It became the edit reference for three separate full-canvas layers. The generated 1254 × 1254 PNG canvases were resampled to the requested 1024 × 1024 with macOS `sips`, preserving alpha. Background, translucency, shadows, and glass highlights in the previews are rendered by Apple Icon Composer `ictool` from the `.icon` document.

## Master

```text
Use case: logo-brand.
Asset type: new premium hydration app icon SOURCE ARTWORK for Apple Icon Composer. Output one 1024x1024 square transparent RGBA PNG.
Primary request: design a fresh, exceptionally simple symbol of water filling a drinking glass for the Korean hydration app Mulimi. It must feel grown-up, calm, precise, modern and memorable; NOT a mascot and NOT a face.
This image is a flat MASTER of exactly THREE independently separable solid shapes:
1. GLASS BODY: an elegant wide drinking tumbler, front orthographic view, gently tapering sides, subtly rounded bottom corners. Solid ice-white color #E5F6FF, no outlines, no interior holes. Centered at x512. Its nearly horizontal softly curved top edge spans about x258..766 at y355. Slightly tapered sides lead to a broad rounded base at y860 between x325..699. This silhouette is one continuous flat opaque shape, behind the water. No handle, straw or feet. Do NOT draw an ellipse, rim line, shine, or glass lighting. Apple will supply the glass material.
2. WATER: one bold seafoam-turquoise fill shape #52DDCF INSIDE the glass, comfortably inset about 28px from each glass side and about 34px above its bottom. Its upper edge is ONE beautiful smooth asymmetric wave, running roughly from (310,583), dipping gently around (428,615), then rising into a broad crest around (637,542), ending at (714,558). Continue down following the cup taper and curve into a broad rounded base near y826. This is a filled silhouette, NOT an outline or a drawn wavy line. Leave a broad visible ice-white band of the glass above it. No foam, no bubbles, no highlights. Make this single water surface convey refreshment and filling up.
3. DROPLET: a single small upright azure droplet #4DCCF2 floating centered above the tumbler, with tip near (512,159), widest point around y256, rounded base near y307; about 112px wide. Leave a clear gap above the glass. Solid silhouette, no reflective spot.
The proportions are bold and substantial, with generous margins and highly legible at home-screen size. The cup must be the dominant visual, not the droplet. Sophisticated Apple-adjacent geometric clarity; no cute cartoon treatment.
CRITICAL: export only these three superimposed flat shapes in their specified positions on a genuinely transparent background. Entire outer canvas transparent. No rendered glass, no 3D shading, NO gradients, lighting, glows, shadows, texture, refraction, highlights, bevels, interior detail, text, letters, symbols, numbers, surrounding app tile, rounded-square canvas mask, labels, checkerboard pixels or watermark. The real Liquid Glass material and background will be applied separately in Icon Composer. All shape interiors fully opaque and uniform color. Clean smooth antialiased contours. Exactly one icon foreground composition, not a sheet.
```

## glass

```text
Use case: background-extraction. This is a technical separation of a layered app icon for Apple Icon Composer.
Keep the input's entire square canvas, composition coordinates and scale EXACTLY. Output one full-canvas 1024x1024 PNG with TRUE RGBA transparency. Do not crop, reposition, recenter surviving objects or make them larger.
Only the requested surviving shape should be visible. Its interior is solid uniform color and fully opaque. Its outline must be smooth, crisp and antialiased, with no ragged pixels or white/cyan fringes or stray specks outside it. No outline stroke, gradient, rendering, shine, glow, reflection, bevel, blur, texture, shadow, extra content, face, text, label, enclosing tile, fake checkerboard, white background, black background, watermark. All other pixels fully transparent.
Extract ONLY the light ice-white TUMBLER silhouette in the input. Keep its outside shape (wide gentle curved top, slightly tapering sides, generously rounded bottom corners) and exact full-canvas position. Completely REMOVE the turquoise water from inside the glass by filling that interior region with the same solid ice-white #E5F6FF as the glass. Completely remove the floating droplet above. The result must be ONE uniformly ice-white filled tumbler silhouette, with NO WATER, NO internal boundary, NO interior hole, and NO droplet. This is the backmost foreground layer.
```

## water

```text
Use case: background-extraction. This is a technical separation of a layered app icon for Apple Icon Composer.
Keep the input's entire square canvas, composition coordinates and scale EXACTLY. Output one full-canvas 1024x1024 PNG with TRUE RGBA transparency. Do not crop, reposition, recenter surviving objects or make them larger.
Only the requested surviving shape should be visible. Its interior is solid uniform color and fully opaque. Its outline must be smooth, crisp and antialiased, with no ragged pixels or white/cyan fringes or stray specks outside it. No outline stroke, gradient, rendering, shine, glow, reflection, bevel, blur, texture, shadow, extra content, face, text, label, enclosing tile, fake checkerboard, white background, black background, watermark. All other pixels fully transparent.
Extract ONLY the single seafoam-turquoise water-fill shape INSIDE the glass, flat solid #52DDCF. Preserve its beautiful wave-shaped top, tapering sides and rounded base EXACTLY as in the input at their same full-canvas coordinates. Remove the ENTIRE ice-white glass silhouette and the floating droplet completely, leaving transparency everywhere else. Exactly ONE filled turquoise shape with the gently sloping wave on top. No white glass border or remnants. This is the middle foreground layer.
```

## droplet

```text
Use case: background-extraction. This is a technical separation of a layered app icon for Apple Icon Composer.
Keep the input's entire square canvas, composition coordinates and scale EXACTLY. Output one full-canvas 1024x1024 PNG with TRUE RGBA transparency. Do not crop, reposition, recenter surviving objects or make them larger.
Only the requested surviving shape should be visible. Its interior is solid uniform color and fully opaque. Its outline must be smooth, crisp and antialiased, with no ragged pixels or white/cyan fringes or stray specks outside it. No outline stroke, gradient, rendering, shine, glow, reflection, bevel, blur, texture, shadow, extra content, face, text, label, enclosing tile, fake checkerboard, white background, black background, watermark. All other pixels fully transparent.
Extract ONLY the small floating azure water droplet ABOVE the glass, flat solid #4DCCF2, preserving its original size and high position on the full canvas. Remove the entire tumbler and the water inside it, making their former area fully transparent. Keep the large empty space BELOW the droplet. Do not center or enlarge the droplet. The result contains just ONE small blue teardrop near the TOP CENTER of the otherwise empty square canvas. This is the frontmost foreground layer.
```
