"""Tells whether two versions of a Dart file differ in more than comments.

Used by scripts/tested.sh to spot docs-only changes. Run it, don't import it:

    python3 -I scripts/lib/dart_tokens.py OLD_FILE NEW_FILE

Exits 0 when the code differs, 1 when only comments or whitespace changed,
and 2 on bad usage.

Both files are split into tokens (identifiers, numbers, string literals,
punctuation) with comments and whitespace dropped, then compared. String
literals are kept verbatim, interpolations included, so anything inside a
string counts as code. When unsure the scanner errs towards "the code
changed", which only ever asks for a test that was not strictly needed.
"""

import sys

_IDENT_START = set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$")
_IDENT_PART = _IDENT_START | set("0123456789")


class _Scanner:
    def __init__(self, src):
        self.src = src
        self.i = 0
        self.n = len(src)

    def peek(self, k=0):
        j = self.i + k
        return self.src[j] if j < self.n else ""

    def startswith(self, s):
        return self.src.startswith(s, self.i)

    def skip_block_comment(self):
        # Dart block comments nest.
        depth = 0
        while self.i < self.n:
            if self.startswith("/*"):
                depth += 1
                self.i += 2
            elif self.startswith("*/"):
                depth -= 1
                self.i += 2
                if depth == 0:
                    return
            else:
                self.i += 1

    def skip_line_comment(self):
        while self.i < self.n and self.src[self.i] != "\n":
            self.i += 1

    def string_literal(self):
        """Consumes a string literal starting at self.i (after any `r`)."""
        start = self.i
        raw = False
        if self.peek() in "rR":
            raw = True
            self.i += 1
        quote = self.peek()
        if self.src.startswith(quote * 3, self.i):
            delim = quote * 3
        else:
            delim = quote
        self.i += len(delim)
        while self.i < self.n:
            if self.startswith(delim):
                self.i += len(delim)
                return self.src[start:self.i]
            c = self.src[self.i]
            if not raw and c == "\\":
                self.i += 2
            elif not raw and c == "$" and self.peek(1) == "{":
                self.i += 2
                self.skip_interpolation()
            elif len(delim) == 1 and c == "\n":
                # Unterminated single-line string: stop here.
                return self.src[start:self.i]
            else:
                self.i += 1
        return self.src[start:self.i]

    def skip_interpolation(self):
        """Consumes the code of `${...}` up to and including its `}`."""
        depth = 1
        while self.i < self.n:
            c = self.src[self.i]
            if self.startswith("//"):
                self.skip_line_comment()
            elif self.startswith("/*"):
                self.skip_block_comment()
            elif self.at_string():
                self.string_literal()
            elif c == "{":
                depth += 1
                self.i += 1
            elif c == "}":
                depth -= 1
                self.i += 1
                if depth == 0:
                    return
            else:
                self.i += 1

    def at_string(self):
        c = self.peek()
        if c in "'\"":
            return True
        return c in "rR" and self.peek(1) in "'\"" and not self.prev_is_ident()

    def prev_is_ident(self):
        return self.i > 0 and self.src[self.i - 1] in _IDENT_PART

    def tokens(self):
        out = []
        while self.i < self.n:
            c = self.src[self.i]
            if c.isspace():
                self.i += 1
            elif self.startswith("//"):
                self.skip_line_comment()
            elif self.startswith("/*"):
                self.skip_block_comment()
            elif self.at_string():
                out.append(self.string_literal())
            elif c in _IDENT_START or c.isdigit():
                start = self.i
                while self.i < self.n and (
                    self.src[self.i] in _IDENT_PART or self.src[self.i] == "."
                    and c.isdigit() and self.peek(1).isdigit()
                ):
                    self.i += 1
                out.append(self.src[start:self.i])
            else:
                out.append(c)
                self.i += 1
        return out


def code_tokens(src):
    """The tokens of a Dart source, without comments or whitespace."""
    return _Scanner(src).tokens()


def main(argv):
    if len(argv) != 3:
        sys.stderr.write("usage: dart_tokens.py OLD_FILE NEW_FILE\n")
        return 2
    texts = []
    for path in argv[1:]:
        with open(path, encoding="utf-8", errors="surrogateescape") as f:
            texts.append(f.read())
    return 0 if code_tokens(texts[0]) != code_tokens(texts[1]) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
