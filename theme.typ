// Page chrome and shared helpers. Plain HTML with browser-default styling:
// an <h1> page title, <h2>/<h3> for = and == headings (Typst's default in
// HTML export), <hr> rules, and a few lines of CSS. Workarounds for how
// browsers draw the math live apart, in fixes.typ.
#import "fixes.typ"

// Who and where the site is: used in page titles, bylines and canonical URLs.
#let site-name = "Robert Nate Crummett"
#let site-url = "https://robertcrummett.com/"

// "Posted 10-2-26", with the date repeated in the yyyy-mm-dd form that search
// engines and other programs read. Post dates are written m-d-yy.
#let posted(date) = {
  let (m, d, y) = date.split("-").map(s => if s.len() < 2 { "0" + s } else { s })
  [Posted #html.elem("time", attrs: (datetime: "20" + y + "-" + m + "-" + d))[#date]]
}

// Horizontal rule, for use in posts: #hr. A <hr> on the site, and a plain line
// when a post is compiled on its own to PDF for previewing.
#let hr = context if target() == "html" { html.elem("hr") } else { line(length: 100%) }

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
      // Long code lines and wide display equations scroll inside their block
      // instead of widening the whole page on a phone. A scrolling box clips
      // whatever pokes out of it, and fractions and sums reach a few pixels
      // past the equation's box, so give them room without moving the
      // equation.
      #html.elem("style", "pre, div.equation { overflow-x: auto; }\ndiv.equation { padding: 0.5em 0; margin: -0.5em 0; }")
      #let fix-css = fixes.css(prefix)
      #if fix-css != "" { html.elem("style", fix-css) }
    ]
    #html.elem("body")[
      #show: fixes.apply
      // Safari sizes <math> to its content and ignores overflow on it, so
      // each display equation gets a <div> to scroll in.
      #show math.equation.where(block: true): it => html.elem("div", attrs: (class: "equation"), it)
      #if heading != none [#html.elem("h1")[#heading]]
      #body
      #if footer != none [#html.elem("footer")[#hr #html.elem("p")[#footer]]]
    ]
  ]
]
