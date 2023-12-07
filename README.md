# Punct

Punct is a programming environment for publishing things, implemented in Racket. It uses inline
Racket code to extend CommonMark-flavored Markdown, which is parsed into a format-independent AST
that can be rendered in HTML (or any other target file type).

**Documentation is at <https://joeldueck.com/what-about/prose/>**.

## Installation

Clone this repository, and from within the checkout’s root folder, do `raco pkg install --link
prose-lib/ prose-doc/` (note the trailing slashes).

Once this is done, try it out by following along with the [Quick Start][qs].

[qs]: https://joeldueck.com/what-about/prose/Quick_start.html

