# Coursera Reproducible Research - Assessment 2
TechnoPhobe01  
March 8, 2015  



# Report Analysis of [NOAA][1] Storm Database and Weather Events
*Author:* Technophobe
*Date:* "March 8, 2015"

## Synopsis
In this report we aim to describe the impact of severe weather events in the United States between the years 1950 to 2011. This analysis is intended to address the following questions:

  - Across the United States, which types of events (as indicated in the eventType variable) are most harmful with respect to population health?
- Across the United States, which types of events have the greatest economic consequences?

To investigate and answer these questions and validate our hypothesis, we obtained the Storm and Weather events database from the National Oceanic and Atmospheric Administration ([NOAA][1])  which is collected from various sources across the U.S. We specifically obtained data for the years 1950 and 2011.

Note: Additional documentation is avaialble from NOOA that explains how the data has been obtained, and what and how the variables are defined and constructed.

- [NOAA Event Database Website][2]
- [National Weather Service Storm Data Documentation][3]
- [National Climatic Data Center Storm Events FAQ][4]

Please refer to the **Storm Data Overview** and **Results** sections for a review of how the data is structureed, subsequently cleaned and interpreted.

# Data Processing

The intent of the data processing section is to describe and capture our approach to cleaning the data. We first setup the environment and load the relevant libraries. Once this is complete we move to describe the data and the steps we undertook to clean and validate the data set.

## Setup environment

The first step is to load the required R packages


```
## Loading required package: rmarkdown
## Loading required package: knitr
## Loading required package: R.utils
## Loading required package: R.oo
## Loading required package: R.methodsS3
## R.methodsS3 v1.7.0 (2015-02-19) successfully loaded. See ?R.methodsS3 for help.
## R.oo v1.19.0 (2015-02-27) successfully loaded. See ?R.oo for help.
## 
## Attaching package: 'R.oo'
## 
## The following objects are masked from 'package:methods':
## 
##     getClasses, getMethods
## 
## The following objects are masked from 'package:base':
## 
##     attach, detach, gc, load, save
## 
## R.utils v2.1.0 (2015-05-27) successfully loaded. See ?R.utils for help.
## 
## Attaching package: 'R.utils'
## 
## The following object is masked from 'package:utils':
## 
##     timestamp
## 
## The following objects are masked from 'package:base':
## 
##     cat, commandArgs, getOption, inherits, isOpen, parse, warnings
## 
## Loading required package: lubridate
## Loading required package: ggplot2
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:lubridate':
## 
##     intersect, setdiff, union
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
## 
## Loading required package: scales
## Loading required package: reshape2
## Loading required package: gridExtra
## Loading required package: ggthemes
## Loading required package: xtable
```
### Download and load the storm data

We download and extract the target zip file into the **./data** sub-directory, that we create if it does not exist. We then load the data into a data frame in preparation for manipulation.

**Note:** This program assumes that all the data will be downloaded into the 'data' directory below the working directory.

The data for this assignment is downloaded from the course [web site][5]:

  - **Dataset**: [Storm Data [**47Mb**]][6]


```r
dataDir         <- "./data"
fileUrl         <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
fileName        <- "storm.csv"                  # Extracted File Name
filePath        <- file.path(dataDir, fileName) # Filepath to extracted file

# If the data dir does not exist we create it, so it can be used to store the
# downloaded data

if (!file.exists(dataDir)) {
  dir.create(dataDir)
}

# Now we download the bz2 zip file... and extract it...

if (!file.exists(filePath)) {
  temp <- tempfile()
  download.file(fileUrl, temp, mode = "wb", method = "curl")
  bunzip2(temp, filePath, overwrite = TRUE)
  unlink(temp)
}

# Load the dataset in preperation for manipulation...

rawStormData  <- read.csv(filePath)     # Load the raw data...
stormData <- rawStormData               # Create a working copy of the data...
```

## Storm Data Overview

Due to changes in the data collection and processing procedures over time, there are unique periods of record available depending on the event type. The [NOAA Event Database Website][2] details the timeline and different time spans for each period of unique data collection and processing procedures.

- **1950 - 1993** - Prior to 1993, the records are extracted from the manually typed Storm Data Publication.
- **1993 to the present** - built from the digital records in the database.
- **Paradox Database Files**: Beginning in January 1996, the NWS began using Storm Data for forecast verification purposes and the NWS decided to collect the data at the NWS Headquarters in Silver Spring, MD. They selected Borland/Corel Paradox format for their database and supplied the NCDC with the raw data files, which were then used for the Storm Data publication and inclusion into the Storm Events Database. **From 1996-1999, the event type field was a free-text field so there were many, many variations of event types. Most of the events were standardized into the 48 current event types**. In 2000 the NWS added a drop-down selector for Event Type on the data entry interface, which standardized the Event Type values sent to NCDC.
- **Comma-Separated Text (CSV) Files**: In October 2006, the NWS switched from Paradox to Windows SQL Server and it was decided that the NWS would supply NCDC with comma separated (CSV) text files that NCDC would import into their own database for the Storm Data publication and Storm Events Database.

