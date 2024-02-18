
import os             
os.environ["MKL_THREADING_LAYER"] = "GNU" #Necesario para usar Theano como backend
from keras.models import *
from keras.layers import *
from keras.optimizers import *
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras import backend as keras
from keras.utils.vis_utils import plot_model

#CNN para los parametros estadisticos
def Net2(input_size):
    
    input_1 = Input(input_size)
    conv1 = Conv2D(8, (3,3), activation = 'relu')(input_1)
    pool1 = MaxPooling2D(pool_size=(2, 2),strides = None, padding='valid')(conv1)
    conv2 = Conv2D(16, (1,1), activation = 'relu')(pool1)
    out1 = Flatten()(conv2)

    out2 = Dense(10, activation='sigmoid', use_bias=True, kernel_initializer='zeros', bias_initializer='zeros')(out1)
    out3 = Dense(3, activation='softmax', use_bias=True, kernel_initializer='zeros', bias_initializer='zeros')(out2)  
    
    model = Model(inputs = input_1, output = out3)
    model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])    
    model.summary()
    
    return model
