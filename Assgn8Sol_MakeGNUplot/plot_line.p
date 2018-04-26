set terminal postscript eps enhanced color

set key samplen 2 spacing 1.5 font ",22"

set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"

set xlabel "No.of elements"
set ylabel "Execution Time(in {/Symbol m}s)"
set yrange[0:]
set xrange[0:2000000]
set ytic auto
set xtic auto


set output "line.eps"
plot 'line1.out' using 1:2 title "1" with linespoints, \
	'line2.out' using 1:2 title "2" with linespoints, \
	'line4.out' using 1:2 title "4" with linespoints, \
	'line8.out' using 1:2 title "8" with linespoints, \
	'line16.out' using 1:2 title "16" with linespoints, \
