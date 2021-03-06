# RepData-ReadActivityData.R
# Read "Activity.csv" data file into R
# Reproducible Research Course
# 09/09/2015 (Wednesday)
# Jim Callahan

# Set the directory to the local GitHub project for this assignment.
setwd("C:\\Users\\Jim/Documents\\GitHub\\RepData_PeerAssessment1")

activity <- read.csv("activity.csv", na.strings = "NA", stringsAsFactors = FALSE )
str(activity)

sum(is.na(activity$steps))       # How many missing values?
mean(is.na(activity$steps))      # What percent missing values?

activity$date <- as.Date(activity$date)
str(activity)
summary(activity)

# Data is for October and November 2012 (61 days)
# In each hour there are 12 "five minute" intervals (60/5 = 12 intervals per hour)
# There are 288 five minute intervals in a 24-hour day 
# (24 hours*12 intervals per hour = 288 intervals per 24 hours day day)
# In 61 days (24 hour days) there rare 17,568 five minute intervals (61*288)
# There are 17,568 observations (records) 
# of which 2,304 (13.11%) of the "step" values are missing.

# WHAT DOES NOT MAKE SENSE:
# If there are 288 five minute intervals in a day
# and we number then 0 through 287
# and then we multiply by 5; the highest interval should be (5*287=1435).
# YET, the max interval is 2355 and even the 3rd quintile is 1766.
# plot(activity$interval) # dense rectangular plot

# ANSWER: Series jumps from "55" to "100" on the hour
head(levels(as.factor(activity$interval)), 15)

# So, really, activity$hour should be understood as a 4 digit number
# (with leading zeros), where the first twp digits are the hour and the other two
# digits are the minute (hhmm).

# Rewrote this section to keep original activity variable intact.

# Convert the interval to HHMM by formating with leading zero.
activity$HHMM <- sprintf("%04d", as.integer(activity$interval) )
class(activity$HHMM)

# format date
datetimestring     <- paste(activity$date, activity$HHMM)
activity$datetime  <- strptime(datetimestring, "%Y-%m-%d %H%M", tz = "")
activity$dayofweek <- weekdays(activity$datetime, abbreviate=TRUE)
activity$daytype = "Weekday"
activity$daytype[activity$dayofweek == "Sat" | activity$dayofweek == "Sun"] <- "Weekend"
str(activity)

# Convert to factors
activity$dayofweek = factor(activity$dayofweek) 
activity$daytype   = factor(activity$daytype)

table(activity$dayofweek)
table(activity$daytype)

# PER DAY
# Question 1-1: Calculate the total number of steps taken per day.
# HONOR CODE: Used example in Jared Learner's "R for Everyone" page 121 (diamonds)
PerDay <- aggregate(steps ~ date, activity, sum)

# Question 1-2: Make a histogram of the total number of steps taken each day
# Modified default hist() to break at 1,000 steps
hist(PerDay$steps, breaks=25, 
     main = paste("Histogram of Steps Per Day", 
                  "\n Mean = " , round(mean(PerDay$steps), digits=0),
                  "\n Median =", median(PerDay$steps) 
                  ) 
     )

# Question 1-3: Calculate and report the mean and median of the total number of steps taken per day
meansteps   <- mean(PerDay$steps)
mediansteps <- median(PerDay$steps)

# Only last line prints because values are so close together.
abline(v = mean(PerDay$steps), col = "Green")
abline(v = median(PerDay$steps), col = "Blue")

# PER INTERVAL
# Question 2-1: Make a time series plot (i.e. type = "l") 
# of the 5-minute interval (x-axis) and the average number of steps taken, 
# averaged across all days (y-axis)

# INTERPRETATION: This assumes you have calculated steps per five minute interval
# (in 24 hour cycle)
# PerIntervalSum     <- aggregate(steps ~ factor(HHMM), activity, sum)
PerIntervalMean    <- aggregate(steps ~ factor(HHMM), activity, mean)
PerIntervalMedian  <- aggregate(steps ~ factor(HHMM), activity, median)
ColumnNames <- c("HHMM", "steps")
# colnames(PerIntervalSum)    <- ColumnNames
colnames(PerIntervalMean)   <- ColumnNames
colnames(PerIntervalMedian) <- ColumnNames