### Data

The principle variables we are interested within the data set are:

1. BGN_DATE: Date event started
1. EVTYPE: Event Type   
   2.1. **Note:** There are 48 event types defined post 2000
1. FATALITIES: Number of fatalities
1. INJURIES: Number of injuries
1. PROPDMG: Property damage estimates, entered as $ dollar amount.
1. PROPDMGEXP: Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)
1. CROPDMG: Crop damage estimates, entered as $ dollar amounts
1. CROPDMGEXP: Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)

#### Event Type

The [NOAA Event Database Website][2] specifies **48 Event types**, however as discussed the raw data contans the pre-2000 open text field data. After 2000 the data event names are uniform and align with the table below.

Event Name               | Event Name               | Event Name         | Event Name
-------------------------|--------------------------|--------------------|-----------
Astronomical Low Tide    | Hurricane (Typhoon)      | Avalanche          | Ice Storm
Blizzard                 | Lake-Effect Snow         | Coastal Flood      | Lakeshore Flood
Cold/Wind Chill          | Lightning                | Debris Flow        | Marine Hail
Dense Fog                | Marine High Wind         | Dust Devil         | Marine Strong Wind
Drought                  | Marine Thunderstorm Wind | Excessive Heat     | Rip Current
Dust Storm               | Seiche                   | Flash Flood        | Sleet
Extreme Cold/Wind Chill  | Storm Surge/Tide         | Frost/Freeze       | Strong Wind
Flood                    | Thunderstorm Wind        | Freezing Fog       | Tornado
Funnel Cloud             | Tropical Depression      | Heat               | Tropical Storm
Hail                     | Tsunami                  | Hail               | Volcanic Ash
Heavy Rain               | Waterspout               | Heavy Snow         | Wildfire
High Surf                | Winter Storm             | High Wind          | Winter Weather

## Raw Data - Processing

The actual raw data as downloaded has a number of issues we have to address.

In terms of actual clean up work the intent is to do this in an orderly manner workign through the fields we have identified, and self checking our approach.

1. BGN_DATE: Date event started
1. EVTYPE: Event Type
2.1. **Note:** There are 48 event types defined post 2000
1. FATALITIES: Number of fatalities
1. INJURIES: Number of injuries
1. PROPDMG: Property damage estimates, entered as $ dollar amount.
1. PROPDMGEXP: Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)
1. CROPDMG: Crop damage estimates, entered as $ dollar amounts
1. CROPDMGEXP: Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)

## BGN_DATE

The first issue we have to address with the raw data is the date format of **BGN_DATE**. The event begin date is specified as a text string. We use a combination of **dplyr** and **lubridate** to create two new columns **eventBeginDate** and **eventBeginYear** (*derived from eventBeginDate*)

Column Name        | Format             | Type
-------------------|--------------------|------
  BGN_DATE:          | MM/DD/YYYY H:MM:SS | Character String
eventBeginDate:    | YYYY/MM/DD         | POSIXct Date
eventBeginYear:    | YYYY               | Factor


```r
stormData <- mutate(stormData, eventBeginDate = mdy_hms(BGN_DATE,tz=Sys.timezone()))
stormData <- mutate(stormData, eventBeginYear = year(eventBeginDate))
```

### EVTYPE

The next step is to consider `EVTYPE`, the Event Type was standardised in 2000, however prior to this date it was a free text field. A bief check confirms that problems likely exist with the raw data. If we count the number of unique event types we see **985** unique `EVTYPE` values across the raw dataset, where we would hope for **48** values...


```r
length(unique(stormData$EVTYPE))
```

```
## [1] 985
```

#### EVTYPE Clean Up

To address the issues with EVTYPE we initially decided to take the the approach of converting all the entries to be a factor that maps to one of the 48 types defined after 2000.  To do this we originally planned to subset the data, before 2000 we would need to clean it up, after 2000 we would want to leave it alone... The basic apprach being to convert EVTYPE data to be in character format, execute a regular expression across the dataset and replace all matches with the EVTYPE replacement value. Once complete we would create a new column, copy, convert and assign the data to the new column. We would then check we have < 48 values.

It turns out that the post 2000 data also appears to have issues up until 2007. After 2007 we see 48 factors, but we see have **985 factor levels**. On top of this for example we see that in 1996 the EVTYPE was used to add summaries of events using free text...

