
import os             
os.environ["MKL_THREADING_LAYER"] = "GNU"     #Necesario para usar Theano como backend

import numpy as np                            #Libreria para operaciones numericas con arrays
from DataFunctions import *                   #Libreria para manejar los Datasets 
from NetWorkFunctions import *                #Librería de la CNN
from NetWorkFunction2 import * 
import matplotlib.pyplot as plt               #Libreria para graficar
from keras.utils.vis_utils import plot_model  #Guardar el diseño de la CNN
from keras.models import *
from keras.layers import *
from keras.optimizers import *
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import backend as keras


#Rutas de los archivos a cargar
FilesPaths = ['.\\DataSet\\Frecuencial\\Normal.mat','.\\DataSet\\Frecuencial\\InterIctal.mat','.\\DataSet\\Frecuencial\\Ictal.mat']
StructNames = ['NormalFreq','InterFreq','IctalFreq']
CAT = 3;                                              #Número de clases
WIN_PER_CAT = 200;                                    #Casos por clase
DATA_SIZE = [10,173];                                 #Tamaño de matrices 10*173 o 5*7


#Generar los labels 
#     1 0 0 = InterIctal
#     0 1 0 = PreIctal
#     0 0 1 = Ictal
labels = LabelGenerator(CAT, WIN_PER_CAT)

#Cargar los archivos .mat
Data = LoadMatFiles(FilesPaths,StructNames, CAT, WIN_PER_CAT, DATA_SIZE)
Data[Data>200]=200
Data[Data<-200]=-200
Data = (Data-np.min(Data))/(np.max(Data)-np.min(Data)) #Normalización tipo min-max

#Train Test Split 
trainIndex, testIndex = TrainTestSplit(0.50,CAT,WIN_PER_CAT);

model = Net((DATA_SIZE[0],DATA_SIZE[1],1)) #Creación del objeto tipo CNN
#Guardar el diseño de la CNN
plot_model(model, to_file='model_plot.png', show_shapes=True, show_layer_names=True)

#Entrenamiento de la CNN
history = model.fit(Data[trainIndex,:,:,:], labels[trainIndex,:], steps_per_epoch=5, epochs=200, shuffle = True) #validation_split=0.33, validation_steps=1)

#Evaluación de la CNN
results = model.predict(Data[testIndex,:,:,:])

#Gráfica de la curva de aprendizaje
LearningRate(history.history['acc'])

#Gráfico de la matriz de confusión
np.set_printoptions(precision=2)
plot_confusion_matrix(np.array(np.argmax(labels[testIndex,:],axis=1),'int32'), np.array(np.argmax(results,axis=1),'uint8'), classes=['Normal', 'InterIctal','Ictal'],
                      title=u'Matriz de confusión (temporal)',normalize = False)

# This save the trained model weights to this file with number of epochs
model.save_weights('.\DataResults\model_weight_{}.hdf5'.format('Parametrización_50_50'))
