import numpy as np 
import copy
import matplotlib.pyplot as plt
import math

read = np.genfromtxt('train.csv',delimiter=",");

X_train = np.zeros(shape=(10000,1));
X_train[:,0] = copy.deepcopy(read[1:10001,0]);

NewX_train = np.ones(shape=(10000,2));
NewX_train[:,1] = copy.deepcopy(X_train[:,0]);

w = np.random.rand(2,1);

Y_train = np.zeros(shape=(10000,1));
Y_train[:,0] = copy.deepcopy(read[1:10001,1]);

XT = np.zeros(shape=(2,10000));
XT[:,:] = copy.deepcopy(np.transpose(NewX_train));

wTX = np.zeros(shape=(1,10000));
wTX[:,:] = copy.deepcopy((np.transpose(w)).dot(XT));\

x = np.zeros(shape=(1,10000));
x[:,:] = copy.deepcopy(np.transpose(X_train));

y = np.zeros(shape=(1,10000));
y[:,:] = copy.deepcopy(np.transpose(Y_train));

xplot = X_train.reshape(10000,);
yplot = Y_train.reshape(10000,);
wTXplot = np.transpose(wTX).reshape(10000,);

plt.plot(xplot, wTXplot);
plt.plot(xplot, yplot, 'go');
plt.show();

w_direct = np.zeros(shape=(2,1));
w_direct[:,:] = copy.deepcopy((np.linalg.inv(XT.dot(NewX_train))).dot(XT.dot(Y_train)));

wdTXT = np.zeros(shape=(1,10000));
wdTXT[:,:] = copy.deepcopy((np.transpose(w_direct)).dot(XT));

wdTXTplot = np.transpose(wdTXT).reshape(10000,);

plt.plot(xplot, wdTXTplot);
plt.plot(xplot, yplot,'go');
plt.show();

train_f = open("train.csv",'r')

line1 = train_f.readline()

for i in range(1,3):
	train_f.seek(len(line1))

	next_line = train_f.readline()
	
	j = 1
	
	while len(next_line) > 0:
		x_train,y_train= map(float, next_line.split(','))

		xprimeT = np.ones(shape=(1,2));
		xprimeT[:,1] = copy.deepcopy(x_train);
		
		xprime = np.zeros(shape=(2,1));
		xprime[:,:] = copy.deepcopy(np.transpose(xprimeT));
		
		eta = 0.00000001;
		
		temp = np.zeros(shape=(2,1));
		temp[:,:] = copy.deepcopy(w-eta*(np.transpose(w).dot(xprime)-y_train)*(xprime));

		w[:,:] = copy.deepcopy(temp);
		next_line = train_f.readline()
		
		#plot here
		if (j%100) == 0:
			calc = np.zeros(shape=(1,10000));
			calc[:,:] = copy.deepcopy(np.transpose(w).dot(XT));
			calcPlot = np.transpose(calc).reshape(10000,);
			plt.plot(xplot,calcPlot);
			plt.plot(xplot, yplot,'go');
			plt.pause(2);
		j += 1;

latest_wTX = np.zeros(shape=(1,10000));
latest_wTX[:,:] = copy.deepcopy((np.transpose(w)).dot(XT));

finalP = np.transpose(latest_wTX).reshape(10000,);

plt.plot(xplot, finalP);
plt.plot(xplot, yplot,'go');
plt.show();

#TestFile

test_f = np.genfromtxt('test.csv',delimiter=",");

X_test = np.zeros(shape=(1000,1));
X_test[:,0] = copy.deepcopy(test_f[1:1001,0]);

NewX_test = np.ones(shape=(1000,2));
NewX_test[:,1] = copy.deepcopy(X_test[:,0]);

Y_pred1 = np.zeros(shape=(1,1000));
Y_pred1 = copy.deepcopy(np.transpose(w).dot(np.transpose(NewX_test)));

Y_pred2 =  np.zeros(shape=(1,1000));
Y_pred2 = copy.deepcopy(np.transpose(w_direct).dot(np.transpose(NewX_test)));

Y_test = np.zeros(shape=(1000,1));
Y_test[:,0] = copy.deepcopy(test_f[1:1001,1]);

YT = np.zeros(shape=(1,1000));
YT[:,:] = copy.deepcopy(np.transpose(Y_test));

er1 = np.zeros(shape=(1,1000));
er1[:,:] = copy.deepcopy(YT-Y_pred1);

er2 = np.zeros(shape=(1,1000));
er2[:,:] = copy.deepcopy(YT-Y_pred2);

ms1 = copy.deepcopy(er1.dot(np.transpose(er1)))/1000;
ms2 = copy.deepcopy(er2.dot(np.transpose(er2)))/1000;

rms1 = math.sqrt(ms1);
rms2 = math.sqrt(ms2);

print rms1;
print rms2;
