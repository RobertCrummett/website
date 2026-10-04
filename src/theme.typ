// Page chrome and shared helpers. Plain HTML with browser-default styling:
// an <h1> page title, <h2>/<h3> for = and == headings (Typst's default in
// HTML export), <hr> rules, and a single line of CSS.

// Who and where the site is: used in page titles, bylines and canonical URLs.
#let site-name = "Robert Nate Crummett"
#let site-url = "https://robertcrummett.com/"

// "Posted 10-2-26", with the date repeated in the yyyy-mm-dd form that search
// engines and other programs read. Post dates are written m-d-yy.
#let posted(date) = {
  let (m, d, y) = date.split("-").map(s => if s.len() < 2 { "0" + s } else { s })
  [Posted #html.elem("time", attrs: (datetime: "20" + y + "-" + m + "-" + d))[#date]]
}

// Browsers render a bare <mo>(</mo> as a stretchy fence: a taller glyph with
// extra side spacing, so f(x) looks like f ( x ). Typst marks every
// delimiter group `lr` as stretchy, so unwrap the groups that don't need it.
// Groups around tall content (fractions, roots, matrices) keep scaling.
#let tall-funcs = (math.frac, math.binom, math.sqrt, math.root, math.mat, math.vec, math.cases)
#let is-tall(c) = {
  if type(c) == content {
    if c.func() in tall-funcs { return true }
    c.fields().values().any(is-tall)
  } else if type(c) == array { c.any(is-tall) } else { false }
}
#let tight-delimiters(body) = {
  show math.lr: it => if is-tall(it.body) { it } else { html.elem("mrow", it.body) }
  body
}

// Horizontal rule, for use in posts: #hr
#let hr = html.elem("hr")

// A full page. `prefix` is the relative path back to the site root.
// `title` is the browser-tab and search-result headline, `description` the
// snippet shown under it, `heading` the <h1>, and `footer` a closing line
// set below a rule.
#let page(path, title, prefix: "", description: none, heading: none, footer: none, body) = document(path, title: [#title])[
  #html.elem("html", attrs: (lang: "en"))[
    #html.elem("head")[
      #html.elem("meta", attrs: (charset: "utf-8"))
      #html.elem("title")[#title]
      #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1.0"))
      #if description != none { html.elem("meta", attrs: (name: "description", content: description)) }
      // Each page answers at several addresses (with or without www and
      // .html); this names the one search engines should index.
      #html.elem("link", attrs: (rel: "canonical", href: site-url + (if path == "index.html" { "" } else { path })))
      #html.elem("link", attrs: (rel: "apple-touch-icon", sizes: "180x180", href: prefix + "icons/apple-touch-icon.png"))
      #html.elem("link", attrs: (rel: "icon", type: "image/png", sizes: "32x32", href: prefix + "icons/favicon-32x32.png"))
      #html.elem("link", attrs: (rel: "icon", type: "image/png", sizes: "16x16", href: prefix + "icons/favicon-16x16.png"))
      #html.elem("link", attrs: (rel: "manifest", href: prefix + "site.webmanifest"))
      // Long code lines scroll inside their block instead of widening the
      // whole page on a phone.
      #html.elem("style")[pre { overflow-x: auto; }]
    ]
    #html.elem("body")[
      #show: tight-delimiters
      #if heading != none [#html.elem("h1")[#heading]]
      #body
      #if footer != none [#html.elem("footer")[#hr #html.elem("p")[#footer]]]
    ]
  ]
]
