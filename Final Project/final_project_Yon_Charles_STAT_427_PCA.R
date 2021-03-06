## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---------------------------------------------------------------------------------------------------------------------------------------
library(boot)
set.seed(13)
cancer= read.csv("breast_cancer_scikit_label_dataset_all_values.csv")
attach(cancer)

glm.fits=glm(class_use~mitosis+normal_nucleoli+bland_chromatin+bare_nuclei+single_epithelial_cell_size+marginal_adhesion+uniformity_of_cell_shape+uniformity_of_cell_size+clump_thickness , data=cancer ,family=binomial)
summary(glm.fits)
cv.err=cv.glm(cancer,glm.fits,K=10)$delta[1]
cv.err

glm.probs=predict(glm.fits,type="response")
glm.pred=rep("0",554)
glm.pred[glm.probs >0.5]="1"
table(glm.pred,class_use)
mean(glm.pred==class_use)

step(glm.fits)
#library(MASS)
#stepAIC(glm.fits,direction = "both")

glm.fits2=glm(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness , data=cancer ,family=binomial)
summary(glm.fits2)
cv.err1=cv.glm(cancer,glm.fits2,K=10)$delta[1]
cv.err1

glm.probs2=predict(glm.fits2,type="response")
glm.pred2=rep("0",554)
glm.pred2[glm.probs2 >0.5]="1"
table(glm.pred2,class_use)
mean(glm.pred2==class_use)



## ---------------------------------------------------------------------------------------------------------------------------------------
TPR =rep(0,100)
FPR =rep(0,100)
for (k in 1:100){
glm.fits1=glm(class_use~mitosis+normal_nucleoli+bland_chromatin+bare_nuclei+single_epithelial_cell_size+marginal_adhesion+uniformity_of_cell_shape+uniformity_of_cell_size+clump_thickness , data=cancer ,family=binomial)
glm.probs1=predict(glm.fits1,cancer,type="response")
Yhat =(glm.probs1 >k/100)
TPR[k]= sum(Yhat==1 & class_use=="0") /sum(class_use=="0")
FPR[k]= sum(Yhat==1 & class_use=="1") /sum(class_use=="1")
}

plot(FPR,TPR, xlab = "False positive rate", ylab= "True positive rate", main= "ROC curve")
lines(FPR,TPR)



TPR =rep(0,100)
FPR =rep(0,100)
for (k in 1:100){
glm.fits2=glm(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness , data=cancer ,family=binomial)
glm.probs2=predict(glm.fits2,cancer,type="response")
Yhat =(glm.probs2 >k/100)
TPR[k]= sum(Yhat==1 & class_use=="0") /sum(class_use=="0")
FPR[k]= sum(Yhat==1 & class_use=="1") /sum(class_use=="1")
}

plot(FPR,TPR, xlab = "False positive rate", ylab= "True positive rate", main= "ROC curve")
lines(FPR,TPR)

## ---------------------------------------------------------------------------------------------------------------------------------------
library(caret)
set.seed(30)
cancer$class_use = as.factor(cancer$class_use)

index = createDataPartition(y=cancer$class_use, p=0.75, list=FALSE)

train = cancer[index,]
test = cancer[-index,]



## ---------------------------------------------------------------------------------------------------------------------------------------
set.seed(24)
trControl <- trainControl(method  = "cv",
                          number  = 5)

knnfit <- train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + 
    bare_nuclei + single_epithelial_cell_size + marginal_adhesion + 
    uniformity_of_cell_shape + uniformity_of_cell_size + clump_thickness,
             method     = "knn",
             tuneGrid   = expand.grid(k = 1:30),
             trControl  = trControl,
             metric     = "Accuracy",
             data       = train)

knnfit

pred.class8 = predict(knnfit, test)
table(pred.class8, test$class_use)

mean(pred.class8 == test$class_use)

knnfit1 <- train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness,
             method     = "knn",
             tuneGrid   = expand.grid(k = 1:30),
             trControl  = trControl,
             metric     = "Accuracy",
             data       = train)

