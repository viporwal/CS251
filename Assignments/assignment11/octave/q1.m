m = csvread("train.csv");
m(1,:) = [];

X_train = m(:,1);
Y_train = m(:,2);

NewX_train = [ones(size(X_train, 1), 1) X_train];

w = rand(2,1);

XT = transpose(NewX_train);
YT = transpose(Y_train);

wTX = transpose(w)*XT;

graphics_toolkit gnuplot
f = figure('visible','off');
hold on;
scatter(transpose(X_train),YT);
plot(transpose(X_train),wTX);
print -dpdf "Plot1.pdf";
close;

w_direct = inv(XT*NewX_train)*XT*Y_train;

wdTX = transpose((w_direct))*XT;

graphics_toolkit gnuplot
f = figure('visible','off');
hold on;
scatter(transpose(X_train),YT);
plot(transpose(X_train),wdTX);
print -dpdf "Plot2.pdf";
close;

n_train = size(X_train,1);
eta = 0.00000001;

hold on;
for i = 1:2
    for j = 1:n_train
        x = X_train(j,1);
        y = Y_train(j,1);
        xprime = NewX_train(j,1:2);
        xprimeT = transpose(xprime);
        w = w - eta*(transpose(w)*xprimeT - y)*xprimeT;
        if(rem(j,100) == 0)
            wTX = transpose(w)*XT;
            scatter(transpose(X_train),YT);
            plot(transpose(X_train),wTX);
            pause (1);
        endif
    endfor
endfor
print -dpdf "Plot3.pdf";
close;

wTX = transpose(w)*XT;
graphics_toolkit gnuplot
f = figure('visible','off');
hold on;
scatter(transpose(X_train),YT);
plot(transpose(X_train),wTX);
print -dpdf "Plot4.pdf";
close;

m = csvread("test.csv");
m(1,:) = [];

X_test = m(:,1);
Y_test = m(:,2);

NewX_test = [ones(size(X_test, 1), 1) X_test];

Y_pred1 = NewX_test*w;
Y_pred2 = NewX_test*w_direct;

er1 = Y_pred1 - Y_test;
er2 = Y_pred2 - Y_test;

n_test = size(X_test,1);

ms1 = transpose(er1)*er1.*1/n_test;
ms2 = transpose(er2)*er2.*1/n_test;

rms1 = sqrt(ms1)
rms2 = sqrt(ms2)
