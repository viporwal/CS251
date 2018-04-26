my_data=csvread('train.csv');
X_train=my_data(:,1);
X_train=X_train(2:end);
Y_train=my_data(:,2);
Y_train=Y_train(2:end);
one_matrix=ones(rows(X_train),1);
x_train=[one_matrix X_train];
w=randn(1,2);
temp=x_train*w';
plot(X_train,temp,'-',X_train,Y_train,'ro');
xlabel ("X");
ylabel ("Label");
title ("Plot with random value of w and raw data");
%print -dpdf "fig1.pdf";
pause(1);
w_direct=(inv(x_train'*x_train))*(x_train'*Y_train);
temp=x_train*w_direct;
plot(X_train,temp,'-',X_train,Y_train,'ro');
xlabel ("X");
ylabel ("Label");
title ("Plot with raw data and direct value of w");
%print -dpdf "fig2.pdf";
pause(1);
epochs=3;
n_train=rows(X_train);
batch_size=10;
count=0;
plot(X_train,Y_train,'ro');
hold on;
for i=1:epochs,
        for j=1:n_train,
                x_temp=[1 X_train(j)];
                y_temp=Y_train(j);
                w=w-0.000000015*((w*x_temp'-y_temp)*x_temp);
                if(mod(j,50)==0&& count<7),
                        temp=x_train*w';
                        plot(X_train,temp);
                        pause(1);
			            count=count+1;
	            elseif(mod(j,100)==0&& count<15),
    		            temp=x_train*w';
                        plot(X_train,temp);
                        pause(1);
    		            count=count+1;
                end
        end
end
xlabel ("X");
ylabel ("Label");
title ("Plot with raw data and improving value of w");
%print -dpdf "fig3.pdf";
hold off;
temp=x_train*w';
plot(X_train,temp,'-',X_train,Y_train,'ro');
xlabel ("X");
ylabel ("Label");
title ("Plot with raw data and final value of w");
%print -dpdf "fig4.pdf";
pause(2);
my_data=csvread('test.csv');
X_test=my_data(:,1);
X_test=X_test(2:end);
Y_test=my_data(:,2);
Y_test=Y_test(2:end);
one_matrix=ones(rows(X_test),1);
x_test=[one_matrix X_test];
y_pred1=x_test*w';
y_pred2=x_test*w_direct;
temp1=y_pred1-Y_test;
temp2=y_pred2-Y_test;
temp1=temp1.^2;
temp2=temp2.^2;
printf("Root Mean square error in direct value is ");
disp(sqrt(mean(temp2)));
printf("Root Mean square error in learned value is ");
disp(sqrt(mean(temp1)));