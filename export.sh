#!/bin/sh

for  X in QFcarriage QFbracket1 QFbracket2 QFextruderClamps QFextruderAdapter1 QFextruderAdapter2; do
	echo "Exporting $X"
	cat >$X.scad <<EOF
include <QF.scad>

${X}(printable=1);
EOF

	openscad -o $X.stl $X.scad 2>/dev/null
done