The situation requires that we take an alternate approach. We create a set of well defined buckets and aggregate the eventTypes against this. i.e. For every entry we find "hail" in we replace with "HAIL", to do this we use grepl(). Essentially we define a bucketlist (eventFactorName), and matching regular expression list (eventRegex). We use these lists to perform a iteractive search across the evData. Once complete we convert eventType values to be factors. The final step is to extract all the rows that match our factor list and use that as the dataset.


```r
eventFactorName <- c("AVALANCHE","BLIZZARD","COLD","DUST","FIRE","FREEZING","FLOOD",
                     "HAIL","HEAT","HURRICANE","LIGHTNING","RAIN","RAIN","SNOW","STORM SURGE","THUNDERSTORM",
                     "THUNDERSTORM", "TORNADO","TROPICALSTORM","WIND")

eventRegex <- c("avalanche", "blizzard", "cold", "dust*", "fire", "freez*", "flood",
                "hail", "heat", "hurricane", "lightn", "rain", "precip", "snow", "storm surge", "thu*.*orm",
                "tstm", "tornad", "tropical.*", "wind")

eventType <- data.frame(eventFactorName,eventRegex)
eventType
```

```
##    eventFactorName  eventRegex
## 1        AVALANCHE   avalanche
## 2         BLIZZARD    blizzard
## 3             COLD        cold
## 4             DUST       dust*
## 5             FIRE        fire
## 6         FREEZING      freez*
## 7            FLOOD       flood
## 8             HAIL        hail
## 9             HEAT        heat
## 10       HURRICANE   hurricane
## 11       LIGHTNING      lightn
## 12            RAIN        rain
## 13            RAIN      precip
## 14            SNOW        snow
## 15     STORM SURGE storm surge
## 16    THUNDERSTORM   thu*.*orm
## 17    THUNDERSTORM        tstm
## 18         TORNADO      tornad
## 19   TROPICALSTORM  tropical.*
## 20            WIND        wind
```

```r
stormData$EVTYPE <- as.character(stormData$EVTYPE) # Convert EVTYPE to a Text Field...
for (i in 1:length(eventFactorName))
{
  # Search for eventRegex string - on match replace with eventFactorName
  stormData$eventType[grepl(eventRegex[i],
                            stormData$EVTYPE,
                            ignore.case = TRUE)] <- eventFactorName[i]
}
stormData$eventType <- as.factor(stormData$eventType) # Convert eventType to be a factor

# Remove all values that are not a defined factor
stormData <- filter(stormData, !is.na(eventType))
```
We can see that we loose some data through this process

Raw stormData:

  - 902297, 37

Cleaned stormData

  - 857824, 40

  - **BGN_DATE** is replaced by **eventBeginDate** *and* **eventBeginYear**

  - **EVTYPE** is replaced by **eventType**

This process results in a dataset of 18 event types as detailed in the following table:


```r
levels(stormData$eventType)
```

```
##  [1] "AVALANCHE"     "BLIZZARD"      "COLD"          "DUST"         
##  [5] "FIRE"          "FLOOD"         "FREEZING"      "HAIL"         
##  [9] "HEAT"          "HURRICANE"     "LIGHTNING"     "RAIN"         
## [13] "SNOW"          "STORM SURGE"   "THUNDERSTORM"  "TORNADO"      
## [17] "TROPICALSTORM" "WIND"
```

### FATALITIES: Cleanup

Fatalities is a numeric value hence we want to check for and remove any negative values. Here we replace negative values by 0. We also check for any very large values.


```r
stormData$FATALITIES[stormData$FATALITIES<0] <- 0
unique(stormData$FATALITIES)
```

```
##  [1]   0   1   4   6   7   2   5  25   3  10  14   9  11  23  22  21  50
## [18]  29  34  17   8  18  24  33  31  20  13  75  15  16  90 116  12  38
## [35]  57  30  37  36 114  26  42  27 583  67  19  32  99  74  49  46  44
## [52] 158
```
### INJURIES: Cleanup

Injuries is a numeric value hence we want to check for and remove any negative values. Here we replace negative values by 0. We also check for any very large values.


```r
stormData$INJURIES[stormData$INJURIES<0] <- 0
unique(stormData$INJURIES)
```

