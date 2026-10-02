// Whole-site entry point. Build with ./build.sh (see README).
#import "src/theme.typ": page
#import "src/posts.typ": posts

// Index: hand-written bio and links, then the generated list of thoughts.
#page("index.html", "RNC — Home")[
  #include "src/index.typ"

  = Thoughts
  #for p in posts.filter(p => p.at("listed", default: true)) {
    html.elem("p")[
      *#link(label(p.id))[#p.title]*#sym.space.quad Posted #p.date#html.elem("br")
      #p.summary
    ]
  }
]

// One page per post.
#for p in posts [
  #page("thoughts/" + p.id + ".html", "RNC — Writing", prefix: "../", heading: p.title)[
    #include("src/posts/" + p.id + ".typ")
  ] #label(p.id)
]
