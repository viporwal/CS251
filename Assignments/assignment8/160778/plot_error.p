set terminal postscript eps enhanced color size 3.9,2.9
set key font ",12"
set key left
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

set term postscript eps enhanced monochrome 20 dashed dashlength 1 lw 1.5
set output "error.eps"
set xtics rotate by -45
set style histogram errorbars lw 3
set style data histogram

plot 'error.out' u 2:7:xticlabels(1) title "1",\
'' u 3:8 title "2" fillstyle pattern 7,\
'' u 4:9 title "4" fillstyle pattern 12,\
'' u 5:10 title "8" fillstyle pattern 14,\
'' u 6:11 title "16" fillstyle pattern 15
