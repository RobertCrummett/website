// Workarounds for how browsers draw Typst's HTML math. Each one makes up for
// a gap in Typst's HTML export, in a browser, or on a platform, and may stop
// being needed when that is fixed upstream; theme.typ applies whichever are
// listed in `fixes` at the bottom of this file.
//
// A fix is one entry: a name, a note on what it is for and when it can go, a
// show rule for the page body (`rule`), and/or CSS for the page's <style>
// (`css`, given the relative path back to the site root). Deleting its entry
// removes all of it.
//
// To see the site without some of them, name them in NOFIX:
//   NOFIX=inline-primes,accents ./build.sh      (NOFIX=all for none)

// --- math-font --------------------------------------------------------------
// Browsers need a font made for math (one with an OpenType MATH table) to draw
// display-size integrals and sums, stretch brackets and place scripts.
// Android ships none, so Chrome there falls back to text fonts and gets all
// three wrong; other systems each ship a different one. The site brings New
// Computer Modern Math (Book), the font of Typst's PDFs, from fonts/.
// Keep as long as some platform has no math font, or to match the PDFs.
#let math-font = (
  name: "math-font",
  css: prefix => "@font-face { font-family: \"New Computer Modern Math\"; src: url(\"" + prefix + "fonts/NewCMMath-Book.woff\") format(\"woff\"); }\nmath { font-family: \"New Computer Modern Math\", math; }",
)

// --- math-size --------------------------------------------------------------
// In the PDFs a math letter stands as tall as the text around it. The math
// font's x is 0.44 of the font size tall, about as tall as Times on Windows
// and Mac, but Android's text font, Noto Serif, is 0.54, so there all math
// looked a fifth too small. Scale every font on the page to the x-height of
// the text font (font-size-adjust), which leaves the text itself alone;
// code keeps its own size.
// Keep while the text font is left to the browser.
#let math-size = (
  name: "math-size",
  css: prefix => "body { font-size-adjust: from-font; }\npre, code { font-size-adjust: none; }",
)

// --- tight-delimiters -------------------------------------------------------
// Typst marks every delimiter group `lr` as stretchy, and browsers then grow
// the bracket to the next size up and pad it, so f(x) looks like f ( x ).
// Unwrap the groups that don't need to grow. Groups around tall content
// (fractions, roots, matrices, braces, integrals, sums, and limits set below
// like lim_(n -> oo)) keep scaling. A group in brackets is handed over as
// its two brackets around an <mrow> of the rest: Typst writes a lone bracket
// as non-stretchy and spaces it the way it spaces the group (cos(θ), not
// cos (θ)). Bars get no such mark and stretch to whatever holds them, so
// they are kept inside an <mrow>: the rest of a bracket group, or the
// whole group when bars are its ends, as in |x|.
// Typst's PDF allows a bracket to fall a little short of its contents; drop
// this once its HTML export does the same.
#let tall-funcs = (math.frac, math.binom, math.sqrt, math.root, math.mat, math.vec, math.cases,
  math.underbrace, math.overbrace, math.underbracket, math.overbracket)
#let big-ops = "∫∬∭∮∯∰∱∲∳⨌⨍⨎⨏⨐⨑⨒⨓⨔⨕⨖⨗⨘⨙⨚⨛⨜∑∏∐⋀⋁⋂⋃⨀⨁⨂⨃⨄⨅⨆"
#let is-tall(c) = {
  if type(c) == content {
    if c.func() in tall-funcs { return true }
    if c.has("text") and type(c.text) == str and c.text.clusters().any(ch => ch in big-ops) { return true }
    if c.func() == math.attach and (c.has("t") or c.has("b")) and (c.base.func() == math.limits
      or (c.base.func() == math.op and c.base.at("limits", default: false))) { return true }
    c.fields().values().any(is-tall)
  } else if type(c) == array { c.any(is-tall) } else { false }
}
#let opening = ("(", "[", "{", "⟨", "⌊", "⌈", "⟦", "⦃", "⟮")
#let closing = (")", "]", "}", "⟩", "⌋", "⌉", "⟧", "⦄", "⟯")
#let tight-delimiters = (
  name: "tight-delimiters",
  rule: body => {
    show math.lr: it => {
      if is-tall(it.body) { return it }
      let parts = if it.body.has("children") { it.body.children } else { () }
      let bracketed = parts.len() >= 2 and parts.first().has("text") and parts.last().has("text") and parts.first().text in opening and parts.last().text in closing
      if not bracketed { return html.elem("mrow", it.body) }
      let inside = parts.slice(1, -1).join()
      parts.first() + (if inside != none { html.elem("mrow", inside) }) + parts.last()
    }
    body
  },
)

