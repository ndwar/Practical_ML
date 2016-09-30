# Practical_ML
This repository contains the R code for a for a multi-class prediction problem.
The data is from accelerometers and the goal of the project is to predict how a set of users did the exercise. 

The training set contains 160 variables with the predictor variable called 'classe'.

Solution Approach

1. The data was first pre-processed to exclude a number of fields that had NAs
2. The training set was further broken up into a validation set (70-30)
3. The resultant dataset had 59 columns
4. PCA (Principle Component Analysis) was then run on this dataset for dimensionality reduction
5. At an 85% threshold we had a workable set with 16 principle components
6. Resampling was then done using a 5 fold cross validation
7. Four models were then built on the training set - A Decision Tree, Neural Net, SVM & Random Forest
8. Each model was validated with the validation set to check for accuracy and model tuning
9. The misclassification error and accuracy for all 4 models was then compared and plotted
10. The Random Forest had the highest accuracy (97.6%) followed closely by the SVM(97.1%).
    The lower level models - DTree(61.2%) & Neural Net(73.1%) performed relatively poorly
11. The best performing model  - Random Forest was then used to score the 'Testing' data


xxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxx
