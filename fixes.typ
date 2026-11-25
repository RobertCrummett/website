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
//   NOFIX=inline-primes,centered-dots ./build.sh      (NOFIX=all for none)

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

// --- tight-delimiters -------------------------------------------------------
// Typst marks every delimiter group `lr` as stretchy, and browsers then grow
// the bracket to the next size up and pad it, so f(x) looks like f ( x ).
// Unwrap the groups that don't need to grow. Groups around tall content
// (fractions, roots, matrices, braces, integrals, sums, and limits set below
// like lim_(n -> oo)) keep scaling.
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
#let tight-delimiters = (
  name: "tight-delimiters",
  rule: body => {
    show math.lr: it => if is-tall(it.body) { it } else { html.elem("mrow", it.body) }
    body
  },
)

// --- centered-dots ----------------------------------------------------------
// Typst writes dot() and dot.double() with combining dot characters, which
// Chrome draws to the left of the letter (w3c/mathml-core#311). The spacing
// forms, which the MathML spec lists as equivalents, sit centered. Other
// accents keep Typst's characters: the spacing arrow, for one, looks worse.
// Drop once Chrome centers combining accents, or Typst writes spacing ones.
#let spacing-dots = ("\u{307}": "\u{2D9}", "\u{308}": "\u{A8}")
#let centered-dots = (
  name: "centered-dots",
  rule: body => {
    show math.accent: it => if it.accent in spacing-dots {
      // Otherwise mirror Typst's own <mover>: group a multi-part base, and
      // keep the class that stops a `dotless: false` base from losing its dot.
      let attrs = (accent: "true")
      if not it.at("dotless", default: true) { attrs.insert("class", "dotted") }
      let base = if it.base.has("children") { html.elem("mrow", it.base) } else { it.base }
      html.elem("mover", attrs: attrs, base + [#symbol(spacing-dots.at(it.accent))])
    } else { it }
    body
  },
)

// --- accent-air -------------------------------------------------------------
// Accents (dots, hats; not stretchy arrows) get a little air above the
// letter, which Windows' math font, Cambria Math, leaves out.
// Tuned to Cambria Math, so it is not needed while math-font is on.
#let accent-air = (
  name: "accent-air",
  css: prefix => "mover[accent=\"true\" i] > mo:last-child:not([stretchy]) { padding-bottom: 0.1em; }",
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
  tight-delimiters,
  centered-dots,
  accent-air,
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
