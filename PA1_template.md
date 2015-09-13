# Reproducible Research: Peer Assessment 1
Jim Callahan  
September 13, 2015  


```r
## Loading and preprocessing the data

#### Set the directory to the local GitHub project for this assignment.
setwd("~\\GitHub\\RepData_PeerAssessment1")

activity <- read.csv("activity.csv", na.strings = "NA", stringsAsFactors = FALSE )
activity$date <- as.Date(activity$date)

### Data is for October and November 2012 (61 days)
### In each hour there are 12 "five minute" intervals (60/5 = 12 intervals per hour)
### There are 288 five minute intervals in a 24-hour day 
### (24 hours*12 intervals per hour = 288 intervals per 24 hours day day)
### In 61 days (24 hour days) there rare 17,568 five minute intervals (61*288)
### There are 17,568 observations (records) 
### of which 2,304 (13.11%) of the "step" values are missing.

# WHAT DOES NOT MAKE SENSE:
# If there are 288 five minute intervals in a day
# and we number then 0 through 287
# and then we multiply by 5; the highest interval should be (5*287=1435).
# YET, the max interval is 2355 and even the 3rd quintile is 1766.
# plot(activity$interval) # dense rectangular plot

# ANSWER: Series jumps from "55" to "100" on the hour
head(levels(as.factor(activity$interval)), 15)
```

```
##  [1] "0"   "5"   "10"  "15"  "20"  "25"  "30"  "35"  "40"  "45"  "50" 
## [12] "55"  "100" "105" "110"
```

```r
# So, really, activity$hour should be understood as a 4 digit number
# (with leading zeros), where the first twp digits are the hour and the other two
# digits are the minute (hhmm).

# Convert the interval to HHMM by formating with leading zero.
activity$HHMM <- sprintf("%04d", as.integer(activity$interval) )
# format date
datetimestring     <- paste(activity$date, activity$HHMM)
activity$datetime  <- strptime(datetimestring, "%Y-%m-%d %H%M", tz = "")
```






## What is mean total number of steps taken per day?
 
 ```r
 PerDay <- aggregate(steps ~ date, data=activity, sum)
 mean(PerDay$steps)
 ```
 
 ```
 ## [1] 10766.19
 ```

## What is the average daily activity pattern?
![](PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?