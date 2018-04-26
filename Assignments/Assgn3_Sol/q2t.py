import numpy as np 
import copy
import matplotlib.pyplot as plt

read = np.genfromtxt('train.csv',delimiter=",")

X_train = np.zeros(shape=(10000,1));
X_train[:,0]=copy.deepcopy(read[1:10001,0]);


NewX_train = np.ones(shape=(10000,2));
NewX_train[:,1]=copy.deepcopy(X_train[:,0])

w = np.random.rand(2,1);

Y_train = np.zeros(shape=(10000,1));
Y_train[:,0]=copy.deepcopy(read[1:10001,1]);

XT=np.zeros(shape=(2,10000));
XT[:,:]=copy.deepcopy(np.transpose(NewX_train));

wTX=np.zeros(shape=(1,10000))
wTX[:,:]=copy.deepcopy((np.transpose(w)).dot(XT));

x=np.zeros(shape=(1,10000))
x[:,:]=copy.deepcopy(np.transpose(X_train))
y=np.zeros(shape=(1,10000))
y[:,:]=copy.deepcopy(np.transpose(Y_train))


plt.plot(x, wTX,'bo',x, y,'go')
plt.show()	

w_direct=np.zeros(shape=(2,1))
w_direct[:,:]=copy.deepcopy((np.linalg.inv(XT.dot(NewX_train))).dot(XT.dot(Y_train)));

wdTXT=np.zeros(shape=(1,10000))
wdTXT[:,:]=copy.deepcopy((np.transpose(w_direct)).dot(XT));

#plt.plot(x, wdTXT,'bo',x, y,'go')
plt.plot(x, wdTXT, 'bo')
plt.show()

plt.plot(x, y, 'go')
plt.show()