```
##   [1]   15    0    2    6    1   14    3   26   12   50    8  195    4   20
##  [15]    5  200   90   35    7   10   17   18   22   11   25   27   24   88
##  [29]    9   19   72   44   47   63   42   60   56   41   29  110  102   80
##  [43]   36  250   49  130   30   13   62   23   51   37   16  463   28   40
##  [57]  325  180   39   57  270  350  257  112   64   76  100   52   45  500
##  [71]   77  450   21   53   94   33   75  300   65  152   34   55   31  115
##  [85]  410   97   69   32  181   58  252  560  275   38  175   73  138  172
##  [99]  156   43   91  177   59  150   70  225   85  165  266 1228   68  785
## [113]  116  224  142   79   87  108  504  140   78  123  192  342  411  154
## [127]   98  176  170  216  101  118  280   74  153  105  103  207  240 1150
## [141]  190   46   81  135   95  120   82  166  137  159  597  111   67 1700
## [155]  121   54   89  385  230  185  129   48  109  246  258  145   96  122
## [169]   83  143  600  800  550  125  750  119  241  397  160  293  234  106
## [183]  144   61   71  316   93   66  780   92  104  215  437  306  519  136
## [197]  700  223  210
```
### PROPDMG / PROPDMGEXP

Property damage is calculated based off two columns, the first column **PROPDMG** defines the property damage estimates, entered as $ dollar amount. The second column defines an alphabetic exponent code **PROPDMGEXP** to signify magnitude “K” for thousands, “M” for millions, and “B” for billions). Our approach here is to remove any negative values from the PROPDMG column, and to reformat **PROPDMGEXP** to only contains values of "B","M","K" or 0. i.e Billions, Millions, Thousands or 0.


```r
(stormData$PROPDMG[stormData$PROPDMG<0] <- 0)
```

```
## [1] 0
```

```r
# Lets count the frequency of the values in stormData$PROPDMGEXP to see what the
# data quality is like.
stormData %>% group_by(PROPDMGEXP) %>% summarise(count=n())
```

```
## Source: local data frame [19 x 2]
## 
##    PROPDMGEXP  count
## 1             445422
## 2           -      1
## 3           ?      8
## 4           +      5
## 5           0    213
## 6           1     25
## 7           2     13
## 8           3      4
## 9           4      4
## 10          5     28
## 11          6      4
## 12          7      5
## 13          8      1
## 14          B     39
## 15          h      1
## 16          H      6
## 17          K 401115
## 18          m      7
## 19          M  10923
```

```r
# Our objective is to clean up the data by first replacing all instances of
# "k","m","b" by "K", "M", "B"...
stormData$PROPDMGEXP <- as.character(stormData$PROPDMGEXP)
stormData$PROPDMGEXP[grepl("k", stormData$PROPDMGEXP, ignore.case = TRUE)] <- "K"
stormData$PROPDMGEXP[grepl("m", stormData$PROPDMGEXP, ignore.case = TRUE)] <- "M"
stormData$PROPDMGEXP[grepl("b", stormData$PROPDMGEXP, ignore.case = TRUE)] <- "B"

# OK, we now remove any value that is not "K", "M", "B" and replace with "0"
stormData$PROPDMGEXP[!grepl("[kmb]", stormData$PROPDMGEXP, ignore.case = TRUE)] <- "0"
stormData$PROPDMGEXP <- as.factor(stormData$PROPDMGEXP)

# Result Cleaned Dataset...
stormData %>% group_by(PROPDMGEXP) %>% summarise(count=n())
```

```
## Source: local data frame [4 x 2]
## 
##   PROPDMGEXP  count
## 1          0 445740
## 2          B     39
## 3          K 401115
## 4          M  10930
```


```r
# Ok, now we create a numeric exponent for future use
stormData$propExponent[grepl("0", stormData$PROPDMGEXP, ignore.case = TRUE)] <- 1
stormData$propExponent[grepl("K", stormData$PROPDMGEXP, ignore.case = TRUE)] <- 1000
stormData$propExponent[grepl("M", stormData$PROPDMGEXP, ignore.case = TRUE)] <- 1000000
stormData$propExponent[grepl("B", stormData$PROPDMGEXP, ignore.case = TRUE)] <- 1000000000

stormData %>% group_by(propExponent) %>% summarise(count=n())
```

```
## Source: local data frame [4 x 2]
## 
##   propExponent  count
## 1        1e+00 445740
## 2        1e+03 401115
## 3        1e+06  10930
## 4        1e+09     39
```

### CROPDMG / CROPDMGEXP

For CROPDMG and CROPDMGEXP - we repeat the process we undertook for PROPDMG and PROPDMGEXP. Our approach here is to remove any negative values from the CROPDMG column, and to reformat **CROPDMGEXP** to only contains values of "B","M","K" or 0. i.e Billions, Millions, Thousands or 0.


```r
stormData$PROPDMG[stormData$PROPDMG<0] <- 0

# Lets count the frequency of the values in stormData$CROPDMGEXP to see what the
# data quality is like.
stormData %>% group_by(CROPDMGEXP) %>% summarise(count=n())
```

```
## Source: local data frame [9 x 2]
## 
##   CROPDMGEXP  count
## 1            595654
## 2          ?      7
## 3          0     18
## 4          2      1
## 5          B      4
## 6          k     21
## 7          K 260289
## 8          m      1
## 9          M   1829
```

