% any lines with "%FORMAT" on are formatting options that can be changed freely;
% otherwise, you probably shouldn't change anything here unless you know what you're doing.
% for general macros / package imports / etc, see preamble.sty instead.

% sections: misc, layout, headers/footers, frontmatter/backmatter environments, abstract, title page, list of notation, bibliography, overrides/fixes, theorems/boxes 

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsp}[2026-01-25 Oxford BSP class]

\LoadClass[12pt,a4paper]{report}

\newif\iftitlepage@abstract % if the user wants an abstract on the title page
\newif\ifcolor@theorems % if the user wants colored boxes for theorems etc
\newif\ifcolor@headings % if the user wants colored headings
\DeclareOption{titlepage-abstract}{\titlepage@abstracttrue}
\DeclareOption{color-theorems}{\color@theoremstrue}
\DeclareOption{color-headings}{\color@headingstrue}
\ProcessOptions\relax



%%%%% LAYOUT

% https://tex.stackexchange.com/questions/414350/hyperlinking-the-full-citation-not-only-the-number
\RequirePackage[pdfpagelabels, hidelinks]{hyperref} % MUST BE LOADED BEFORE GEOMETRY
\RequirePackage[a4paper, left = 2cm, right = 2cm, top = 2cm, bottom = 2cm]{geometry} % page shape %FORMAT (except margins must be at *least* 2cm on each side)
% \renewcommand{\baselinestretch}{1.25} % space between lines *= 1.25 %FORMAT
\parindent0pt % no paragraph indent %FORMAT

% prevent pagebreak on new chapter, because we have a page limit
\RequirePackage{etoolbox}
\patchcmd{\chapter}{\if@openright\cleardoublepage\else\clearpage\fi}{}{}{}

%% customize headings
\ifcolor@headings

%% headings styled with a colored rectangle
\RequirePackage{tikz}
\RequirePackage[explicit]{titlesec}

\definecolor{headingcolor}{RGB}{105,134,170} % rgba(0, 50, 110, 150) %FORMAT
\def\heading@box#1#2{\begin{tikzpicture}[remember picture, overlay]
    \node[draw=headingcolor, fill=headingcolor, anchor=west, minimum height=#1, text=white] at ([xshift=-\dimexpr1in+\hoffset+\oddsidemargin\relax]0,0) {\hspace{1.85cm}\bfseries#2\phantom{i}};
\end{tikzpicture}}

