
import scipy.io
import numpy as np


#Funcion que genera los labels
def LabelGenerator (categories, instances_Per_Cat):
    
    cont = 0
    eyed = np.eye((categories))
    
    Labels = np.zeros((categories * instances_Per_Cat,3))
    
    for a in np.arange(categories):
        for b in np.arange(instances_Per_Cat):
            Labels[cont,:] = eyed[a,:]
            cont = cont+1
            
            
    return Labels


#Funcion que abre los archivos .mat
def LoadMatFiles (FilesPaths,StructNames, CAT, WIN_PER_CAT, DATA_SIZE):
    
    data = np.zeros((CAT*WIN_PER_CAT,DATA_SIZE[0],DATA_SIZE[1],1))
     
    for a,b,c in zip(FilesPaths,StructNames,range(CAT)):
        data_prov =  scipy.io.loadmat(a)
        data[c*WIN_PER_CAT:(c+1)*WIN_PER_CAT,:,:,0] = data_prov[b]       
        
    return data


#Funcion que divide los datos para evaluacion y entrenamiento
def TrainTestSplit(test_size,cat,win_per_cat):
    
    testRSize = int(np.floor(win_per_cat*test_size))
    trainRSize = int(np.ceil(win_per_cat*(1-test_size)))
    trainSet = np.zeros((3*trainRSize))
    testSet = np.zeros((3*testRSize))
    
    x = np.arange(win_per_cat).reshape(win_per_cat)
    np.random.shuffle(x)
    
    for a in np.arange(cat):           
        trainSet[trainRSize*a : trainRSize*(a+1)] = x[0:trainRSize] + win_per_cat * a
        testSet[testRSize*a: testRSize*(a+1)] = x[trainRSize:win_per_cat] + win_per_cat * a
        
    return np.array(trainSet,'int'), np.array(testSet,'int')
