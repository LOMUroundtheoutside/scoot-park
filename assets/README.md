# Scoot Park graphics

Made for Scoot Park by the Growth Spurt studio, 15 November 2026. Everything here is original. The image bases were
generated with Grok Imagine and then cut, tiled, graded and laid out by hand-written scripts. There are no real brands,
logos or copyrighted characters. The fonts in the artwork are Bungee and Barlow Condensed (SIL Open Font Licence).

All files were checked in three.js r128 with a scene set up like the game: Lambert ground, ACES tone mapping and
exposure 1.25.

## textures/ (seamless, 1024 x 1024 JPG unless noted)

Each tile is meant to cover about 2.5 m, so `texture.repeat.set(width / 2.5, depth / 2.5)`. They are light and low in
colour so `material.color` can tint them. With white they show the natural colour listed.

| File | What | Natural colour | Size |
|---|---|---|---|
| concrete.jpg | Smooth park concrete, faint trowel marks, very light stains | #a3a3a3 grey | 220 KB |
| plywood.jpg | Skatelite / ply ramp surface, 4 planks running along V, countersunk screw rows by each seam | #ae9a81 warm tan | 93 KB |
| dirt.jpg | Packed dirt for the jumps | #ac9b87 light brown | 371 KB |
| asphalt.jpg | Fine asphalt for the car park and roads | #757573 grey | 369 KB |
| grass.jpg | Short mown grass | #7ea148 green | 372 KB |
| pool-tile-band.jpg | Blue pool tile band, 1024 x 256, two rows of tiles, tiles left to right | pool blue | 38 KB |

The tile band has 8 tiles across, so at 30 cm tiles one repeat is 2.4 m:
`band.wrapS = THREE.RepeatWrapping; band.repeat.set(bandLength / 2.4, 1);` (leave wrapT clamped).

For every colour texture in r128: `tex.encoding = THREE.sRGBEncoding` (with `renderer.outputEncoding = THREE.sRGBEncoding`),
`tex.wrapS = tex.wrapT = THREE.RepeatWrapping`, and `tex.anisotropy = renderer.capabilities.getMaxAnisotropy()` keeps the
ground sharp at low angles.

## grip/ (1024 x 256 PNG, under 250 KB each)

Grip-tape tops, gritty, with the brand name along the long axis (U runs nose to tail). The nose is on the right.

| File | Brand |
|---|---|
| grip-pen-pen-v.png | Pen Pen V: black and gold, pro series, gold V badge |
| grip-kowhai-pro.png | Kowhai Pro: yellow, kōwhai flowers on green end panels |
| grip-tui-street.png | Tui Street: blue, a singing tūī, street stripes |
| grip-fantail-fx.png | Fantail FX: purple to pink, a fantail (pīwakawaka) badge |
| grip-rimu-ridge.png | Rimu Ridge: rimu timber with an orange mountain ridge |
| grip-scoot-park-starter.png | Scoot Park Starter: teal, the Scoot Park logo, checker ends |

If the deck is a BoxGeometry, put the grip on the top face only (material index 2) and a plain dark material on the
other faces. If the art comes out sideways, set `tex.center.set(0.5, 0.5); tex.rotation = Math.PI / 2;`.

Brand names are spelt as in the brief. The full Māori spellings are Kōwhai and Tūī: happy to redo those two with
macrons if you'd like.

## ui/

| File | What |
|---|---|
| scoot-park-logo.png | Title logo, 1600 x 600 transparent PNG, 142 KB. Stacked SCOOT / PARK in grip yellow with a hot pink-red block shadow and ink outline; the two O's are scooter wheels with teal hubs; speed streaks behind. |
| start-screen-key-art.jpg | Start screen, 1920 x 1080 JPG, 276 KB. A rider mid-tailwhip above a concrete bowl with a blue tile band at golden hour, pōhutukawa and a volcanic hill behind. The left 40% is the dark shadowed bowl wall for the menu. |

The logo sits nicely on the key art at about 620 px wide, top left (x 90, y 120 at 1920 x 1080).

## sky/

| File | What |
|---|---|
| sky-equirect.jpg | Equirectangular panorama, 2048 x 1024, 115 KB. Sunny afternoon, scattered clouds, soft haze at the horizon, a smooth gradient overhead. Nothing below the horizon except pale haze. Wraps seamlessly. |

The simplest way in r128, which also keeps it out of the tone mapping and fog:

```js
const sky = new THREE.TextureLoader().load('assets/sky/sky-equirect.jpg');
sky.encoding = THREE.sRGBEncoding;
const dome = new THREE.Mesh(
  new THREE.SphereGeometry(900, 48, 24),
  new THREE.MeshBasicMaterial({ map: sky, side: THREE.BackSide, fog: false, depthWrite: false, toneMapped: false })
);
scene.add(dome);   // keep the radius inside camera.far; move it with the camera if the world is big
```

## props/ (GLB, Y-up, metres, origin at the bottom centre, no Draco, vertex colours)

| File | Triangles | Size | Width x height x depth |
|---|---|---|---|
| park_bench.glb | 708 | 59 KB | 1.80 x 0.89 x 0.53 m |
| picnic_table.glb | 880 | 74 KB | 1.80 x 0.78 x 1.52 m |
| rubbish_bin.glb | 628 | 36 KB | 0.64 x 0.98 x 0.64 m |
| street_lamp.glb | 440 | 21 KB | 1.94 x 6.07 x 0.48 m |
| pohutukawa_tree.glb | 2,588 | 270 KB | 7.88 x 5.95 x 7.65 m |
| cabbage_tree.glb | 1,972 | 163 KB | 3.08 x 5.37 x 2.93 m |
| hatchback_car.glb | 2,114 | 141 KB | 1.92 x 1.52 x 4.07 m (body 1.75 m wide, mirrors add the rest) |
| scoot_park_sign.glb | 2,480 | 169 KB | 3.00 x 2.33 x 0.29 m |

Notes:
- Every prop faces +Z: the car's nose, the bench seat and the sign's lettering.
- The car's wheels are separate child nodes (wheel_FL, wheel_FR, wheel_RL, wheel_RR) with their origin on the axle, so
  they can spin about local X.
- The street lamp's origin is at the base of the pole, and its arm reaches 1.7 m along +X.
- The cabbage tree leaves use a double-sided material so they don't vanish from behind.
- The sign says SCOOT PARK on both faces.

Load them with `THREE.GLTFLoader` (examples/js/loaders/GLTFLoader.js for r128). Colours are vertex colours, so they come
through without any textures. Turn on `castShadow` / `receiveShadow` on their meshes after loading if the game uses
shadows.
