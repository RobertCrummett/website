#let meta = (
  title: "Translating a Soviet Gamma-Ray Spectrometry Monograph",
  date: "11-15-26",
  summary: "An English translation of Kogan, Nazarov and Fridman (1991), what the work taught me, and the authors' preface.",
)

#import "../theme.typ": hr

In 1991 R. M. Kogan, I. M. Nazarov and Sh. D. Fridman published the third
edition of _Основы гамма-спектрометрии природных сред_ (_Fundamentals of
Gamma-Ray Spectrometry of Natural Media_). Energoatomizdat printed 800 copies.
The first edition (1969) was translated into English in 1971 by the Israel
Program for Scientific Translations; the third edition, rewritten around
airborne surveys, the gamma field of the surface atmosphere and the Chernobyl
contamination, was not, as far as I can find. I have now completed an English
translation of the third edition.

The translation is not published. The rights to the original could not be
traced, so it circulates privately, for study.

= Translation Lessons

The original source file is a bitonal DjVu file that renders at 300 DPI. Because
the scan is a black and white image, thin features get aliased, making
reconstruction extremely challenging. Although it is obvious to a human where
contours or bounding boxes ought to continue, there is no numerical signature
of these drop out areas. These difficulties persuaded me to abandon the DjVu file
format as fast as possible.

I used an OCR model to separate text, equations, tables, and figures from the
DjVu scans. The OCR model extracted Russian text into markdown files. The OCR
introduced plenty of errors, besides typesetting errors in the original. But
neither matters at this stage. More important is just to get UTF-8 text that is
mostly correct. Spelling errors, bad equation translation, etc.~will be
corrected by an LLM at a subsequent stage. It is easier to see a logical error
in an equation than it is to distinguish variables in these poor scans.

Once the Russian was translated to English, formatting of the text commenced.
The initial passes were largely manual, $approx$30--40 hours of editing Typst
source code. I forced the model to use Typst and not Latex source. In general,
this is a bad design decision. The LLMs are much better at writing in Latex
(which I figure is due to the relative abundance of Latex material in the
training data set). Notwithstanding, I desire to learn Typst, so I decided to
perform typesetting in a non-standard language. The consequence was that the LLM
often slipped back into Latex math and formatting, so lots of manual fixes, find
and replace jobs, and little tweaks were necessary. As intended, I became quite 
familiar with Typst scripting.

The formatting feedback loop with the LLM was initially difficult. I would
problems and solutions in visual terms. The LLM frequently struggled to translate
by visual feedback into source code fixes. Through the process of
experimentation, I found the best way to communicate the what I wanted the LLM
to do was just to edit the source code that the LLM gave me, and have it learn
from the diff. The entire process takes longer than writing a short prompt, and
requires the prompter be familiar with the source code, but it is vastly superior
than the visual feedback loop. It seems that knowing computer languages may
still hold value if one is interested in getting optimal results from LLMs.

Once the text was translated and typeset, it had to be verified. There were plenty
of translation, OCR, and typesetting errors in the translated manuscript at this
point. Many LLM passes, careful reads, and machine proofs of equations
repaired the majority of these errors.

After all of this, it was time to put figures into the translation. Figures
often include Cyrillic text, so I could not just put most figures directly into
the document --- translation in the figures was necessary. What was worse, the
scanned figures often had edges clipped off, distortions, or were marred
otherwise in a manner difficult to programmatically describe. My first approach
to these problems went poorly; the second worked much better.

First I tried to do full scientific image restoration, and wasted millions of
tokens. The LLM assembled all tools it could, but I found the results to be
unsatisfactory most of the time. To make most figures passable, a large amount
of human work needed to be done in the form of iterative prompting. I knew my
approach was not very productive and poor, but it was not immediately obvious to
me _why_ it was such a poor idea to do this. In short, I was not putting enough
structural information into the problem solution. Bitonal images are tricky to
reconstruct, and need to be treated carefully for noise, smudges, misalignment,
etc. My model was trying to make too many choices in the process of
reconstruction without clear guidance on the image source structure. The goal is
not to enable the model to do everything, but to restrict the model such that it
can only do the most meaningful things.

