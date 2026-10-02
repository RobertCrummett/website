// Page chrome and shared helpers. Reproduces the site's original plain-HTML
// look: <h3>/<h4> headings, <hr> rules, no stylesheet.

// Typst headings start at <h2> in HTML export; the site has always used
// <h3> for section titles and <h4> for subsections.
#let heading-levels(body) = {
  show heading: it => html.elem("h" + str(it.level + 2), it.body)
  body
}

// Horizontal rule, for use in posts: #hr
#let hr = html.elem("hr")

// A full page. `prefix` is the relative path back to the site root.
#let page(path, title, prefix: "", heading: none, body) = document(path, title: [#title])[
  #html.elem("html", attrs: (lang: "en"))[
    #html.elem("head")[
      #html.elem("meta", attrs: (charset: "utf-8"))
      #html.elem("title")[#title]
      #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1.0"))
      #html.elem("link", attrs: (rel: "apple-touch-icon", sizes: "180x180", href: prefix + "icons/apple-touch-icon.png"))
      #html.elem("link", attrs: (rel: "icon", type: "image/png", sizes: "32x32", href: prefix + "icons/favicon-32x32.png"))
      #html.elem("link", attrs: (rel: "icon", type: "image/png", sizes: "16x16", href: prefix + "icons/favicon-16x16.png"))
      #html.elem("link", attrs: (rel: "manifest", href: prefix + "site.webmanifest"))
    ]
    #html.elem("body")[
      #show: heading-levels
      #if heading != none [#html.elem("h3")[#heading]]
      #body
    ]
  ]
]