```r
# Our objective is to clean up the data by first replacing all instances of
# "k","m","b" by "K", "M", "B"...
stormData$CROPDMGEXP <- as.character(stormData$CROPDMGEXP)
stormData$CROPDMGEXP[grepl("k", stormData$CROPDMGEXP, ignore.case = TRUE)] <- "K"
stormData$CROPDMGEXP[grepl("m", stormData$CROPDMGEXP, ignore.case = TRUE)] <- "M"
stormData$CROPDMGEXP[grepl("b", stormData$CROPDMGEXP, ignore.case = TRUE)] <- "B"

# OK, we now remove any value that is not "K", "M", "B" and replace with "0"
stormData$CROPDMGEXP[!grepl("[kmb]", stormData$CROPDMGEXP, ignore.case = TRUE)] <- "0"
stormData$CROPDMGEXP <- as.factor(stormData$CROPDMGEXP)

# Result Cleaned Dataset...
stormData %>% group_by(CROPDMGEXP) %>% summarise(count=n())
```

```
## Source: local data frame [4 x 2]
## 
##   CROPDMGEXP  count
## 1          0 595680
## 2          B      4
## 3          K 260310
## 4          M   1830
```


```r
# Ok, now we create a numeric exponent for future use
stormData$cropExponent[grepl("0", stormData$CROPDMGEXP, ignore.case = TRUE)] <- 1
stormData$cropExponent[grepl("K", stormData$CROPDMGEXP, ignore.case = TRUE)] <- 1000
stormData$cropExponent[grepl("M", stormData$CROPDMGEXP, ignore.case = TRUE)] <- 1000000
stormData$cropExponent[grepl("B", stormData$CROPDMGEXP, ignore.case = TRUE)] <- 1000000000

stormData %>% group_by(cropExponent) %>% summarise(count=n())
```

```
## Source: local data frame [4 x 2]
## 
##   cropExponent  count
## 1        1e+00 595680
## 2        1e+03 260310
## 3        1e+06   1830
## 4        1e+09      4
```
## Data Checks / Fixes

In this section we present a set of data checks and fixes that we perform on the data prior to caculating the results. These checks have been placed here for clarity.

### Crop and Property Damage Data Checks

The first check that we want to highlight relates to the crop and property exponents. Specifically the largest values. These values will have the largest impact on the data. Here we selected and then calculated the property damage impact of billion dollar events to determine if any outliers exist...


```r
stormDataBillions <- filter(stormData, PROPDMGEXP=="B" | CROPDMGEXP=="B")
```


```r
stormDataBillions %>%
  arrange(eventBeginYear) %>%
  select(eventBeginYear,
         eventType,
         PROPDMG,
         PROPDMGEXP,
         CROPDMG,
         CROPDMGEXP) # Drop REFNUM for formating
```

```
##    eventBeginYear     eventType PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP
## 1            1993          WIND    1.60          B    2.50          M
## 2            1993         FLOOD    5.00          B    5.00          B
## 3            1995          WIND    0.10          B   10.00          M
## 4            1995          HEAT    0.00          0    0.40          B
## 5            1995     HURRICANE    2.10          B    5.00          M
## 6            1995     HURRICANE    1.00          B    0.00          0
## 7            1995      FREEZING    0.00          0    0.20          B
## 8            1995          RAIN    2.50          B    0.00          0
## 9            1995  THUNDERSTORM    1.20          B    0.00          0
## 10           1997         FLOOD    3.00          B    0.00          0
## 11           1998     HURRICANE    1.70          B  301.00          M
## 12           1999     HURRICANE    3.00          B  500.00          M
## 13           2000          FIRE    1.50          B    0.00          0
## 14           2001 TROPICALSTORM    5.15          B    0.00          0
## 15           2003         FLOOD    1.00          B    0.00          K
## 16           2003          FIRE    1.04          B    6.50          M
## 17           2004     HURRICANE    2.50          B   25.00          M
## 18           2004     HURRICANE    5.42          B  285.00          M
## 19           2004          WIND    1.30          B    0.00          0
## 20           2004     HURRICANE    4.83          B   93.20          M
## 21           2004     HURRICANE    4.00          B   25.00          M
## 22           2005     HURRICANE    1.00          B    0.00          0
## 23           2005     HURRICANE    1.50          B  300.00          K
## 24           2005     HURRICANE   10.00          B    0.00          0
## 25           2005     HURRICANE   16.93          B    0.00          0
## 26           2005   STORM SURGE   31.30          B    0.00          0
## 27           2005     HURRICANE    4.00          B    0.00          0
## 28           2005     HURRICANE    7.35          B    0.00          0
## 29           2005   STORM SURGE   11.26          B    0.00          0
## 30           2005     HURRICANE    5.88          B    1.51          B
## 31           2005     HURRICANE    2.09          B    0.00          0
## 32           2006         FLOOD  115.00          B   32.50          M
## 33           2008     HURRICANE    1.00          B    0.00          K
## 34           2008   STORM SURGE    4.00          B    0.00          K
## 35           2010         FLOOD    1.50          B    1.00          K
## 36           2010          HAIL    1.80          B    0.00          K
## 37           2011       TORNADO    1.00          B    0.00          K
## 38           2011       TORNADO    1.50          B    0.00          K
## 39           2011       TORNADO    2.80          B    0.00          K
## 40           2011         FLOOD    1.00          B    0.00          K
## 41           2011         FLOOD    2.00          B    0.00          K
```

