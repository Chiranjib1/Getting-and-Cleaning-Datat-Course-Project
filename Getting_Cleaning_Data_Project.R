# UCI HAR Dataset assignment to create a tidy data set

library(reshape2)

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile = "myfile.zip")
unzip("myfile.zip")


# set the working directory to UCI HAR Dataset 
setwd("UCI HAR Dataset")



# read the training data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
sub_train <- read.table("./train/subject_train.txt")

# read the test data
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
sub_test <- read.table("./test/subject_test.txt")


# merge the training and test data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
sub_data <- rbind(sub_train, sub_test)

#load features
features <- read.table("features.txt")

#load activity
activities <- read.table("activity_labels.txt")

#get features cols and names with mean and std
Cols <- grep("-(mean|std).*", as.character(features[,2]))
my_colnames <- features[Cols,2]
my_colnames <- gsub("-mean", "Mean", my_colnames)
my_colnames <- gsub("-std", "Std", my_colnames)
my_colnames <- gsub("[-()]", "", my_colnames)



#extract data by columns and using descriptive names
x_data <-x_data[Cols]
all_data <- cbind(sub_data, y_data, x_data)
colnames(all_data) <- c("Subject", "Activity", my_colnames)

all_data$Activity <-factor(all_data$Activity, levels = activities[,1], labels = activities[,2])
all_data$Subject <- as.factor(all_data$Subject)


#generate tidy data
melted_data <- melt(all_data, id = c("Subject", "Activity"))
tidy_data <- dcast(melted_data, Subject + Activity ~ variable, mean)

write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)

# go one level up from UCI HAR Dataset directory which was the starting directory
setwd("./..")


