# Iosevka

Coders' typeface, built from code.

![Weights Preview](https://raw.githubusercontent.com/be5invis/Iosevka/master/images/weights.png)

## Installation

Quit your editor/program. Unzip and open the folder.

* **[OS X](http://support.apple.com/kb/HT2509)**
* **[Windows](https://www.microsoft.com/en-us/Typography/TrueTypeInstall.aspx)**
* **Linux** : Copy the .ttf files to your fonts-directory → Run `sudo fc-cache`.
  - Arch Linux users can install the font from the AUR [here](https://aur.archlinux.org/packages/ttf-iosevka) using an AUR wrapper or by doing it manually. [All variants](https://aur.archlinux.org/packages/?O=0&SeB=nd&K=ttf-iosevka&SB=n&SO=a&PP=50&do_Search=Go).

## Building from source

To build Iosevka you should:

1. Ensure that [`node`](http://nodejs.org) (≥ 5.0), [`FontForge`](http://fontforge.org) (with Python scripting support, ≥ Aug. 2015 release), [`ttfautohint`](http://www.freetype.org/ttfautohint/), [`ttx`](http://www.adobe.com/cn/devnet/opentype/afdko.html) and `make` are runnable in your terminal.
   - Windows users may need to install MinGW and make \*nix	 utilities accessible (`mkdir.exe`, `cp.exe`, `cat.exe` and `rm.exe`, in particular) from Command Prompt. Utilities provided by [Git for Windows](https://git-for-windows.github.io/) works fine.
2. Install necessary libs by `npm install`.
3. `make`.

You will find TTFs in the `dist/` directory.

## Build your own style

![Styles Preview](https://raw.githubusercontent.com/be5invis/Iosevka/master/images/variants.png)

Iosevka comes with several visual styles, however they are inactive using the default build. To build these variants you should use style variables in the `make` procedure:

* `STYLE_COMMON` for both uprights and italics,
* `STYLE_UPRIGHT` for upright and oblique, and
* `STYLE_ITALICS` for itaics only.

You can add arbitary styles for these variables, for example, `make STYLE_UPRIGHT='v-l-zshaped v-i-zshaped'` to create a variant with Z-shaped letter `l` and `i` for uprights.

The current avaliable styles are:

* Styles for letter `l`:
  * `v-l-hooky` : Hooky `l`
  * `v-l-zshaped` : Z-shaped `l`
  * `v-l-serifed` : Serifed `l` (default for upright and oblique)
  * `v-l-italic` : Italic `l` (default for italic)
* Styles for letter `i`:
  * `v-i-hooky` : Hooky `i`
  * `v-i-zshaped` : Z-shaped `i`
  * `v-i-serifed` : Serifed `i` (default for upright and oblique)
  * `v-i-italic` : Italic `i` (default for italic)
* Styles for letter `a`:
  * `v-a-doublestorey` : Double-storey `a` (default for upright and oblique)
  * `v-a-singlestorey` : Single-storey `a` (default for italic)
* Styles for letter `g`:
  * `v-g-doublestorey` : Double-storey `g` (default)
  * `v-g-singlestorey` : Single-storey `g`
* Styles for letter `0`:
  * `v-zero-slashed` : Slashed Zero `0` (default)
  * `v-zero-dotted` : Dotted Zero `0`
  * `v-zero-unslashed` : O-like `0`
* Styles for ASCII tilde (`~`) and asterisk (`*`):
  * `v-tilde-high` : Higher tilde `~` (default)
  * `v-tilde-low` : Lower tilde `~`
  * `v-asterisk-high` : Higher asterisk `*` (default)
  * `v-asterisk-low` : Lower asterisk `*`

## Release Notes

* **1.7.3**
  - Optimize the shapes of three-like glyphs, including `3`, `ε` and `з`.
* **1.7.2**
  - Entallen upright letter `f`.
  - Reverted shape of `π` to the 1.3.x.
  - Added `Ѧ` and `Ѫ`.
* **1.7.1**
  - Fixed incorrect outline of braced glyphs under heavy weights.
* **1.7.0**
  - Added more tie marks and combining marks.
  - Fixed the incorrect weights created by `[turned]` and `[composite]`.
* **1.6.3**
  - Fixed the missing vertical stroke of `¬`.
  - Fixed the dot position of `ĳ`.
  - Added several combining marks : `o͐`, `o͚`, etc.
  - Redesigned the tilde `~` for better consistency.
* **1.6.2**
  - Added braced letters and numbers, like `⑴` and `⒜`.
  - Added several Greek letterforms, including `Ϸ` and `ϸ`.
  - Rebuild the script into [sketch]es.
* **1.6.1**
  - Added `ꭤ` U+AB64, `Ɑ` U+2C6D, `Ɒ` U+2C70, `ꬰ` U+AB30, etc.
* **1.6.0**
  - Fixed the broken `Æ` at thin weights.
  - Increased the length of the bottom serif in `T`.
  - Made `Ђ` and `Ћ` wider to balance Cyrillic letters
* **1.5.5**
  - Adjusted the outlines of `f`, `2` and `&`, as well as full-width symbol `~`.
* **1.5.4**
  - Fixed the distortion of letter `s` under several situations, for example, full-width.
* **1.5.3**
  - Fixed the slanted bottom tip of `y` in Slab oblique.
* **1.5.2**
  - Told OS X not to increase line height for bold weights.
  - Pushed the `i` and `l` undef hooky variants rightward slightly.
* **1.5.1**
  - Added `cv20` and `cv21` for underscore variants (https://github.com/be5invis/Iosevka/pull/44)
  - Reorganized `ss01`, `ss02` and `ss03`. The less-frequent style (`cv04` and `cv08`) is moved to `ss03`, while `ss01` is for hooky shapes.
* **1.5.0**
  - The new "fairizer" now replaces FontForge's outline simplification. It will create smooth and fair outline curves now.
  - Introduced centered asterisk (`*`) and tilde (`~`). They can be enabled by OpenType features `ss10`.
  - `cv**` and `ss**` features introduced in 1.4.0 now supports accented letters.
* **1.4.3**
  - Added the "oblique" variant.
  - Corrected the stroke width in italic variants. It will reduce the file size of italics and improve its outline quality.
* **1.4.2**
  - The shape of lowercase `y` is improved. Its slab version is redesigned.
  - Rebalanced italic `l` and `i`.
  - Enwiden `/t`.
* **1.4.1**
  - Fixed the incorrectly-shaped `/nine` in the thin variant.
  - Fixed the broken serif of `/yhooktop`.
* **1.4.0**
  - Added five new weights: *thin*, *extralight*, *light*, *medium* and *heavy*.
  - Shape optimizations for MANY letters, including `/s`, `/r`, `/a`, `/beta`, `/cyryeri` and their derived characters.
* **1.3.0**
  - Shape optimizations: `/f`, `/r`, `/a`, `/s`, `/epsilon`, `/cyrze` and their derived glyphs.
  - Narrowed slab-serif variants.
  - Added `/overlineTieAbove`, `/underlineTieBelow` and `/turnTieAbove`.
* **1.2.0**
  - Glyphs added: `/cyrGhayn`, `/cyrghayn`, `/cyrChevbar`, `/cyrchevbar`, `/turnoe`, `/voicedlaryngenalspirant`, `/oupperhalf`, `/olowerhalf` and their derived glyphs.
  - Shape optimization: `/eight`, `/propto`, `/J`, `/j`, `/epsilon`, `/cyrze`, `/taillessphi`, `/smcpPsi` and their derived glyphs.
  - Added the missing marks of `/longs`.
  - Introduced a new SVG-based outline exporting mechanism. Now I am finally free from the rounding nightmare.
* **1.1.2**
  - Improved the balancing of `/longs`, `/f` and `/eszet`.
  - The strokes of `/A`, `/V` and `/v` in Iosevka Slab is straightened.
* **1.1.1**
  - Added the missing serifs for `/cyrdzhe`.
  - Balanced `/pi` in bold weights.
  - Moved the descender lines of Cyrillic letters rightward a little in italics.
* **1.1.0**
  - Enwiden the boldfaces. This will improve the consistency between regular and bold weights.
  - The curves in `/xi` are optimized.
* **1.0.2**
  - Fixed the incorrect `/yhooktop`.
  - The digaphs defined in Unicode is now single-width.
  - Reorganized subfamilies: Now the default Iosevka does not contain full-width glyphs any more.