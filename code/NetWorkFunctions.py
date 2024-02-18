
import os             
os.environ["MKL_THREADING_LAYER"] = "GNU" #Necesario para usar Theano como backend
from keras.models import *
from keras.layers import *
from keras.optimizers import *
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import backend as keras
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
from keras.utils.vis_utils import plot_model


#CNN para el analisis temporal, power spectrum y transformada Wavelet
def Net(input_size):
    
    input_1 = Input(input_size)
    conv1 = Conv2D(8, (5,5), activation = 'relu')(input_1)
    pool1 = MaxPooling2D(pool_size=(2, 2),strides = None, padding='valid')(conv1)
    conv2 = Conv2D(16, (3,3), activation = 'relu')(pool1)
    out1 = Flatten()(conv2)
    
    out2 = Dense(100, activation='sigmoid', use_bias=True, kernel_initializer='zeros', bias_initializer='zeros')(out1)
    out3 = Dense(3, activation='softmax', use_bias=True, kernel_initializer='zeros', bias_initializer='zeros')(out2)  
    
    model = Model(inputs = input_1, output = out3)
    model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])    
    model.summary()
    
    return model

#Funcion que grafica la matriz de confusion
def plot_confusion_matrix(y_true, y_pred, classes,
                          normalize=False,
                          title='Default',
                          cmap=plt.cm.YlOrRd):

    cm = confusion_matrix(y_true, y_pred)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print(u'Matriz de confusión normalizada')
    else:
        print(u'Matriz de confusión, sin normalización')

    print(cm)

    fig, ax = plt.subplots()
    im = ax.imshow(cm, interpolation='nearest', cmap=cmap)
    ax.figure.colorbar(im, ax=ax, label=u'Número de casos')
    # We want to show all ticks...
    ax.set(xticks=np.arange(cm.shape[1]),
           yticks=np.arange(cm.shape[0]),
           # ... and label them with the respective list entries
           xticklabels=classes, yticklabels=classes,
           title=title,
           ylabel='Verdadero',
           xlabel=u'Predicción')

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
             rotation_mode="anchor")

    # Loop over data dimensions and create text annotations.
    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i in range(cm.shape[0]):
        for j in range(cm.shape[1]):
            ax.text(j, i, format(cm[i, j], fmt),
                    ha="center", va="center",
                    color="white" if cm[i, j] > thresh else "black")
    fig.tight_layout()
    return ax
    
#Funcion que grafica la curva de aprendizaje
def LearningRate(data_train):
    
    fig = plt.figure(figsize=(10,5))
    ax = fig.add_subplot(111)
    ax.set_title
    plt.plot(data_train,'r')
    ax.set_title(u'Curva de aprendizaje (temporal)',fontsize=17)
    ax.set_ylabel('Exactitud', fontsize=14)
    ax.set_xlabel(u'Época', fontsize=14)
    ax.grid(True)
    plt.show()
