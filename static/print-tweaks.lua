--[[
  print-tweaks.lua — fixes for the non-HTML builds of the INSPECT-SR book.
  Register under BOTH format: pdf: and format: docx: in _quarto.yml.

  pdf + docx : prefixes the date with "Version ", so the title block reads
               "Version 1.1.2" rather than a bare "1.1.2". HTML needs no help —
               it gets the label from language.title-block-published.

  docx only  : collapses the contributor list into a single comma-separated
               paragraph. Pandoc otherwise emits one paragraph per author,
               i.e. ~54 short lines.

  A no-op for HTML.
--]]

local is_docx  = FORMAT:match("docx")
local is_latex = FORMAT:match("latex") or FORMAT:match("beamer")

if not (is_docx or is_latex) then
  return {}
end

local function author_name(a)
  if type(a) == "table" and a.name ~= nil then
    local n = a.name
    if type(n) == "table" and n.literal ~= nil then
      return pandoc.utils.stringify(n.literal)
    end
    return pandoc.utils.stringify(n)
  end
  return pandoc.utils.stringify(a)
end

function Meta(meta)
  -- "1.1.2" -> "Version 1.1.2".  Quarto has already applied date-format by
  -- this point, so prefixing the rendered string keeps the version number
  -- defined in exactly one place (book.date-format in _quarto.yml).
  if meta.date ~= nil then
    local d = pandoc.utils.stringify(meta.date)
    if d ~= "" and not d:match("^[Vv]ersion") then
      meta.date = pandoc.MetaInlines(pandoc.Inlines("Version " .. d))
    end
  end

  -- Run the contributor list together (Word only — the LaTeX title block is
  -- built from Quarto's own by-author data and ignores this).
  if is_docx then
    local src = meta.author or meta.authors
    if src ~= nil then
      local names = {}
      for _, a in ipairs(src) do
        local n = author_name(a)
        if n ~= "" then names[#names + 1] = n end
      end
      if #names > 1 then
        meta.author = pandoc.MetaInlines(pandoc.Inlines(table.concat(names, ", ")))
        meta.authors = nil
        meta["by-author"] = nil
      end
    end
  end

  return meta
end