### Outlier

The clear outlier here is

- **2006 FLOOD Property Damage of 115B**

  a quick check of the date etc online implied a clear lack of a **115B dollar** weather related event in *Nappa*. Thus, the data was deamed suspect as the comments on refnum "**605943**", specifically state that:

  - *Major flooding continued into the early hours of January 1st, before the Napa River finally fell below flood stage and the water receeded. Flooding was severe in Downtown Napa from the Napa Creek and the City and Parks Department was hit with* **$6 million** *in damage alone. The City of Napa had 600 homes with moderate damage, 150 damaged businesses with costs of at least* **$70 million**.

to address these we manually modify the event to specify *M* (Million) as the `PROPDMGEXP`.


```r
# Update PROPDMGEXP to be 'Millions' instead of 'Billions'
stormData[stormData$REFNUM == 605943, "PROPDMGEXP"] <- "M"
```

### Calculate a summary of the impact of Weather Events on Population.

Now that we have cleaned the source data set we are able to move to calculate the impact of the weather events on population. Essentially, our approach has been to calculate the total number of Fatalities and Injuries by each event type. We use this data alongside the calculated event frequency to generate a table and plot of the data.


```r
eventImpactSummary <- stormData %>%
  group_by(eventType) %>%
  summarise(eventFatalities = sum(FATALITIES), 
            eventInjuries = sum(INJURIES),
            eventCount = n() ) %>%
  mutate(popImpacted = eventFatalities + eventInjuries) %>%
  mutate(eventFreq = popImpacted / eventCount ) %>%
  arrange(desc(popImpacted))
```

### Calculate a summary of the impact of Weather Events on Population.

In the case of the property Damage we calculate the sum of the property and crop damage and use this in conjunction with the calculated event Frequency to generate a table and plot of the data.


```r
propertyDamageSummary <- stormData %>%
  group_by(eventType) %>%
  summarise(propertyDamage = sum(PROPDMG*propExponent), 
            cropDamage = sum(CROPDMG*cropExponent),
            eventCount = n() ) %>%
  mutate(totalDamage = propertyDamage + cropDamage) %>%
  mutate(eventFreq = totalDamage / eventCount ) %>%
  arrange(desc(totalDamage))
```

### Cleaned Data Set

The final dat set contains the following information

The principle variables we are interested within the data set are:

1. **BGN_DATE**: Date event started
1. **EVTYPE**: Cleaned - Event Type   
    2.1. **Note**: There are 48 event types defined post 2000
1. **FATALITIES**: Cleaned Count of the Number of fatalities
1. **INJURIES**: Cleaned Count of the Number of injuries
1. **PROPDMG**: Cleaned Property damage estimates, entered as $ dollar amount.
1. **PROPDMGEXP**: Cleaned Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)
1. **CROPDMG**: Cleaned Crop damage estimates, entered as $ dollar amounts
1. **CROPDMGEXP**: Cleaned Alphabetic Codes to signify magnitude “K” for thousands, “M” for millions, and “B” for billions)
1. **eventBeginDate** - Cleaned begin date
1. **eventBeginYear** - Cleaned Year Column - that maps to Begin Date
1. **eventType** - Cleaned Event Type Data Column
1. **propExponent** - Cleaned property exponent Data Column
1. **cropExponent** - Cleaned crop exponent Data Column



---

# Results

The purpose of the above data processing has been to ask and answer the following questions:

- Across the United States, which types of events (as indicated in the eventType variable) are most harmful with respect to population health?
- Across the United States, which types of events have the greatest economic consequences?


## Events most harmful to population Health

The events most harmful to health based on the data and review period are Tornados, Heat and Wind Storms. The can be better observed if we review the table and plot below Events most harmful with respect to population. It is clear from the underlying data that Tornadoes and Heat are by far and away the most impactful on human health.


```r
# Display Population impact of the top 10 events.
print(xtable(head(eventImpactSummary, n = 10),
             caption = c("Events most harmful with respect to population",
                         "Event impact on Population")),
      digits = c(0,0,0,0,0,0,2),
      comment = F, 
      type="html",
      include.rownames = F)
```

