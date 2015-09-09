# RepData-UnZip.R
# Unzip "Activity.zip data file into project directory
# Reproducible Research Course
# 09/09/2015 (Wednesday)
# Jim Callahan

# Set the directory to the local GitHub project for this assignment.
setwd("C:\\Users\\Jim/Documents\\GitHub\\RepData_PeerAssessment1")

# Unzip the data file.
unzip("~\\GitHub\\RepData_PeerAssessment1\\activity.zip", 
      overwrite = TRUE, exdir = ".", unzip = "internal", setTimes = TRUE)

## dump the first few lines of file using file.head() from the descr package
## could have used readlines() for this, but easier to remember head and file.head .
require(descr)
file.head("~\\GitHub\\RepData_PeerAssessment1\\activity.csv")

# Data file should be downloaded and unzipped; ready for next program read into R.
# End of: RepData-UnZip.R