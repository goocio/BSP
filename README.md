This is a template for Oxford Mathematics 3rd year BSP (Part B Structured Project) essays.


### Provided features

The features are mostly related to styling contents: a title page, footers, environments, a list of notation, correct bibliography format, etc., and therefore you have a decent amount of freedom over some specifics of the parameters such as colors and spacing (search "%FORMAT" in the project; any line with it has some color/spacing option you are free to change). Math is also made copy-pasteable, conditional on you using the $\LaTeX$-style `\(...\)` for inline math and `\[...\]` for display math instead of the $\TeX$-style `$...$` and `$$...$$` respectively.

There are three settings:
- `titlepage-abstract`, which causes the abstract to appear on the title page (see `\abstractpage` below);
- `color-theorems`, which causes theorems, definitions, proofs, examples, etc. to be placed in colored boxes;
- `color-headings`, which cases chapter and section headings to be placed in colored bars.

The class and commands are set up so that any one of these can be passed or not passed without having to change your document's body at all.

Several commands are provided:
- `frontmatter` environment: sets the page styling to be suitable for frontmatter (abstract, table of contents, etc.);
- `backmatter` environment: sets the page styling to be suitable for backmatter (list of notation, bibliography, etc.);
- `\abstract{}`: to be used in preamble to define your abstract (if you want one);
- `\abstractpage`: to be used in frontmatter (optionally) to put a page containing your abstract (see `titlepage-abstract` above);
- `\candidatenumber{}`: to be used in preamble to define your candidate number (accordingly, `\author` has been *un*defined, since we are not supposed to give our name);
- `\notationlist{}`: to be used in frontmatter or backmatter (optionally) to put a page containing notation (see `notationtable` environment);
- `notationtable{}` environment: to be used in the argument for `\notationlist` to place a table for defining notation, with an argument for a heading (or use `notationtable*` to have no heading, if you just want one big table);
- several `amsthm` environments: `thm` (theorem), `prop` (proposition), `lem` (lemma), `cor` (corollary), `defn` (definition), `alg` (algorithm), `rmk` (remark), `exmp` (example), `conj` (conjecture), and `proof`. (The `color-theorems` package option technically uses the `tcolorbox` package, instead of `amsthm`, but the class gives it a wrapper so that it is used in an identical manner to the `amsthm` environments.)

Additionally, a few very useful (i.e. basically essential) commands are defined in `preamble.sty`.


### Customization

A bare-bones preamble file `preamble.sty` is provided, and you're free to add in your own preamble stuff to that (although it's not likely you'd want to remove anything that's there, since it's all fairly essential). The class file `bsp.cls` should probably not be changed unless you know what you're doing, aside from:
- any line with `%FORMAT` in has some color/spacing option you're free to change;
- there are several AMS environments (listed at the end of [the above section](#provided-features)) defined, and you may add your own or change their names.