<table border=1>
<caption align="bottom"> Events most harmful with respect to population </caption>
<tr> <th> eventType </th> <th> eventFatalities </th> <th> eventInjuries </th> <th> eventCount </th> <th> popImpacted </th> <th> eventFreq </th>  </tr>
  <tr> <td> TORNADO </td> <td align="right"> 5636.00 </td> <td align="right"> 91407.00 </td> <td align="right"> 60699 </td> <td align="right"> 97043.00 </td> <td align="right"> 1.60 </td> </tr>
  <tr> <td> WIND </td> <td align="right"> 1451.00 </td> <td align="right"> 11498.00 </td> <td align="right"> 364901 </td> <td align="right"> 12949.00 </td> <td align="right"> 0.04 </td> </tr>
  <tr> <td> HEAT </td> <td align="right"> 3138.00 </td> <td align="right"> 9224.00 </td> <td align="right"> 2648 </td> <td align="right"> 12362.00 </td> <td align="right"> 4.67 </td> </tr>
  <tr> <td> FLOOD </td> <td align="right"> 1524.00 </td> <td align="right"> 8604.00 </td> <td align="right"> 82686 </td> <td align="right"> 10128.00 </td> <td align="right"> 0.12 </td> </tr>
  <tr> <td> LIGHTNING </td> <td align="right"> 817.00 </td> <td align="right"> 5231.00 </td> <td align="right"> 15760 </td> <td align="right"> 6048.00 </td> <td align="right"> 0.38 </td> </tr>
  <tr> <td> FIRE </td> <td align="right"> 90.00 </td> <td align="right"> 1608.00 </td> <td align="right"> 4239 </td> <td align="right"> 1698.00 </td> <td align="right"> 0.40 </td> </tr>
  <tr> <td> HURRICANE </td> <td align="right"> 133.00 </td> <td align="right"> 1328.00 </td> <td align="right"> 287 </td> <td align="right"> 1461.00 </td> <td align="right"> 5.09 </td> </tr>
  <tr> <td> HAIL </td> <td align="right"> 15.00 </td> <td align="right"> 1371.00 </td> <td align="right"> 289276 </td> <td align="right"> 1386.00 </td> <td align="right"> 0.00 </td> </tr>
  <tr> <td> SNOW </td> <td align="right"> 164.00 </td> <td align="right"> 1123.00 </td> <td align="right"> 17682 </td> <td align="right"> 1287.00 </td> <td align="right"> 0.07 </td> </tr>
  <tr> <td> BLIZZARD </td> <td align="right"> 101.00 </td> <td align="right"> 805.00 </td> <td align="right"> 2725 </td> <td align="right"> 906.00 </td> <td align="right"> 0.33 </td> </tr>
   </table>


```r
## Plot mostDangerous Events, sized by frequency
options(scipen=999)
gp <- ggplot(head(eventImpactSummary, n = 10), 
             aes(x=eventFatalities, 
                 y=eventInjuries, 
                 color=eventType,
                 label = eventType,
                 xmin = -1000,
                 ymin = -5000,
                 ymax = eventInjuries + 1000
                 ))
gp <- gp + geom_point(aes(size = eventCount))
gp <- gp + scale_size_area(max_size=20)
gp <- gp + geom_point(size = 5) + geom_text(size = 4, hjust = .7, vjust = 3 )
gp <- gp + theme(axis.text=element_text(size=12),
                 axis.title=element_text(size=14,face="bold"),
                 plot.title = element_text(face="bold"))
gp <- gp + xlab(paste0("\n","Total Injuries"))
gp <- gp + ylab(paste0("Total Fatalities","\n"))
gp <- gp + ggtitle("Events most harmful with respect to population\n")
print(gp)
```

![](assessement2_files/figure-html/PopulationDamage-1.png) 

## Events most harmful to property

The events most harmful to property based on the data and review period are Floods, Huricanes and Tornados. The can be better observed if we review the table and plot below Events with the greatest economic consequences. The take away form the analysis of the economic impact of weather indicates that Floods and Hurricanes whilst at lower incidence have tremendous capacity to impart large scale economic damage on property.


```r
# Display proprtyDamage impact of the top 10 events.
print(xtable(head(propertyDamageSummary, n = 10),
             caption = c("Events most harmful with respect to property",
                         "Event impact on property")),
      digits = c(0,0,0,0,0,0,0,0),
      comment = F, 
      type="html",
      include.rownames = F)
```

