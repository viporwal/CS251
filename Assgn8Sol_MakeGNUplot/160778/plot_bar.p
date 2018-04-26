set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
set output "bar.eps"
set key left
set key font ",12"
set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"
set xlabel "No.of elements"
set ylabel "Average speedup"
set yrange[0:]
set ytic auto
set boxwidth 1 relative
set style data histograms
set style histogram cluster
set style fill pattern border
plot 'bar.out' u 2:xticlabels(1) title "1",\
'' u 3 title "2" fillstyle pattern 7,\
'' u 4 title "4" fillstyle pattern 12,\
'' u 5 title "8" fillstyle pattern 14,\
'' u 6 title "16" fillstyle pattern 15

