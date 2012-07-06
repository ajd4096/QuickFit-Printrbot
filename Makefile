# Set our base.scad file
BASE=QF.scad

# Let make know about our suffixes
.SUFFIXES:	.scad .stl .gcode

# Implicit rule to build .scad -> .stl
# This also builds the .deps file
.scad.stl:
	openscad -m make -o $@ -d ${@:.stl=.deps} -D printable=1 $<

# Implicit rule to build .stl -> .gcode
.stl.gcode:
	../Slic3r/slic3r.pl --load ../config-ABS-DRAFT.ini $<

# Build the list of targets module.scad
TARGETS=$(shell sed -n '/^module.*make me/s/^module[\t ]*\(.*\)[\t ]*().*/\1.scad/p' ${BASE})

# Our default target is to build all .gcode files
all:	gcode

# Build all the .stl files
.PHONEY:
stl: ${TARGETS:.scad=.stl}

# Build all the .gcode files
.PHONEY:
gcode: ${TARGETS:.scad=.gcode}

# Include our .deps files
# use 'wildcard' so make doesn't complain about missing files
# This is GNU-make specific
include $(wildcard ${TARGETS:.scad=.deps})

# Explicit rule to create our short module.scad files
${TARGETS}:	${BASE} Makefile
	echo -n 'use <${BASE}>\n!$*();\n' > $@
