## Comparative study of EEG signal classification algorithms: application to epilepsy

Matlab and Python code used for the final bachelor's project.
Code files include data analysis, model training and visualization.

* ### Summary of the project

The objective of this project was to carry out a comparative study to establish the most appropriate method for the classification of no ictal EEG signals (from healthy patients), interictal, and ictal. These signals were obtained from Univerisity of Bonn dataset [1].

The methods that were compared were raw signal analysis, power spectral density, Wavelet transform, and extraction of statistical parameters. 50% of the dataset was used to train a convolutional neural network. Later, the model was evaluated using the rest of the dataset.

* ### References


1. R.G. Andrzejak, K. Lehnertz, C. Rieke, F. Mormann, P. David, C.E. Elger, “Indications of
nonlinear deterministic and finite dimensional structures in time series of brain electrical
activity: Dependence on recording region and brain state”, Phys. Rev. E, 2001, 64, 061907.