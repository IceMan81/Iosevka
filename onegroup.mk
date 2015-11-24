TARGETUPM = 1000

PREFIX = $(VARIANTNAME)iosevka$(SUFFIX)

SUPPORT_FILES = support/glyph.js support/stroke.js support/spiroexpand.js support/spirokit.js parameters.js extract.js generate.js emptyfont.toml parameters.toml
GLYPH_SEGMENTS = glyphs/common-shapes.patel glyphs/overmarks.patel glyphs/latin-basic-capital.patel glyphs/latin-basic-lower.patel glyphs/greek.patel glyphs/cyrillic-basic.patel glyphs/latin-extend-basis.patel glyphs/latin-extend-decorated.patel glyphs/cyrillic-extended.patel glyphs/numbers.patel glyphs/symbol-ascii.patel glyphs/symbol-punctuation.patel glyphs/symbol-math.patel glyphs/symbol-geometric.patel glyphs/symbol-other.patel glyphs/symbol-letter.patel glyphs/autobuilds.patel
OBJDIR = build
FILES = $(SUPPORT_FILES) buildglyphs.js

# Change this when an error reports
# On windows, maybe `2> NUL`.

ifeq ($(OS),Windows_NT)
SHELL = C:\\Windows\\System32\\cmd.exe
SUPPRESS_ERRORS = 2> NUL
NODE = node --noincremental_marking --max_executable_size=1024
else
SUPPRESS_ERRORS = 2> /dev/null
NODE = node
endif

UPRIGHT = $(OBJDIR)/$(PREFIX)-regular.ttf $(OBJDIR)/$(PREFIX)-bold.ttf
ITALIC  = $(OBJDIR)/$(PREFIX)-italic.ttf $(OBJDIR)/$(PREFIX)-bolditalic.ttf
TARGETS = $(UPRIGHT) $(ITALIC)
MAPS    = $(subst .ttf,.charmap,$(TARGETS))

FDTS    = $(subst .ttf,.fdt,$(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(TARGETS)))
PASS0   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(TARGETS))
ABFEAT  = $(subst .ttf,.ab.fea,$(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(TARGETS)))
FEATURE = $(subst .ttf,.fea,$(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(UPRIGHT)))
FEATITA = $(subst .ttf,.fea,$(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(ITALIC)))
PASS1   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass0-,$(TARGETS))
PASS1   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass1-,$(TARGETS))
PASS2   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass2-,$(TARGETS))
PASS3   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass3-,$(TARGETS))
PASS4   = $(subst $(OBJDIR)/,$(OBJDIR)/.pass4-,$(TARGETS))

fonts : update $(TARGETS)
	
fdts : $(FDTS)
	
# Pass 0 : file construction
$(OBJDIR)/.pass0-$(PREFIX)-regular.fdt : $(FILES) | $(OBJDIR)
	$(NODE) generate -o $@ iosevka $(STYLE_COMMON) w-book s-upright x-regular $(STYLE_UPRIGHT) $(STYLE_X_REGILAR)
$(OBJDIR)/.pass0-$(PREFIX)-bold.fdt : $(FILES) | $(OBJDIR)
	$(NODE) generate -o $@ iosevka $(STYLE_COMMON) w-bold s-upright x-bold $(STYLE_UPRIGHT) $(STYLE_X_BOLD)
$(OBJDIR)/.pass0-$(PREFIX)-italic.fdt : $(FILES) | $(OBJDIR)
	$(NODE) generate -o $@ iosevka $(STYLE_COMMON) w-book s-italic  x-italic $(STYLE_ITALIC) $(STYLE_X_ITALIC)
$(OBJDIR)/.pass0-$(PREFIX)-bolditalic.fdt : $(FILES) | $(OBJDIR)
	$(NODE) generate -o $@ iosevka $(STYLE_COMMON) w-bold s-italic  x-bolditalic $(STYLE_ITALIC) $(STYLE_X_BOLDITALIC)

$(PASS0) : $(OBJDIR)/.pass0-%.ttf : $(OBJDIR)/.pass0-%.fdt
	$(NODE) extract --upm 12800 --uprightify 1 --ttf $@ $<
$(ABFEAT) : $(OBJDIR)/.pass0-%.ab.fea : $(OBJDIR)/.pass0-%.fdt
	$(NODE) extract --feature $@ $<
$(MAPS) : $(OBJDIR)/%.charmap : $(OBJDIR)/.pass0-%.fdt
	$(NODE) extract --charmap $@ $<
$(FEATURE) : $(OBJDIR)/.pass0-%.fea : $(OBJDIR)/.pass0-%.ab.fea features/common.fea features/uprightonly.fea
	cat $^ > $@
