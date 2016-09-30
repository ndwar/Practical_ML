###Loading required packages & Datasets
library(RANN)
library(caret)
library(rattle)
training<-read.csv("pml-training.csv")
testing<-read.csv("pml-testing.csv")

str(training)

###Preprocessing Training data (Cleaning NAs, Retaining Non Zero Variables)
training[training=="NA"]<-NA
head(training)
training[training==""]<-NA
head(training)
str(training)


Kurt <- grep("^kurtosis.*", names(training))
Skew <- grep("^skewness.*", names(training))
Max <-grep("^max.*", names(training))
Min<-grep("^min.*", names(training))
Amp<-grep("^amplitude.*", names(training))
Var<-grep("^var.*", names(training))
Avg<-grep("^avg.*", names(training))
Std<-grep("^stddev.*", names(training))
training2<-(training[,-c(Kurt,Skew, Max, Min, Amp, Var, Avg, Std)])
training2<-training2[,-1] #removing serial number

###Splitting data for training & validation
set.seed(1010) 
splitset <- createDataPartition(training2$classe, p = 0.7, list = FALSE)
trainset <- training2[splitset, ]
validationset <- training2[-splitset, ]
str(trainset)
str(validationset)

trainset2<-preProcess(trainset[,-59], method = "pca", thresh = 0.85)
trainset3<-predict(trainset2, trainset)

###5 Fold Cross Validation
control <- trainControl(method = "cv", number = 5)

###Decision Tree
modrpart <- train(classe ~ ., data = trainset3, method = "rpart", trControl = control)
print(modrpart)

##Plotting Decision Tree
fancyRpartPlot(modrpart$finalModel)

validationsetpc<-predict(trainset2,validationset)
predictrpart<-predict(modrpart, validationsetpc)
accuracyrpart<-confusionMatrix(validationsetpc$classe,predictrpart)
accuracyrpart

###Neural Network
modnnet<-train(classe ~ ., method = "nnet", data = trainset3, trControl = control)
print(modnnet)

predictnnet<-predict(modnnet, validationsetpc)
accuracynnet<-confusionMatrix(validationsetpc$classe, predictnnet)
accuracynnet

###Random Forest

modrf<-train(classe ~ ., method = "rf", prox = TRUE, data = trainset3, trControl = control)
print(modrf)

predictrf<-predict(modrf, validationsetpc)
accuracyrf<-confusionMatrix(validationsetpc$classe, predictrf)
accuracyrf

###SVM
modsvm<-train(classe~., method = "svmRadial", tuneLength = 9, trControl = control, data= trainset3)
print(modsvm)

predictsvm<-predict(modsvm, validationsetpc)
accuracysvm<-confusionMatrix(validationsetpc$classe, predictsvm)
accuracysvm

###Comparing Models
compare <- resamples(list(DTree=modrpart, NeuralNet=modnnet, RandomForest=modrf, SVM=modsvm))
#Summarize Distributions
summary(compare)
#Visualize Results
bwplot(compare)

###Preprocessing Test Set
testing1<-(testing[,-c(Kurt,Skew, Max, Min, Amp, Var, Avg, Std)])
testing1<-testing1[,-1] #removing serial number

###Scoring Test Set
testingpc<-predict(trainset2, testing1)
predict(modrf, testingpc)

########################End#############