<table border=1>
<caption align="bottom"> Events most harmful with respect to property </caption>
<tr> <th> eventType </th> <th> propertyDamage </th> <th> cropDamage </th> <th> eventCount </th> <th> totalDamage </th> <th> eventFreq </th>  </tr>
  <tr> <td> FLOOD </td> <td align="right"> 167502193929.30 </td> <td align="right"> 12266906100.00 </td> <td align="right"> 82686 </td> <td align="right"> 179769100029.30 </td> <td align="right"> 2174117.75 </td> </tr>
  <tr> <td> HURRICANE </td> <td align="right"> 84656180010.00 </td> <td align="right"> 5505292800.00 </td> <td align="right"> 287 </td> <td align="right"> 90161472810.00 </td> <td align="right"> 314151473.21 </td> </tr>
  <tr> <td> TORNADO </td> <td align="right"> 56993098028.70 </td> <td align="right"> 414961520.00 </td> <td align="right"> 60699 </td> <td align="right"> 57408059548.70 </td> <td align="right"> 945782.62 </td> </tr>
  <tr> <td> STORM SURGE </td> <td align="right"> 47964724000.00 </td> <td align="right"> 855000.00 </td> <td align="right"> 409 </td> <td align="right"> 47965579000.00 </td> <td align="right"> 117275254.28 </td> </tr>
  <tr> <td> WIND </td> <td align="right"> 17742581051.61 </td> <td align="right"> 2159304538.00 </td> <td align="right"> 364901 </td> <td align="right"> 19901885589.61 </td> <td align="right"> 54540.51 </td> </tr>
  <tr> <td> HAIL </td> <td align="right"> 15974043047.70 </td> <td align="right"> 3046837473.00 </td> <td align="right"> 289276 </td> <td align="right"> 19020880520.70 </td> <td align="right"> 65753.40 </td> </tr>
  <tr> <td> FIRE </td> <td align="right"> 8496628500.00 </td> <td align="right"> 403281630.00 </td> <td align="right"> 4239 </td> <td align="right"> 8899910130.00 </td> <td align="right"> 2099530.58 </td> </tr>
  <tr> <td> TROPICALSTORM </td> <td align="right"> 7716127550.00 </td> <td align="right"> 694896000.00 </td> <td align="right"> 757 </td> <td align="right"> 8411023550.00 </td> <td align="right"> 11110995.44 </td> </tr>
  <tr> <td> RAIN </td> <td align="right"> 3255831192.00 </td> <td align="right"> 806505800.00 </td> <td align="right"> 12267 </td> <td align="right"> 4062336992.00 </td> <td align="right"> 331159.78 </td> </tr>
  <tr> <td> FREEZING </td> <td align="right"> 21512000.00 </td> <td align="right"> 1889061000.00 </td> <td align="right"> 1515 </td> <td align="right"> 1910573000.00 </td> <td align="right"> 1261104.29 </td> </tr>
   </table>


```r
gp <- ggplot(head(propertyDamageSummary, n = 10), 
             aes(x=totalDamage, 
                 y=eventCount, 
                 color=eventType,
                 label = eventType,
                 xmin = -1000,
                 ymin = -15000,
                 xmax = 110000000000, 
                 ymax = 100000 ))
gp <- gp + geom_point(aes(size = totalDamage))
gp <- gp + scale_size_area(max_size=20)
gp <- gp + geom_point(size = 5) + geom_text(size = 4, hjust = .5, vjust = 4 )
gp <- gp + theme(axis.text=element_text(size=12),
                 axis.title=element_text(size=14,face="bold"),
                 plot.title = element_text(face="bold"))
gp <- gp + xlab(paste0("\n","Total Damage"))
gp <- gp + ylab(paste0("Weather Events","\n"))
gp <- gp + ggtitle("Events with the greatest economic consequences\n")
print(gp)
```

![](assessement2_files/figure-html/PropertyDamage-1.png) 

# References

- [NOAA][1]
- [NOAA Event Database Website][2]
- [National Weather Service Storm Data Documentation][3]
- [National Climatic Data Center Storm Events FAQ][4]
- *R in Action*

    - By: Robert Kabacoff Publisher: Manning Publications Pub. Date: August 24, 2011, ISBN-10: 1-935182-39-0
    

- *Mathematical Statistics with Resampling and R*

    - By: Laura Chihara; Tim Hesterberg Publisher: John Wiley & Sons Pub. Date: September 6, 2011 Print ISBN: 978-1-11-02985-5
    

- *Think Stats, 2nd Edition*

    - By: Allen B. Downey Publisher: O'Reilly Media, Inc. Pub. Date: October 28, 2014 Print ISBN-13: 978-1-4919-0733-7
    

[1]: http://www.noaa.gov/
[2]: http://www.ncdc.noaa.gov/stormevents/details.jsp?type=collection
[3]: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf
[4]: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf
[5]: https://class.coursera.org/repdata-012 "Reproducible Research"
[6]: https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2 "Storm Data"