\titleformat{\chapter}{}{}{0em}{\heading@box{48pt}{\LARGE\thechapter) #1}} % numbered chapters
\titleformat{name=\chapter,numberless}{}{}{0em}{\LARGE\heading@box{48pt}{#1}} % unnumbered chapters
\titlespacing*{\chapter}{0pt}{3em plus 1ex minus .2ex}{2.75em plus .25ex} % spacing around chapter heading %FORMAT
\titleformat{\section}{}{}{0em}{\heading@box{32pt}{\large\thesection) #1}} % numbered sections
\titleformat{name=\section,numberless}{}{}{0em}{\heading@box{32pt}{\large#1}} % unnumbered sections
\titlespacing*{\section}{0pt}{1em plus 2pt minus 2pt}{.9em plus 1pt}

\else

%% headings with modified spacing
\RequirePackage{titlesec}
\titleformat{\chapter}
  {\normalfont\LARGE\bfseries}{\thechapter}{1em}{}
\titlespacing*{\chapter}{0pt}{4.5ex plus 1ex minus .2ex}{1ex plus .2ex} %FORMAT

\fi



%%%%% HEADERS/FOOTERS

\RequirePackage{fancyhdr} % https://eu.mirrors.cicku.me/ctan/macros/latex/contrib/fancyhdr/fancyhdr.pdf

%% footer on most pages
\pagestyle{fancy}
% "marks" are effectively a 2-tuple (tokens, location), which is accessed once TeX's internals have sliced the document into pages;
% the "output routine" then reads through and uses marks to create page footers and headers.
% TeX provides three primitives to this end: \botmark (the last mark on the current page), \firstmark (the first mark on the current page), and \topmark (the last mark on the previous page)
% LaTeX uses \expandafter trickery to split marks into a "left" part and a "right" part, and provides \leftmark (the left part of \firstmark) and \rightmark (the right part of \botmark)
% this is insufficient for what we want: a footer that shows (as well as the page number) the chapter and section names, accurate as of where the footer is, i.e. at the bottom of that page, where \botmark is set (and therefore we don't care about \firstmark as \leftmark does)
% we somewhat copy their trick: we make each mark of the form {chapter name}{section name}, then use \expandafter to make some command receive those as its two arguments;
% LaTeX internals provide us with \@firstoftwo and \@secondoftwo which we can then use to pick out the desired one.
% e.g.: say the last mark of the page (accessed by \botmark) is {foo}{bar}; then \expandafter\@firstoftwo\botmark expands to \@firstoftwo{foo}{bar} which returns foo.
\renewcommand{\chaptermark}[1]{\mark{{#1}{}}\def\chaptername{#1}}
\renewcommand{\sectionmark}[1]{\mark{{\chaptername}{#1}}}
\def\@chaptermark{\expandafter\@firstoftwo\botmark}
\def\@sectionmark{\expandafter\@secondoftwo\botmark}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[L]{\@chaptermark}
\fancyfoot[C]{\thepage}
\fancyfoot[R]{\@sectionmark}

% footer on pages with new chapters (starting a new chapter sets the pagestyle to "plain" for that page only, so we force override the plain style to be our just-defined fancy style)
\let\ps@plain\ps@fancy



%%%%% FRONTMATTER / BACKMATTER ENVIRONMENTS

\fancypagestyle{frontbackpages}{%
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{\thepage}
}

\newenvironment{frontmatter}
{\clearpage\setcounter{page}{1}\renewcommand{\thepage}{\roman{page}}\pagestyle{frontbackpages}\let\ps@plain\ps@frontbackpages}
{\clearpage\setcounter{page}{1}\renewcommand{\thepage}{\arabic{page}}}

\newenvironment{backmatter}
{\clearpage\pagestyle{frontbackpages}\let\ps@plain\ps@frontbackpages}
{\clearpage}



%%%%% ABSTRACT

\def\abstract#1{\global\def\@abstract{#1}}

\def\abstractpage{%
\clearpage
\chapter*{Abstract}
\@abstract
\clearpage
}



%%%%% TITLE PAGE

\renewcommand{\author}[1]{\ClassError{bsp}{Author name should not be given}{Use \protect\candidatenumber\space instead}} % undefine author; the author should give only their candidate number
\def\candidatenumber#1{\global\def\@candidatenumber{#1}}

\def\titlepage@skip{\par\vspace{0.5em}} %FORMAT

\renewcommand{\maketitle}{%
\null\vfill\null\setlength{\parskip}{0pt plus 1pt}
\begin{center}
    {\huge {\bfseries {\@title}} \titlepage@skip}
    {\vspace*{1.5em}}
    {\large Submitted by Candidate \@candidatenumber \titlepage@skip MMath Mathematics \titlepage@skip University of Oxford \titlepage@skip \vspace*{1.5em} \@date}
    \iftitlepage@abstract
    {\par \vspace*{5em}}
    {{\bfseries Abstract} \par \@abstract}
    \fi
\end{center}
\vfill\null\thispagestyle{empty}\clearpage
}



%%%%% LIST OF NOTATION

\RequirePackage{tabularx} % essential for any non-trivial tables

\newenvironment{notationtable}[1]
{\section*{#1}\ifcolor@headings\else\vspace{-1em}\fi\renewcommand{\arraystretch}{1.5}\tabularx{\textwidth}{l@{\hskip 3em}X}}
{\endtabularx}
\newenvironment{notationtable*}
{\renewcommand{\arraystretch}{1.5}\tabularx{\textwidth}{l@{\hskip 3em}X}}
{\endtabularx}

\def\notationlist#1{%
\clearpage
\chapter*{Notation}\label{chap:Notation}\addcontentsline{toc}{chapter}{\nameref{chap:Notation}}
#1\relax
\clearpage
}



%%%%% BIBLIOGRAPHY

\RequirePackage[nottoc]{tocbibind}

\usepackage[backend=biber, style=numeric-comp, sorting=none]{biblatex}
\renewcommand*{\newunitpunct}{\addcomma\space}
\DeclareBibliographyDriver{book}{%
    \printnames{author}%
    \newunit\newblock%
    \printfield[emph]{title}%
    \newunit\newblock%
    \printlist{publisher}%
    \newunit%
    \printfield{year}%
    \finentry%
}
\DeclareFieldFormat[article]{title}{``#1"}
\DeclareBibliographyDriver{article}{%
    \printnames{author}%
    \newunit\newblock%
    \printfield{title}%
    \newunit\newblock%
    \printfield[emph]{journaltitle}%
    \newunit%
    \printfield{volume}%
    \printtext{.}%
    \printfield{number}%
    \printtext{ (}%
    \printfield{year}%
    \printtext{)}%
    \newunit\newblock%
    \printfield{pages}%
    \finentry%
}



%%%%% OVERRIDES/FIXES

% fix spacing around \left and \right
% see https://tex.stackexchange.com/questions/2607/spacing-around-left-and-right
\let\originalleft\left
\let\originalright\right
\renewcommand{\left}{\mathopen{}\mathclose\bgroup\originalleft}
\renewcommand{\right}{\aftergroup\egroup\originalright}

% make math searchable and copy-paste-able using accessibility support features:
% a PDF just shows images and tells the PDF reader some text to go along with those images,
% so by using this package to change just the latter and not the former, you can have some text
% (or in this case, math, which usually is garbage if you try to search it or copy-paste it)
% which visually shows one thing in the PDF but is exposed to the PDF reader's interface as another thing;
% here we set the thing exposed to the PDF reader's interface to be the latex source that went into writing the math,
% so if you enter latex math commands into your PDF reader search bar it'll match any math that used those commands,
% and likewise if you highlight and copy stuff in an equation,
% you'll copy the latex source that went into it.
% the catch is that to get this you'll need to use the latex-style math delimiters,
% namely for inline you use \(...\) and for display you use \[...\],
% instead of respectively $...$ and $$...$$
\RequirePackage{accsupp}
\newcommand{\copyablemath}[3]{\BeginAccSupp{method=escape,ActualText={\detokenize{#1#2#3}}}#2\EndAccSupp{}}
\let\oldinlinemathopen\(
\let\oldinlinemathclose\)
\def\(#1\){\oldinlinemathopen\copyablemath{\(}{#1}{\)}\oldinlinemathclose}
\let\olddisplaymathopen\[
\let\olddisplaymathclose\]
\def\[#1\]{\olddisplaymathopen\copyablemath{\[}{#1}{\]}\olddisplaymathclose}



%%%%% THEOREMS/BOXES

\ifcolor@theorems
%% color versions using tcolorbox
% tcbtheorem is considerably more developed than amsthm, including (for example) an argument in the environment that lets you choose a label name, rather than having to manually apply a label with \label.
% however, for the sake of interchangeability between tcolorbox and amsthm (both in terms of providing a class option to switch between them, and also for people who are used to amsthm already), here they are wrapped so as to function the same as amsthm environments

\RequirePackage[most,many,breakable]{tcolorbox}

\newcommand{\linedbox}[6][use counter from=theorem]{% opt#1: optional arguments for tcbtheorem, #2: environment name, #3 title, #4 label prefix (when citing), #5 background color, #6 line color
\newtcbtheorem[#1]{#2}{#3}
{%FORMAT
    enhanced,
    breakable,
    colback = #5,
    frame hidden,
    boxrule = 0sp,
    borderline west = {3pt}{0pt}{#6},
    sharp corners,
    detach title,
    before upper = \tcbtitle\par\smallskip,
    coltitle = black,
    fonttitle = \bfseries\sffamily,
    description font = \mdseries\sffamily,
    separator sign = \ ,
}{#4}
\newenvironment{#4}[1][]{\csname #2\endcsname{##1}{}\def\@currentlabel{\thetcbcounter}}{\csname end#2\endcsname}
}

% results: theorem (thm), lemma (lem), proposition (prp), corollary (cor)
\definecolor{resultlinecolor}{RGB}{103, 110, 216} % rgba(40, 50, 200, 180) %FORMAT
\definecolor{resultbgcolor}{RGB}{230, 231, 249} % rgba(40, 50, 200, 30) %FORMAT
\linedbox[number within=section]{theorem}{Theorem}{thm}{resultbgcolor}{resultlinecolor}
\linedbox{lemma}{Lemma}{lem}{resultbgcolor}{resultlinecolor}
\linedbox{proposition}{Proposition}{prop}{resultbgcolor}{resultlinecolor}
\linedbox{corollary}{Corollary}{cor}{resultbgcolor}{resultlinecolor}

% definitions: definition (defn), algorithm (alg)
\definecolor{definitionlinecolor}{RGB}{110, 170, 195} % rgba(110, 170, 195, 255) %FORMAT
\definecolor{definitionbgcolor}{RGB}{229, 240, 244} % rgba(110, 170, 195, 45) %FORMAT
\linedbox{definition}{Definition}{defn}{definitionbgcolor}{definitionlinecolor}
\linedbox{algorithm}{Algorithm}{alg}{definitionbgcolor}{definitionlinecolor}

% notes: remark (rmk), example (exmp), conjecture (conj)
\definecolor{notelinecolor}{RGB}{134, 232, 213} % rgba(126, 231, 210, 240) %FORMAT
\definecolor{notebgcolor}{RGB}{237, 252, 249} % rgba(126, 231, 210, 35) %FORMAT
\linedbox{remark}{Remark}{rmk}{notebgcolor}{notelinecolor}
\linedbox{example}{Example}{exmp}{notebgcolor}{notelinecolor}
\linedbox{conjecture}{Conjecture}{conj}{notebgcolor}{notelinecolor}

% proofs: proof (prf)
\definecolor{prooflinecolor}{RGB}{103, 103, 103} % rgba(40, 40, 40, 180) %FORMAT
\definecolor{proofbgcolor}{RGB}{247, 247, 247} % rgba(40, 40, 40, 10) %FORMAT
\linedbox{@proof}{Proof}{proof}{proofbgcolor}{prooflinecolor} % this numbers the proofs, so we renew the environment to prevent that; but we still allow a title, so you can do e.g. "Proof (of Theorem 1.2.3)"
\def\qed{\null\nobreak\hfill\ensuremath{\blacksquare}} % qed square %FORMAT switch \blacksquare to \square for the not-filled-in version
\renewenvironment{proof}[1][]{\csname @proof*\endcsname{#1}{}}{\qed\csname end@proof*\endcsname}
\def\flushproof{\vspace{-\parskip}} % put this before a proof to make it flush with the result it's proving


\else
%% regular theorem environments with amsthm

\RequirePackage{amsthm}

\newtheoremstyle{default}%FORMAT
    {1em}% space above (plain: {\topsep})
    {1em}% space below (plain: {\topsep})
    {}% body font (plain: {\itshape})
    {}% indent (plain: {0pt})
    {\bfseries}% theorem head font (plain: {\bfseries})
    {:}% punctuation after theorem head (plain: {.})
    {.5em}% space after theorem head (plain: {5pt plus 1pt minus 1pt})
    {}% theorem head spec (plain: {})

\theoremstyle{default}
\newtheorem{thm}{Theorem}[section]
\newtheorem{lem}[thm]{Lemma}
\newtheorem{prop}[thm]{Proposition}
\newtheorem{cor}[thm]{Corollary}
\newtheorem{defn}[thm]{Definition}
\newtheorem{alg}[thm]{Algorithm}
\newtheorem{rmk}[thm]{Remark}
\newtheorem{exmp}[thm]{Example}
\newtheorem{conj}[thm]{Conjecture}
\def\flushproof{} % defined to ensure interchangeability with the color version

\fi