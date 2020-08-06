cc <- rep.int(16, 561)

test <- read.fwf(file = 'Dataset/test/X_test.txt', widths = cc)
train <- read.fwf(file = 'Dataset/train/X_train.txt', widths = cc)

featrue <- readLines('Dataset/features.txt')
subjectTrain <- readLines("Dataset/train/subject_train.txt")
subjectTest <- readLines("Dataset/test/subject_test.txt")
ytrain <- readLines("Dataset/train/y_train.txt")
ytest <- readLines("Dataset/test/y_test.txt")

testc <-test[,grepl(pattern = '[^ ].+(mean()|std())[^ ].+', featrue)]
trainc <-train[,grepl(pattern = '[^ ].+(mean()|std())[^ ].+', featrue)]

featrueSplit <- strsplit(featrue, split = " ")
funtn <- function(x){
        x[2]
}
fsplit <- sapply(featrueSplit, funtn)

names(testc) <- grep(pattern = '[^ ].+(mean()|std())[^ ].+', fsplit, value = TRUE)
names(trainc) <- grep(pattern = '[^ ].+(mean()|std())[^ ].+', fsplit, value = TRUE)

testc1 <- cbind(subjectTest, ytest, testc)
trainc1 <- cbind(subjectTrain, ytrain, trainc)
names(testc1)[c(1,2)] <- c("subject", "activity")
names(trainc1)[c(1,2)] <- c("subject", "activity")

library(data.table)
library(dplyr)
library(tidyr)
actlabl <- readLines('Dataset/activity_labels.txt')
actsplit <- strsplit(actlabl, split = " ")
actlab <- sapply(actsplit, funtn)

for (i in seq(1,6)) {
        testc1[grepl(pattern = i, testc1[,2]),2] <- actlab[i]
        trainc1[grepl(pattern = i, trainc1[,2]),2] <- actlab[i]
}
mix <- rbind(trainc1, testc1)

mixby <- mix %>% group_by(subject, activity) %>% summarise_all(mean)
write.csv(mixby, file = "TidyData.csv", quote = FALSE)
