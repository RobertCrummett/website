// Whole-site entry point. Build with ./build.sh (see README).
#import "src/theme.typ": page, posted, site-name
#import "src/posts.typ": posts

// Index: hand-written bio and links, then the generated list of thoughts.
#page("index.html", site-name, heading: site-name,
  description: "Robert Nate Crummett is a geophysics PhD student at the Colorado School of Mines. Notes on math, computing, and mineral exploration.")[
  #include "src/index.typ"

  = Thoughts
  #for p in posts.filter(p => p.at("listed", default: true)) {
    html.elem("p")[
      *#link(label(p.id))[#p.title]*#sym.space.quad #posted(p.date)#html.elem("br")
      #p.summary
    ]
  }
]

// One page per post: titled after the post, described by its summary, and
// closed with a byline and a link back to the index.
#for p in posts [
  #page("thoughts/" + p.id + ".html", p.title + " — " + site-name, prefix: "../",
    description: p.at("summary", default: none), heading: p.title,
    footer: [#site-name#if "date" in p [ · #posted(p.date)] · #link("../index.html")[Home]])[
    #include("src/posts/" + p.id + ".typ")
  ] #label(p.id)
]
