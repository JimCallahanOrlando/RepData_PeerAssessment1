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
levels(activity$interval)

# So, really, ativity$hour should be understood as a 4 digit number
# (with leading zeros), where the first twp digits are the hour and the other two
# digits are the minute (hhmm).

# Fix the interval by formating with leading zero.
activity$interval <- as.integer(activity$interval)
activity$interval <- sprintf("%04d", activity$interval)
class(activity$interval)

# format date
datetimestring     <- paste(activity$date, activity$interval)
activity$datetime  <- strptime(datetimestring, "%Y-%m-%d %H%M", tz = "")
str(activity)

# End of: RepData-ReadActivityData.R