knnfit1

pred.class9 = predict(knnfit1, test)
table(pred.class9, test$class_use)

mean(pred.class9 == test$class_use)


## ---------------------------------------------------------------------------------------------------------------------------------------
set.seed(23)
ldafit <-train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + 
    bare_nuclei + single_epithelial_cell_size + marginal_adhesion + 
    uniformity_of_cell_shape + uniformity_of_cell_size + clump_thickness,
             method     = "lda",
             trControl  = trControl,
             data=train)
ldafit

pred.class = predict(ldafit, test)
table(pred.class, test$class_use)

mean(pred.class == test$class_use)
confusionMatrix(pred.class, test$class_use )
ldafit1 <-train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness,
             method     = "lda",
             trControl  = trControl,
             data=train)
ldafit1

pred.class1 = predict(ldafit1, test)
table(pred.class1, test$class_use)

mean(pred.class1 == test$class_use)

confusionMatrix(pred.class1, test$class_use )




## ---------------------------------------------------------------------------------------------------------------------------------------
set.seed(23)
qdafit <-train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + 
    bare_nuclei + single_epithelial_cell_size + marginal_adhesion + 
    uniformity_of_cell_shape + uniformity_of_cell_size + clump_thickness,
             method     = "qda",
             trControl  = trControl,
             data=train)
qdafit

pred.class1 = predict(qdafit, test)
table(pred.class1, test$class_use)

mean(pred.class1 == test$class_use)
confusionMatrix(pred.class1, test$class_use )
qdafit1 <-train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness,
             method     = "qda",
             trControl  = trControl,
             data=train)
qdafit1

pred.class2 = predict(qdafit1, test)
table(pred.class2, test$class_use)

mean(pred.class2 == test$class_use)
confusionMatrix(pred.class2, test$class_use )


## ---------------------------------------------------------------------------------------------------------------------------------------
log_fit <- train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + 
    bare_nuclei + single_epithelial_cell_size + marginal_adhesion + 
    uniformity_of_cell_shape + uniformity_of_cell_size + clump_thickness,  data=train, method="glm", family="binomial",  trControl  = trControl)

log_fit

pred.class3 = predict(log_fit, test)
table(pred.class3, test$class_use)

mean(pred.class3 == test$class_use)
confusionMatrix(pred.class3, test$class_use )
log_fit1 <- train(class_use ~ mitosis + normal_nucleoli + bland_chromatin + bare_nuclei + 
    marginal_adhesion + uniformity_of_cell_shape + clump_thickness,  data=train, method="glm", family="binomial",  trControl  = trControl)

log_fit1

pred.class4 = predict(log_fit1, test)
table(pred.class4, test$class_use)

mean(pred.class4 == test$class_use)
confusionMatrix(pred.class4, test$class_use )


## ---------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
# keep only predictor variables
sub.cancer <- dplyr::select(cancer, mitosis,normal_nucleoli,bland_chromatin,bare_nuclei,single_epithelial_cell_size,marginal_adhesion,uniformity_of_cell_shape,uniformity_of_cell_size,clump_thickness)
# use the prcomp() function from the base stats library
cancer.pc <- prcomp(sub.cancer, center = TRUE,scale. = TRUE)
X<-as.data.frame(cancer.pc[["x"]])
PC<-cbind(cancer$class_use,X)
names(PC)[1] = "class_use"
cov = round(cancer.pc$sdev^2/sum(cancer.pc$sdev^2)*100, 2)
cov = data.frame(c(1:9),cov)
names(cov)[1] = 'PCs'
names(cov)[2] = 'Variance'
cov
ggplot(cov, aes(x=PCs, y=Variance)) +
    geom_point()

glm.pca=glm(class_use~PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9 , data=X ,family=binomial)
summary(glm.pca)


glm.probs.pca=predict(glm.pca,type="response")
glm.pred.pca=rep("0",554)
glm.pred.pca[glm.probs.pca >0.5]="1"
table(glm.pred.pca,class_use)
mean(glm.pred.pca==class_use)