// --- accents ----------------------------------------------------------------
// Typst writes accents with combining characters. Most of those are drawn
// in the math font to the left of an empty box, to overprint the letter
// before them, and Chrome centers the empty box over the letter, so the mark
// lands to the left (w3c/mathml-core#311). Chrome also stacks the mark
// straight onto the letter, with no gap, and centers it on the letter's box,
// where Typst's PDF follows the font: a gap set by the accent, and a spot
// further right on italic letters, following the slant. So draw the spacing
// form of the accent, which the MathML spec lists as its equivalent (the
// vector arrow has none, so its own character is padded out to its ink),
// and let CSS lift it by the PDF's gap and move it to the letter's accent
// spot. (The mark must stay the <mover>'s own child: Chrome fits its box
// to the ink only there.) Measured against the PDF in Chrome; the
// numbers are New Computer Modern Math's, so this goes with math-font.
// Over a longer base Typst's stretched accent stays, save dots.
// Drop once Chrome places accents from the font's MATH table.
//
// Per combining accent: the mark to draw (none: keep it), its lift, and the
// mark's own accent spot right of its center; in em of the math font.
#let accent-marks = (
  "\u{300}": ("\u{60}", 0.088, -0.031),  // grave
  "\u{301}": ("\u{B4}", 0.088, 0.031),   // acute
  "\u{302}": (none, 0.059, 0),           // hat
  "\u{303}": (none, 0.100, 0.016),       // tilde
  "\u{304}": ("\u{AF}", 0.153, 0.001),   // macron, bar
  "\u{306}": ("\u{2D8}", 0.136, 0.001),  // breve
  "\u{307}": ("\u{2D9}", 0.115, -0.001), // dot
  "\u{308}": ("\u{A8}", 0.121, 0.003),   // dot.double
  "\u{30A}": ("\u{2DA}", 0.093, 0),      // circle
  "\u{30C}": ("\u{2C7}", 0.121, 0),      // caron
  "\u{20D7}": (none, 0.065, 0),          // arrow, padded out in the CSS
)
// Each italic letter's accent spot right of its center, in em, from the
// font's MATH TopAccentAttachment table (Typst sets capital Greek upright).
#let accent-shift = (
  "a": 0.022, "b": -0.011, "c": 0.101, "d": 0.182, "e": 0.067, "f": 0.219,
  "g": 0.077, "h": -0.033, "i": 0.074, "j": 0.153, "k": -0.011, "l": 0.055,
  "m": 0.017, "n": 0.025, "o": 0.072, "p": 0.092, "q": 0.058, "r": 0.021,
  "s": 0.061, "t": 0.044, "u": 0.019, "v": 0.051, "w": 0.047, "x": 0.043,
  "y": 0.059, "z": 0.103, "A": 0.175, "B": 0.115, "C": 0.139, "D": 0.088,
  "E": 0.136, "F": 0.182, "G": 0.093, "H": 0.127, "I": 0.127, "J": 0.209,
  "K": 0.120, "L": 0.019, "M": 0.140, "N": 0.141, "O": 0.114, "P": 0.156,
  "Q": 0.100, "R": 0.084, "S": 0.117, "T": 0.106, "U": 0.080, "V": 0.121,
  "W": 0.080, "X": 0.114, "Y": 0.108, "Z": 0.143, "α": 0.072, "β": 0.154,
  "γ": 0.130, "δ": 0.113, "ε": 0.051, "ζ": 0.094, "η": 0.100, "θ": 0.075,
  "ι": 0.007, "κ": 0.043, "λ": -0.053, "μ": 0.048, "ν": 0.050, "ξ": 0.066,
  "ο": 0.001, "π": 0.043, "ρ": 0.096, "ς": 0.079, "σ": 0.001, "τ": 0.051,
  "υ": 0.036, "φ": 0.028, "χ": 0.018, "ψ": 0.143, "ω": 0.034, "ϵ": 0.066,
  "ϑ": 0.116, "ϰ": 0.053, "ϕ": 0.125, "ϱ": 0.102, "ϖ": 0.039,
)
// Lengths in ex, which follow the math font's size where math-size scales
// it; the font's x-height is 0.431 em.
#let font-ex(v) = str(calc.round(v / 0.431, digits: 3)).replace("\u{2212}", "-") + "ex"
#let accents = (
  name: "accents",
  rule: body => {
    show math.accent: it => {
      if it.accent not in accent-marks { return it }
      let (mark, lift, own-spot) = accent-marks.at(it.accent)
      let letter = if it.base.has("text") and type(it.base.text) == str and it.base.text.clusters().len() == 1 { it.base.text }
      if letter == none and it.accent not in ("\u{307}", "\u{308}") { return it }
      let shift = if letter == none { 0 } else { accent-shift.at(letter, default: 0) - own-spot }
      // Otherwise mirror Typst's own <mover>: group a multi-part base, and
      // keep the class that stops a `dotless: false` base from losing its dot.
      let class = ("accent",)
      if it.accent == "\u{20D7}" { class.push("arrow") }
      if not it.at("dotless", default: true) { class.push("dotted") }
      let attrs = (accent: "true", class: class.join(" "), style: "--lift: " + font-ex(lift) + "; --shift: " + font-ex(shift))
      let base = if it.base.has("children") { html.elem("mrow", it.base) } else { it.base }
      html.elem("mover", attrs: attrs, base + symbol(if mark == none { it.accent } else { mark }))
    }
    body
  },
  // The arrow's ink runs from 0.472 to 0.056 em left of its empty box, so
  // 0.528 em of padding centers it.
  css: prefix => "mover.accent > :last-child { padding-bottom: var(--lift); position: relative; left: var(--shift); }\nmover.accent.arrow > :last-child { padding-left: " + font-ex(0.528) + "; }",
)