# Not required, just curious
hist(PerIntervalMean$steps, breaks=25, 
     main = paste("Histogram of Average Steps Per Five Minute Interval", 
                  "\n Mean = " , round(mean(PerIntervalMean$steps), digits=0),
                  "\n Median =", round(median(PerIntervalMean$steps), digits=0)
     ) 
)

# Required
PerIntervalMean$timeofday    <- strptime(PerIntervalMean$HHMM, "%H%M", tz = "")
PerIntervalMedian$timeofday  <- strptime(PerIntervalMedian$HHMM, "%H%M", tz = "")

with(PerIntervalMean,
    plot(timeofday, steps, type = "l", 
        main = paste("Average Steps Per Five Minute Interval", 
             "\n Maximum = " , round(max(PerIntervalMean$steps), digits=0)
             )
        )
)



# Question 2-2: Which 5-minute interval, on average across all the days 
# in the dataset, contains the maximum number of steps?

Max5MinuteSteps <- PerIntervalMean[PerIntervalMean$steps == max(PerIntervalMean$steps), ]
# ColumnNames <- c("timeofday", "steps")
# colnames(Max5MinuteSteps) <- ColumnNames
Max5MinuteSteps


plot(PerIntervalMean$timeofday, PerIntervalMean$steps, type = "l",
          main = paste("Average Steps Per Five Minute Interval", 
                       "\n Maximum = " , round(max(PerIntervalMean$steps), digits=0),
                       "\n Maximum occurs at: ", format(Max5MinuteSteps$timeofday, "%H:%M AM")
                        )
          )

abline(h = round(max(PerIntervalMean$steps), digits=0), col = "red") 
# abline(v = Max5MinuteSteps$timeofday, col = "red") 

# Question 3-1: Calculate and report the total number of missing values 
# in the dataset (i.e. the total number of rows with NAs)

sum(is.na(activity$steps))       # How many missing values?
mean(is.na(activity$steps))      # What percent missing values?


# Question 3-2: Devise a strategy for filling in all of the missing values 
# in the dataset. The strategy does not need to be sophisticated. 
# For example, you could use the mean/median for that day, or the mean 
# for that 5-minute interval, etc.

# replace()  # may may be useful.

# activity$intervalmeansteps <- as.integer(round(PerInterval$steps, digits=0))

### Have to do in two steps (one to create per interval & second to recycle)
# PerIntervalMedian <- aggregate(steps ~ factor(HHMM), activity, median)
# PerInterval$mediansteps <-cbind(PerInterval, PerIntervalMedian$steps)
str(PerIntervalMean)
# activity$intervalmediansteps <- PerInterval$mediansteps

# max(activity$steps)
# max(activity$intervalmeansteps)
max(activity$intervalmediansteps)

# Question 3-3: Create a new dataset that is equal to the original dataset 
# but with the missing data filled in.


# Question 3-4: Make a histogram of the total number of steps taken each day and
# Calculate and report the mean and median total number of steps taken per day.
# Do these values differ from the estimates from the first part of the assignment?
# What is the impact of imputing missing data on the estimates of the total 
# daily number of steps?

# Question 4: Are there differences in activity patterns between weekdays and weekends?

# Question 4-1: Create a new factor variable in the dataset with 
# two levels – “weekday” and “weekend” indicating whether a given date is a 
# weekday or weekend day.
weekdays(as.Date("2015/9/10"), abbreviate=TRUE)

# Question 4-2: Make a panel plot containing a time series plot (i.e. type = "l") 
# of the 5-minute interval (x-axis) and the average number of steps taken,
# averaged across all weekday days or weekend days (y-axis).
# See the README file in the GitHub repository to see an example 
# of what this plot should look like using simulated data.





# End of: RepData-ReadActivityData.R