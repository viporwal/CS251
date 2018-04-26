all:report.pdf

report report.pdf:report.tex thread1.eps thread2.eps thread4.eps thread8.eps thread16.eps line1.eps line2.eps line4.eps line8.eps line16.eps bar.eps error.eps
	pdflatex report.tex

plot:plot_scatter plot_line plot_bar plot_error
	
plot_scatter thread1.eps thread2.eps thread4.eps thread8.eps thread16.eps:thread1.out thread2.out thread4.out thread8.out thread16.out plot_scatter.p
	gnuplot plot_scatter.p
	
plot_line line1.eps line2.eps line4.eps line8.eps line16.eps:line1.out line2.out line4.out line8.out line16.out plot_line.p
	gnuplot plot_line.p
	
plot_bar bar.eps:bar.out plot_bar.p
	gnuplot plot_bar.p
	
plot_error error.eps:error.out plot_error.p
	gnuplot plot_error.p

analyse thread1.out thread2.out thread4.out thread8.out thread16.out line1.out line2.out line4.out line8.out line16.out bar.out error.out:output scatter.sh line.sh bar.sh error.sh
	./scatter.sh
	./line.sh
	./bar.sh
	./error.sh

runtest output:app params.txt runtest.sh
	./runtest.sh

app:prog.o thread_function.o common.h
	gcc -o app thread_function.o prog.o -lm -lpthread

prog.o:prog.c common.h
	gcc -c prog.c -o prog.o -lpthread -lm

thread_function.o:thread_function.c common.h
	gcc -c thread_function.c -o thread_function.o -lm

clean:
	rm -f *.o app *.out *.eps *.aux *.log *.pdf output *.lof *.dvi