A couple months later, I attacked the problem again with new understanding. The
image structure from the very beginning, and I narrowed the scope of the project
from image restoration back to translation: first vectorize, then find text, and
finally translate into the language and font of the document body. Restricting
the project scope and putting the model back in front if the DjVu source limited
the scope of the work, and also improved resulting figures substantially. While
for translation getting away from the DjVu was the first thing to do, in the
case of images I found the exact opposite to be true: staying close to the
source, reminding the model about the encoding and aliasing, was absolutely
critical.

The resulting translation is beautiful, informative, and faithful to the original.
I learned a lot by doing it, and am happy where it currently is.

#hr

= Preface

In the time that has passed since the second edition of the book _Fundamentals
of Gamma-Ray Spectrometry of Natural Media_ (1976), this method of studying the
artificial and natural radioactivity of the environment has continued to
develop intensively. The search for mineral deposits --- in geology; the
identification of territories subjected to contamination from experimental
nuclear explosions and as a result of the activity of enterprises --- in
radioecology and environmental protection; the study of the radioactivity of
the planets of the Solar System --- in cosmonautics; the study of water
resources over large territories --- in hydrology --- this is an incomplete
list of the applications, developed in the USSR, of field methods of gamma-ray
spectrometry of natural media.

Whereas from the end of the 1950s to the beginning of the 1970s the development
of the theoretical foundations and practical applications was the result mainly
of the work of Soviet scientists, in subsequent years gamma-ray spectrometry of
natural media found wide application in other countries as well (the USA,
Canada, Japan). This was facilitated in part by the publication abroad, in
English, in 1971, of the first edition of the present monograph. For their
pioneering achievements in creating the gamma-ray spectrometry of natural media
and its wide use in the national economy, a group of scientists, including the
authors of this book, was awarded the USSR State Prize in 1979.

The present, 3rd edition has been fundamentally revised to take into account
the latest achievements in the field of gamma-ray spectrometry of natural media
and publications on this subject in the scientific literature.

In the third edition, chapters have been omitted on radionuclides and their
$gamma$-radiation, the interaction of $gamma$-radiation with matter, the search
for mineral deposits, the determination of the moisture reserve in snow
cover, soil moisture, and the measurement of the radionuclide composition of
planets, since specialized monographs, reference literature, and the like are
now available on all of these topics. The derivations of most formulas have
also been omitted, since the reader can find them in the earlier editions of
the book or in the original papers. Usually only the initial premises and the
final expressions are given. At the same time, the book has been substantially
supplemented with original material. It presents the results of calculations of
the gamma field in a homogeneous medium, an approximate analytical method for
calculating the $gamma$-radiation spectrum in natural media, as well as new
experimental and computational data on the structure and variations of the
gamma field in the surface atmosphere. For the first time, a detailed
characterization is given of external exposure over virtually the entire
territory of the USSR resulting from global fallout of #super[137]Cs and from
natural radioactivity, as well as from cosmic radiation. Maps of the spatial
distribution of #super[137]Cs contamination density, of U, Th, and K content in
rocks, and of Rn in air, as well as of the $gamma$-radiation dose rate due to
these radionuclides, were obtained as a result of airborne and ground
gamma-spectral surveys carried out over the country's territory.

Special attention is given to questions of monitoring, by gamma-spectrometric
methods, radioactive contamination from nuclear power plants and enterprises of
the nuclear industry, and to studies related to identifying contamination
resulting from the accident at the Chernobyl Nuclear Power Plant.

The authors thank S.~D. Abramovskaya and L.~A. Prokhorova for their help in
preparing the manuscript for publication.

_The Authors._
