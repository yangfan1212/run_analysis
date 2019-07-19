 train.x <- read.table("./train/X_train.txt")
 train.y <- read.table("./train/y_train.txt")
 train.subject <- read.table("./train/subject_train.txt")
 test.x <- read.table("./test/X_test.txt")
 test.y <- read.table("./test/y_test.txt")
 test.subject <- read.table("./test/subject_test.txt")
# all above is about loading the datas into R

 trainData <- cbind(train.subject, train.y, train.x)
 testData <- cbind(test.subject, test.y, test.x)
 fullData <- rbind(trainData, testData)
# merging tables

 featureN <- read.table("./features.txt", stringsAsFactors = FALSE)[,2]
#only one measurement

 featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureN)
 finalData <- fullData[, c(1, 2, featureIndex+2)]
 colnames(finalData) <- c("subject", "activity", featureN[featureIndex])
#mean and sd

 activityN <- read.table("./activity_labels.txt")
 finalData$activity <- factor(finalData$activity, levels = activityN[,1], labels = activityN[,2])
 names(finalData) <- gsub("\\()", "", names(finalData))
 names(finalData) <- gsub("^t", "time", names(finalData))
 names(finalData) <- gsub("^f", "frequence", names(finalData))
 names(finalData) <- gsub("-mean", "Mean", names(finalData))
 names(finalData) <- gsub("-std", "Std", names(finalData))
# make labels

 library(dplyr)
 groupData <- finalData %>%
 group_by(subject, activity) %>%
 summarise_each(funs(mean))

write.table(groupData,"./MeanData.txt",row.names = FALSE)

## write the table