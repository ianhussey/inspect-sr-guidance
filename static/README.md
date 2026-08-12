# INSPECT-SR — Word (.docx) output

Two files to install:

| File | Where it goes |
|:--|:--|
| `reference.docx` | `static/reference.docx` |
| `print-tweaks.lua` | `static/print-tweaks.lua` |

`sample-output.docx` and `sample-output.pdf` install nowhere — they're previews
of the result.

Tested against Quarto 1.7.32 with a cut-down copy of your book (parts, callouts,
kable tables, code blocks, blockquotes, and the full 54-name contributor list),
rendering html + pdf + docx from a single `quarto render`.

> `print-tweaks.lua` replaces the earlier `docx-tweaks.lua`. Badge handling has
> been dropped, the version prefix added, and it now applies to PDF as well as
> Word. Delete the old file.

---

## 1. `_quarto.yml`

```yaml
book:
  downloads: [pdf, docx]

format:
  html:
    # ... unchanged ...

  pdf:
    number-sections: false
    documentclass: report
    classoption: oneside
    geometry:
      - top=25mm
      - bottom=25mm
      - left=25mm
      - right=25mm
    filters:
      - static/print-tweaks.lua

  docx:
    number-sections: false
    toc: true
    toc-depth: 3
    reference-doc: static/reference.docx
    filters:
      - static/print-tweaks.lua
    df-print: kable
    highlight-style: breeze
```

The filter must be registered under **both** `pdf:` and `docx:` — that's what
puts "Version " in front of the version number in each.

Without `docx` in `downloads:`, the Word file is still built into `_book/` but
the website has no link to it.

---

## 2. Rendering

```bash
quarto render                 # html + pdf + docx, everything under format:
quarto render --to docx       # just the Word file
quarto render --to pdf
quarto render --to html
```

Bare `quarto render` builds every format listed under `format:` in one pass:

```
_book/index.html
_book/INSPECT-SR-Guidance.pdf
_book/INSPECT-SR-Guidance.docx
```

`quarto preview` only serves the HTML — it will not rebuild the PDF or the Word
file, so run a full `quarto render` before publishing.

---

## 3. What's in the reference doc

**Page setup** — A4, 25 mm margins on all four sides (matching your PDF
geometry), centred page number in the footer, suppressed on the title page.

**Type** — Cambria 11 pt body, Calibri headings, Consolas for code. All three
ship with Microsoft Office on both Windows and macOS, so nothing substitutes.

**Headings** — Heading 1 (19 pt, deep blue `1F4E79`) has *page break before*, so
every check starts on a fresh page. Heading 2 mid-blue `2E74B5`, Heading 3 bold
dark grey, Heading 4 bold italic. `keepNext`/`keepLines` throughout so headings
never strand at a page foot.

**Contributor block** — `Author` is set 8.5 pt, tight leading, no
inter-paragraph space. Combined with the filter (below), the 54 names run in as
a single paragraph of about six lines instead of 54 separate lines.

**Other styles set** — `Source Code` (shaded, bordered, 9 pt mono),
`Block Text` (blockquote with a blue left rule), `Table` (Calibri 9.5 pt, bold
header row, tightened cell margins), captions (9 pt grey), footnotes,
bibliography with hanging indent, `TOC Heading`.

**TOC** — `updateFields` is set, so Word populates the table of contents when it
opens the file rather than showing an empty placeholder. Word will ask "update
the fields in this document?" — say yes. (LibreOffice ignores this; press
Ctrl+A then F9 there.)

**Callouts need nothing.** Quarto emits them as raw OpenXML tables carrying
inline borders and shading, so they render as proper coloured boxes with icons
regardless of the reference doc. The `Table` style is deliberately kept neutral
because callouts and your kable tables share it.

**Leftover badge styles.** The reference doc still defines four unused character
styles (`Badge Draft 1`–`3`, `Badge Complete`) from when badges were in the
book. They're harmless — just clutter in Word's style pane. Delete them in Word
if they bother you.

---

## 4. `print-tweaks.lua`

A no-op for HTML. For PDF and Word:

**Prefixes the date with "Version "**, so the title block reads "Version 1.1.2"
rather than a bare "1.1.2". HTML needs no help — it gets the label from
`language.title-block-published`. The version number stays defined in exactly
one place (`book.date-format`), because the filter prefixes whatever Quarto has
already rendered rather than hardcoding it.

The obvious alternative doesn't work: setting `date-format: "[Version 1.1.2]"`
under `format: pdf:` / `format: docx:` is ignored — the book-level
`date-format` wins the merge and the output stays "1.1.2". Setting it at book
level instead would make the HTML read "Version / Version 1.1.2".

**Collapses the contributor list** into one comma-separated paragraph, Word
only. Pandoc's docx template loops `$for(author)$` and emits a separate
paragraph per author, and a paragraph is a paragraph in Word — no style setting
can make consecutive paragraphs flow into each other. The filter collapses the
list to a single metadata value before the template runs, so the loop fires
once.

---

## 5. Two limitations worth knowing

### `part:` is dropped in docx

**Quarto does not render book parts in Word output.** All five of your `part:`
entries — the Domain titles and Appendices — are silently dropped, so the checks
run together with no domain structure. Confirmed both with string parts
(`- part: "Domain 1: ..."`) and file-based parts (`- part: parts/domain1.qmd`);
neither appears. Parts work fine in HTML and PDF, so this is docx-specific.

The workaround is a docx-only heading at the top of the first chapter in each
domain — `chapters/check_1_1.qmd`, `check_2_1.qmd`, `check_3_1.qmd`,
`check_4_1.qmd`:

```markdown
::: {.content-visible when-format="docx"}
# Domain 1: Inspecting post-publication notices

Checks in this domain examine whether the trial has been the subject of a
retraction, an expression of concern, or another post-publication notice.
:::
```

Because Heading 1 carries *page break before*, each becomes a divider page, and
the domain titles appear in the table of contents. `when-format="docx"` keeps
them out of the HTML and PDF builds, where real parts already work.

### The PDF still lists contributors one per line

The filter only collapses the Word list. Quarto builds the LaTeX title block
from its own `by-author` data before user filters run — overriding `by-author`
had no effect, and replacing `meta.author` made the authors disappear from the
title page altogether. Fixing this properly needs a title-page template partial.

---

## 6. Editing the reference doc

Open `reference.docx` in Word. It contains one sample paragraph per style — edit
the **styles** (Home → Styles pane → right-click → Modify), not the text. Any
text you type is ignored; only the style definitions, page setup, and the footer
are read. Don't delete the sample paragraphs, or the style definitions may be
dropped as unused.