// --- inline-primes ----------------------------------------------------------
// Typst writes f' as a superscript, <msup><mi>f</mi><mo>′</mo></msup>, but a
// font's prime character is already drawn raised and small, like an
// apostrophe, so as a superscript it lands too high and too small (seen in
// Edge). Set the prime straight after its letter instead, as in plain text
// and in Typst's PDF. Any other scripts (f'^2, y'_n) attach to the pair;
// subscripts then sit after the prime, not under it.
// Drop once Typst writes primes this way, or browsers lower superscripted ones.
#let prime-chars = ("′", "″", "‴", "⁗")
#let is-primes(c) = type(c) == content and (c.func() == math.primes
  or (c.has("text") and c.text.clusters().all(ch => ch in prime-chars)))
#let inline-primes = (
  name: "inline-primes",
  rule: body => {
    show math.attach: it => {
      let key = ("tr", "t").find(k => is-primes(it.at(k, default: none)))
      if key == none { return it }
      let base = html.elem("mrow", it.base + it.at(key))
      let scripts = it.fields()
      let _ = scripts.remove("base")
      let _ = scripts.remove(key)
      if scripts.len() == 0 { base } else { math.attach(base, ..scripts) }
    }
    body
  },
)

// The fixes in use. Comment out or delete a line to pull one out.
#let fixes = (
  math-font,
  math-size,
  tight-delimiters,
  accents,
  inline-primes,
)

#let off = sys.inputs.at("nofix", default: "").split(",").map(str.trim).filter(s => s != "")
#for name in off {
  assert(name == "all" or fixes.any(f => f.name == name),
    message: "NOFIX names an unknown fix: " + name + " (known: " + fixes.map(f => f.name).join(", ") + ")")
}
#let active = fixes.filter(f => "all" not in off and f.name not in off)

// Every active fix's show rule, applied to a page body.
#let apply(body) = active.rev().fold(body, (b, f) => if "rule" in f { (f.rule)(b) } else { b })

// Every active fix's CSS, for a page whose root is `prefix` away.
#let css(prefix) = active.filter(f => "css" in f).map(f => (f.css)(prefix)).join("\n", default: "")
