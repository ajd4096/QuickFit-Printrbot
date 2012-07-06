TARGETS=$(shell sed -n '/^module.*make me/s/^module[\t ]*\(.*\)[\t ]*().*/\1.gcode/p' QF.scad)

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.scad:
	echo -n 'use <QF.scad>\n!$*();' > $@

%.stl: %.scad	Makefile
	openscad -m make -o $@ -d $@.deps -D printable=1 $<

%.gcode:	%.stl
	../Slic3r/slic3r.pl --load ../config-ABS-DRAFT.ini $<
