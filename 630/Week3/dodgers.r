#The dataset provides attendance information for all MLB teams for 2012 season. Each row illustrates attributes of one game, which can be divided into 4 buckets: Time (Month, Date, Day of Week, Day/Night), Weather (Temperature, Sky), teams (home_team, opponent) and promotion (Cap, Shirt, Fireworks, Bobblehead). All of these variables can have more or less effect on the attendance of the game.


#The data for the panel, which includes both cross-sectional and time series details. In this case, at various times of the season and across different teams, the dataset presents observations of bobblehead promotion. Therefore, not only by time but also among teams, the effect of bobblehead could vary.


#Promoting the cap and shirt had a minor influence on the attendance. Of these three, fireworks appeared to have the greatest influence on attendance. Games with fireworks had an average attendance of 34,400, while games without fireworks only drew 30,600 people.

library(car)  # Package with Special functions for linear regression
library(lattice)  # Graphics Package
library(ggplot2) # Graphical Package
library(readr)  # for read_csv

#file1 <- 'C:/Users/Rkuppusami120932/Desktop/Assignment/DSC-630/WEEK1/data/SeriesReport-20190604000331_2e6597.xlsx'
#file2 <- 'C:/Users/Rkuppusami120932/Desktop/Assignment/DSC-630/WEEK1/data/SeriesReport-20190604000335_96a2f0.xlsx'

DodgersData <-read_csv("C:/Users/Rkuppusami120932/Desktop/Assignment/DSC-630/Week3/dodgers.csv")

# Check the structure for Dorder Data
str(DodgersData)

# Reorder the factor levels for day_of_week
DodgersData$day_of_week <- factor(DodgersData$day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Evaluate the factor levels for month
# levels(DodgersData$month)

# Reorder the factor levels for month
DodgersData$month <- factor(DodgersData$month, levels = c("APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT"))


head(DodgersData, 10)


#For games played in the day or night under Clear or Gloomy Skys, we have data from April to October. 

#The size of Dodger Stadium is about 56,000. Looking at the full (sample) data reveals that in 2012, 
#The stadium only filled up twice. Just two cap promotions and three shirt promotions were available - not enough data for any inferences. A few occasions, fireworks and Bobblehead promotions have occurred.


#Attendance by Day Of Week

## Box plot to explore attendance by day of week
plot(DodgersData$day_of_week, DodgersData$attend / 1000, main = "Dodgers Attendence By Day Of Week", xlab = "Day of Week", ylab = "Attendance (thousands)", col = "dark blue", las = 1)


##Attendance by Month
# Box plot to explore attendance by Month
plot(DodgersData$month, DodgersData$attend / 1000, main = "Dodgers Attendence By Month", xlab = "Month", 
ylab = "Attendance (thousands)", col = "light blue", las = 1)


#Evaluate attendance by weather
ggplot(DodgersData, aes(x=temp, y=attend/1000, color=fireworks)) + 
        geom_point() + 
        facet_wrap(day_night~skies) + 
        ggtitle("Dodgers Attendance By Temperature By Time of Game and Skies") +
        theme(plot.title = element_text(lineheight=3, face="bold", color="black", size=10)) +
        xlab("Temperature (Degree Farenheit)") +
        ylab("Attendance (Thousands)")
        
#At day games with bright skies, we see that the attendance tends to be poor when the temperature is low. 
#The game was also played under cloudy skies for just one day.        


#Strip Plot of Attendance by opponent 

#Strip Plot of Attendance by opponent or visiting team
ggplot(DodgersData, aes(x=attend/1000, y=opponent, color=day_night)) + 
        geom_point() + 
        ggtitle("Dodgers Attendance By Opponent") +
        theme(plot.title = element_text(lineheight=3, face="bold", color="black", size=10)) +
        xlab("Attendance (Thousands)") +
        ylab("Opponent (Visiting Team)")
        
        
#Predictive Model

# Create a model with the bobblehead variable entered last
my.model <- {attend ~ month + day_of_week + bobblehead}

# Prepare a Training and Test dataset

# Reseed for repeatability
set.seed(1234)

training_test <- c(rep(1, trunc((2/3)*nrow(DodgersData))), rep(2, trunc((1/3)*nrow(DodgersData))))

# sample(training_test)

# Create a variable in DodgersData data frame to identify Test and Training row
DodgersData$Training_Test <- sample(training_test)

DodgersData$Training_Test <- factor(DodgersData$Training_Test, levels = c(1, 2), labels = c("TRAIN", "TEST"))


DodgersData.Train <- subset(DodgersData, Training_Test == "TRAIN")
DodgersData.Test <- subset(DodgersData, Training_Test == "TEST")



# Fit model to training set
train.model.fit <- lm(my.model, data = DodgersData.Train)

# Predict from Training Set
DodgersData.Train$Predict_Attend <- predict(train.model.fit)

# Evaluate The Fitted Model on the Test Set
DodgersData.Test$Predict_Attend <- predict(train.model.fit, newdata = DodgersData.Test)

#round(cor(DodgersData.Test$attend, DodgersData.Test$Predict_Attend)^2, digits=3)

# compute the proportion of response variance accounted for when predicting Test Data
cat("\n","Proportion of Test Set Variance Accounted for: ", round(cor(DodgersData.Test$attend, DodgersData.Test$Predict_Attend)^2, digits=3), "\n", sep="")

DodgersData.Training_Test <- rbind(DodgersData.Train, DodgersData.Test)


ggplot(DodgersData.Training_Test, aes(x=attend/1000, y=Predict_Attend/1000, color=bobblehead)) + 
        geom_point() + 
        geom_line(data = data.frame(x = c(25,60), y = c(25,60)), aes(x = x, y = y), colour = "red") +
        facet_wrap(~Training_Test) +
        #geom_smooth(method = "lm", se=FALSE) +
        ggtitle("Regression Model Performance : Bobblehead and Attendance") +
        theme(plot.title = element_text(lineheight=3, face="bold", color="black", size=10)) +
        xlab("Actual Attendance (Thousands)") +
        ylab("Predicted Attendance (Thousands)")
