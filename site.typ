// Whole-site entry point. Build with ./build.sh (see README).
#import "theme.typ": page, posted, site-name

// Posts, newest first. build.sh passes the ids of every posts/*.typ that
// begins with a `#let meta = (...)` block; here we read those blocks.
//   meta fields: title, date ("M-D-YY"), summary,
//                listed: false  -> publish the page but leave it off the index,
//                draft: true    -> do not publish at all.
#let ids = sys.inputs.at("posts", default: "").split(",").filter(id => id != "")

// "11-6-26" -> (26, 11, 6), so posts sort by year, then month, then day.
#let date-key(date) = {
  let (m, d, y) = date.split("-").map(int)
  (y, m, d)
}

#let posts = (ids
  .map(id => {
    import "posts/" + id + ".typ": meta
    (id: id, ..meta)
  })
  .filter(p => not p.at("draft", default: false))
  .sorted(key: p => date-key(p.date))
  .rev())

// Index: hand-written bio and links, then the generated list of thoughts.
#page("index.html", site-name, heading: site-name,
  description: "Robert Nate Crummett is a geophysics PhD student at the Colorado School of Mines. Notes on math, computing, and mineral exploration.")[
  #include "index.typ"

  = Thoughts
  #for p in posts.filter(p => p.at("listed", default: true)) {
    html.elem("p")[
      *#link(label(p.id))[#p.title]*#sym.space.quad #posted(p.date)#html.elem("br")
      #p.summary
    ]
  }
]

// One page per post, next to the index: posts/convex_functions.typ becomes
// convex_functions.html. Titled after the post, described by its summary, and
// closed with a byline and a link back to the index.
#for p in posts [
  #page(p.id + ".html", p.title + " — " + site-name,
    description: p.at("summary", default: none), heading: p.title,
    footer: [#site-name#if "date" in p [ · #posted(p.date)] · #link("index.html")[Home]])[
    #include("posts/" + p.id + ".typ")
  ] #label(p.id)
]
