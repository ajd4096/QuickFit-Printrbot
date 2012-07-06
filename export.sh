#!/bin/sh

for  X in QFcarriage QFbracket1 QFbracket2 QFextruderClamps QFextruderAdapter1 QFextruderAdapter2; do
	echo "Exporting $X"
	cat >$X.scad <<EOF
include <QF.scad>

!${X}();
EOF

	openscad -o $X.stl -D printable=1 $X.scad 2>/dev/null
done