$(FEATITA) : $(OBJDIR)/.pass0-%.fea : $(OBJDIR)/.pass0-%.ab.fea features/common.fea features/italiconly.fea
	cat $^ > $@


# Pass 1 : Outline cleanup and merge
$(PASS1) : $(OBJDIR)/.pass1-%.ttf : pass1-cleanup.py $(OBJDIR)/.pass0-%.ttf
	fontforge -quiet -script $^ $@ $(FAST) $(SUPPRESS_ERRORS)
$(PASS2) : $(OBJDIR)/.pass2-%.ttf : pass2-smartround.js $(OBJDIR)/.pass1-%.ttf
	$(NODE) $^ $@ --upm $(TARGETUPM)
$(PASS3) : $(OBJDIR)/.pass3-%.ttf : pass3-features.py $(OBJDIR)/.pass2-%.ttf $(OBJDIR)/.pass0-%.fea
	fontforge -quiet -script $^ $@ $(TARGETUPM)
$(PASS4) : $(OBJDIR)/.pass4-%.ttf : pass4-finalize.js $(OBJDIR)/.pass3-%.ttf
	@$(NODE) $^ $@.a.ttf
	@ttx -q -o $@.a.ttx $@.a.ttf
	@ttx -q -o $@ $@.a.ttx
	@rm $@.a.ttf $@.a.ttx
$(TARGETS) : $(OBJDIR)/%.ttf : $(OBJDIR)/.pass4-%.ttf
	ttfautohint $< $@

update : $(FILES)

$(SUPPORT_FILES) :
	patel-c --strict $< -o $@

buildglyphs.js : buildglyphs.patel $(GLYPH_SEGMENTS)
	patel-c --strict $< -o $@
support/glyph.js : support/glyph.patel
support/stroke.js : support/stroke.patel
support/spirokit.js : support/spirokit.patel
support/spiroexpand.js : support/spiroexpand.patel
parameters.js : parameters.patel

$(OBJDIR) :
	@- mkdir $@

# releaseing
RELEASEDIR = releases
ARCHIVEDIR = release-archives

RELEASES = $(subst $(OBJDIR)/,$(RELEASEDIR)/,$(TARGETS))
$(RELEASES) : $(RELEASEDIR)/%.ttf : $(OBJDIR)/%.ttf
	cp $< $@

PAGEDIR = pages/assets
PAGESTTF = $(subst $(OBJDIR)/,$(PAGEDIR)/,$(TARGETS))
$(PAGESTTF) : $(PAGEDIR)/%.ttf : $(OBJDIR)/%.ttf
	cp $< $@
PAGESWOFF = $(subst .ttf,.woff,$(PAGESTTF))
$(PAGESWOFF) : $(PAGEDIR)/%.woff : $(PAGEDIR)/%.ttf
	sfnt2woff $<
PAGESMAPS = $(subst $(OBJDIR)/,$(PAGEDIR)/,$(MAPS))
$(PAGESMAPS) : $(PAGEDIR)/%.charmap : $(OBJDIR)/%.charmap
	cp $< $@

$(ARCHIVEDIR)/$(PREFIX)-$(VERSION).tar.bz2 : $(TARGETS)
	cd $(OBJDIR) && tar -cjvf ../$@ $(subst $(OBJDIR)/,,$^)
$(ARCHIVEDIR)/$(PREFIX)-$(VERSION).zip : $(TARGETS)
	cd $(OBJDIR) && 7z a -tzip ../$@ $(subst $(OBJDIR)/,,$^)

archives : $(ARCHIVEDIR)/$(PREFIX)-$(VERSION).tar.bz2 $(ARCHIVEDIR)/$(PREFIX)-$(VERSION).zip
pages : $(PAGESTTF) $(PAGESWOFF) $(PAGESMAPS)
release : $(RELEASES) archives pages

# testdrive
TESTDIR = testdrive/assets
TESTTTF = $(subst $(OBJDIR)/,$(TESTDIR)/,$(TARGETS))
$(TESTTTF) : $(TESTDIR)/%.ttf : $(OBJDIR)/%.ttf
	cp $< $@
TESTWOFF = $(subst .ttf,.woff,$(TESTTTF))
$(TESTWOFF) : $(TESTDIR)/%.woff : $(TESTDIR)/%.ttf
	sfnt2woff $<
TESTMAPS = $(subst $(OBJDIR)/,$(TESTDIR)/,$(MAPS))
$(TESTMAPS) : $(TESTDIR)/%.charmap : $(OBJDIR)/%.charmap
	cp $< $@

test : $(TESTTTF) $(TESTWOFF) $(TESTMAPS)