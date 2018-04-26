set terminal postscript eps enhanced color

set key samplen 2 spacing 1 font ",22"

set xtics font ",22"
set ytics font ",22"
set ylabel font ",25"
set xlabel font ",25"

set xlabel "No. of Elements"
set ylabel "Execution Time(in {/Symbol m}s)"
set yrange[0:]
set xrange[0:2000000]
set ytic auto
set xtic auto


set output "thread1.eps"
plot 'thread1.out' using 1:2 title "1" with points pt 1 ps 1.5

set terminal postscript eps enhanced color
set output "thread2.eps"
plot 'thread2.out' using 1:2 title "2" with points pt 1 ps 1.5

set terminal postscript eps enhanced color
set output "thread4.eps"
plot 'thread4.out' using 1:2 title "4" with points pt 1 ps 1.5

set terminal postscript eps enhanced color
set output "thread8.eps"
plot 'thread8.out' using 1:2 title "8" with points pt 1 ps 1.5

set terminal postscript eps enhanced color
set output "thread16.eps"
plot 'thread16.out' using 1:2 title "16" with points pt 1 ps 1.5
