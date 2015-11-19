
.DEFAULT_GOAL=pdf
# Options

rbase=JohnReese

rtex=$(rbase).tex
rdvi=$(rbase).dvi
rlog=$(rbase).log
raux=$(rbase).aux

rtxt=$(rbase).txt
rpdf=$(rbase).pdf

pubserver=jreese@leetcode.net
pubpath=/srv/www/files/resume

# System

mkdvi=$(shell which latex)
mktxt=$(shell which catdvi)
mkpdf=$(shell which dvipdf)

rm=rm -f

# Rules

$(rdvi): $(rtex)
	$(mkdvi) $(rtex)

$(rtxt): $(rdvi)
	$(mktxt) $(rdvi) > $(rtxt)
	sed -i -e '/^$$/d' $(rtxt)
	sed -i -e '/^$$/d' $(rtxt)
	sed -i -e 's/\([^ ]\)   */\1 /g' $(rtxt)
	sed -i -e 's/^  *\(John.*\)$$/\1/' $(rtxt)
	sed -i -e 's/http:\/\/ johnmreese.com //' -e 's/ - 5338 */ - 5338\n/' $(rtxt)
	sed -i -e 's/^\([EO]\)/\n\1/' $(rtxt)
	sed -i -e 's/ @ /@/' $(rtxt)
	sed -i -e 's/\(Activities\)$$/\1\n/' $(rtxt)
	sed -i -e 's/^\(References\)/\n\1/' $(rtxt)
	sed -i -e 's/?/-/g' $(rtxt)
	sed -i -e 's/–/-/g' $(rtxt)
	sed -i -e 's/—/--/g' $(rtxt)
	sed -i -e 's/•/-/g' $(rtxt)
	sed -i -e 's/ﬁ/fi/g' $(rtxt)
	sed -i -e 's/^             /@@@@/g' $(rtxt)
	sed -i -e 's/^          -/@@@/g' $(rtxt)
	sed -i -e 's/^       /@@/g' $(rtxt)
	sed -i -e 's/^    -/@/g' $(rtxt)
	sed -i -e 's/^@@@@/       /g' $(rtxt)
	sed -i -e 's/^@@@/     -/g' $(rtxt)
	sed -i -e 's/^@@/    /g' $(rtxt)
	sed -i -e 's/^@\(.*[^.]\)$$/\n  -\1/g' $(rtxt)
	sed -i -e 's/^@/  -/g' $(rtxt)

$(rpdf): $(rdvi)
	$(mkpdf) $(rdvi) $(rpdf)
	#sed -i -e 's/\/Title(.*)/\/Title(John M. Reese)/g' $(rpdf)

.PHONY: txt pdf clean dist-clean publish
txt: $(rtxt)
	@echo txt done.

pdf: $(rpdf)
	@echo pdf done.

publish: $(rpdf) $(rtxt) $(rtex)
	scp Makefile $(pubserver):$(pubpath)/Makefile
	scp $(rtex) $(pubserver):$(pubpath)/$(rtex)
	scp $(rtxt) $(pubserver):$(pubpath)/$(rtxt)
	scp $(rpdf) $(pubserver):$(pubpath)/$(rpdf)

clean:
	-$(rm) $(rdvi) $(rlog) $(raux)

dist-clean: clean
	-$(rm) $(rtxt) $(rpdf)

