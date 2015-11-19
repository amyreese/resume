
.DEFAULT_GOAL=pdf
# Options

rbase=JohnReese

rtex=$(rbase).tex
rdvi=$(rbase).dvi
rlog=$(rbase).log
raux=$(rbase).aux

rpdf=$(rbase).pdf

pubserver=jreese@leetcode.net
pubpath=/srv/www/files/resume

# System

mkdvi=$(shell which latex)
mkpdf=$(shell which dvipdf)

rm=rm -f

# Rules

$(rdvi): $(rtex)
	$(mkdvi) $(rtex)

$(rpdf): $(rdvi)
	$(mkpdf) $(rdvi) $(rpdf)

.PHONY: pdf clean dist-clean publish
pdf: $(rpdf)
	@echo pdf done.

publish: $(rpdf) $(rtex)
	scp Makefile $(pubserver):$(pubpath)/Makefile
	scp $(rtex) $(pubserver):$(pubpath)/$(rtex)
	scp $(rpdf) $(pubserver):$(pubpath)/$(rpdf)

clean:
	-$(rm) $(rdvi) $(rlog) $(raux)

dist-clean: clean
	-$(rm) $(rpdf)

