###############################################################################
#                                                        Nov. 29, 2016
# Makefile for Proceedings of ISS2016
# - Yuki Sakurai  <yuki.sakurai@ipmu.jp>
#
###############################################################################


FILE    := ISS2016_v01
TEX     := platex
REFGREP := grep "^LaTeX Warning: Label(s) may have changed."
REF     := $(FILE).bib

DVIPS   := dvips -Ppdf
DVIPDF  := dvipdfmx -p a4 $(FILE).dvi
BIBTEX  := bibtex
PDFA    := gs -dPDFA -dPDFACompatibilityPolicy=1 -dBATCH -dNOPAUSE -sProcessColorModel=DeviceRGB -sDEVICE=pdfwrite -sOutputFile=$(FILE)_pdfa.pdf $(FILE).pdf

UNAME   := $(shell uname -s)

pdf: $(FILE).pdf
ifeq (${UNAME},Darwin)
	@open $<
else
	@acroread $<
endif

pdfa: $(FILE)_pdfa.pdf
ifeq (${UNAME},Darwin)
	@open $<
else
	@acroread $<
endif

$(FILE)_pdfa.pdf: $(FILE).pdf
	$(PDFA)

$(FILE).pdf: $(FILE).dvi
	$(DVIPDF)

$(FILE).dvi: $(FILE).aux
	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)

############### IF YOU WRITE CITATION ################
# $(FILE).dvi: $(FILE).aux $(FILE).bbl
# 	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)

# $(FILE).bbl: $(REFFILE)
# 	$(BIBTEX) $(FILE)
############### IF YOU WRITE CITATION ################

$(FILE).aux: $(FILE).tex
	$(TEX) $(FILE)

.PHONY: clean
clean:
	rm -r -f *.aux *.dvi *.log *.out *.pdf *.tpt *.ps *.toc *.tof *.lot *.lof *.bbl *.blg thumb*.* *~ *.tex-e \#*
