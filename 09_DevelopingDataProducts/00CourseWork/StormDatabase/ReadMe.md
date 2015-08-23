---
title: "Readme"
author: "Technophobe1"
date: "August 18, 2015"
output: 
  html_document: 
    theme: united
---

[Coursera: Developing Data Products][9]
=========================
#### Course Project: Submission

---
## Synopsis
Our aim to describe the impact of severe weather events in the United States between the years **1950** to **2011**. This analysis is intended to address the following questions:

- Across the United States, which types of events (as indicated in the eventType variable) are most harmful with respect to population health?
- Across the United States, which types of events have the greatest economic consequences?

To investigate and answer these questions and validate our hypothesis, we obtained the Storm and Weather events database from the National Oceanic and Atmospheric Administration ([NOAA][1])  which is collected from various sources across the U.S. We specifically obtained data for the years 1950 and 2011.

### Usage

This Shiny application allows the viewer to review and manipulate the NOAA data in a number of ways. You may adjust date range using control panel located on the left side.The result is shown in the main pannel on the right side of the page.

- Buble Chart - **Economic Impact by Year**
- Buble Chart - **Population Impact by year**
- Geographic Map - **Economic Geographic Impact by State**
    - You can view Property Damage, Crop Damage or both forms of event damage by **state** and **year**.

### Data, Code and Presentation

- Source code for the project is available on the [GitHub][5].
- The Shiny application is availble on [Shinyapps.io][7]
- The Presentation is available on [Rpubs][8] 
- The dataset can be download from [NOAA][2]

Note: Additional documentation is avaialble from NOOA that explains how the data has been obtained, and what and how the variables are defined and constructed.

- [NOAA Event Database Website][2]
- [National Weather Service Storm Data Documentation][3]
- [National Climatic Data Center Storm Events FAQ][4]

# Conclusions:

The events most harmful to property based on the data are Floods, Huricanes and Tornados. Floods and Hurricanes whilst at lower incidence have tremendous capacity to impart large scale economic damage on property. The events most harmful to health based on the data and review period are Tornados, Heat and Wind Storms. Tornadoes and Heat are by far and away the most impactful on human health. It is worth noting that the events most harmful to health and property in the US principally occur in the central and mid states based on the data and review period analysed.

# References

- [NOAA][1]
- *R in Action*
    - By: Robert Kabacoff Publisher: Manning Publications Pub. Date: August 24, 2011, ISBN-10: 1-935182-39-0
- *Mathematical Statistics with Resampling and R*
    - By: Laura Chihara; Tim Hesterberg Publisher: John Wiley & Sons Pub. Date: September 6, 2011 Print ISBN: 978-1-11-02985-5
    

[1]: http://www.noaa.gov/
[2]: http://www.ncdc.noaa.gov/stormevents/details.jsp?type=collection
[3]: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf
[4]: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf
[5]: https://github.com/Technophobe01/courses/tree/master/09_DevelopingDataProducts/00CourseWork/StormDatabase
[6]: https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2 "Storm Data"
[7]: https://technophobe01.shinyapps.io/StormDatabase
[8]: https://rpubs.com/Technophobe01/StormDatabase
[9]: https://class.coursera.org/devdataprod-031
