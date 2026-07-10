library(tidyverse) #used for data manipulation and visualization
library(forecast) #used for time-series forecasting and ARIMA modeling
library(trend) #used for Mann-Kendall and Theil-Sen trend analysis
library(zoo) #used for working with regular and irregular time series data
library(RColorBrewer) #used for creating color palettes for visualizations
library(viridis) #used for creating color palettes for visualizations
library(ggridges) #used for creating ridge plots for visualizing distributions

dat <- read.table("D:\\R_JP\\Assi\\43.rlrdata.txt", 
                  sep = ";", #separator is semicolon
                  header = FALSE, #no header in file
                  col.names = c("dec_year", "sl_mm", "flag", "flag2"),
                  #dce_year = Decimal year (e.g., 1878.0833 for February 1878)
                  #sl_mm = Sea level in millimeters
                  #Extra columns (flag, flag2) for quality control
                  na.strings = "-99999", #missing value code
                  # strip.white = TRUE #removes space from quatations
)


dat$year  <- floor(dat$dec_year) #floor removes the decimal part, giving the integer year
dat$month <- floor((dat$dec_year - dat$year) * 12) + 1   # +1 is for the month configration
#fomrula year-year*12+1 gives the month number (1-12) based on the decimal part of the year.
dat$date  <- as.Date(paste(dat$year, dat$month, "15", sep = "-"))
#this takes 15th day as a date as the dataset is onth

seg <- dat %>% 
  filter(!is.na(sl_mm), flag == 0, #only use rows where flag is 0 (good data)
         year >= 1878, year <= 1961) %>% #selects the segment from 1878 to 1961
  arrange(date) #arrenges the data in ascending order of date

sl_ts <- ts(seg$sl_mm, frequency = 12, start = c(1878, 1))  
#creates a time series object with monthly frequency starting from January 1878, using the sea level measurements in millimeters from the selected segment of data.

annual <- seg %>% #group the data by year
  group_by(year) %>% #calculate the mean sea level for each year, ignoring NA values
  summarise(mean_sl = mean(sl_mm), .groups = "drop") #ungroup the data after summarization


p1 <- ggplot(seg, aes(x = date, y = sl_mm)) +  #plotting the monthly sea level data with date on                                                    x-axis and sea level in mm on y-axis
  geom_line(col = "steelblue", linewidth = 0.6) + 
  #adds a line plot to show the monthly sea level variations
  geom_smooth(method = "lm", col = "red", se = TRUE, fill = "pink") +  
  #adds a linear regression line with confidence interval
  labs(title = "Monthly Sea Level (1878 to 1961)",
       subtitle = "84 year gap-free segment",
       x = "Year", y = "Sea Level (mm)") +
  theme_minimal()
print(p1)

p2 <- ggplot(annual, aes(x = year, y = mean_sl)) +  #plotting the annual mean sea level data with   year on x-axis and mean sea level in mm on y-axis
  geom_point(col = "steelblue", size = 2) +  #adds points to show the annual mean sea level values
  geom_line(col = "steelblue", alpha = 0.6) +  
  #adds a line plot to connect the annual mean sea level values
  geom_smooth(method = "lm", col = "red", fill = "pink") +  
  #adds a linear regression line with confidence interval to show the overall trend
  geom_smooth(method = "loess", span = 0.2, col = "darkgreen", se = FALSE) + 
  #adds a LOESS smoothing line to show localized nonlinear fluctuations
  labs(title = "Annual Mean Sea Level (1878 to 1961)",
       x = "Year", y = "mm") +
  theme_minimal()
print(p2)

baseline <- mean(annual$mean_sl)  #Calculates the average sea level across the entire study period of 84 years for baseline.
annual$anomaly <- annual$mean_sl - baseline  #calculating anomaly

p3 <- ggplot(annual, aes(x = year, y = 1, fill = anomaly)) +  #Using annual data for visualization
  geom_col(width = 1, show.legend = FALSE) + 
  scale_x_continuous(expand = c(0, 0), breaks = seq(1880, 1960, 20)) + 
  #setting x-axis breaks every 20 years
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_gradientn(colors = rev(brewer.pal(11, "RdBu")),
                       limits = c(-max(abs(annual$anomaly)), 
                                  max(abs(annual$anomaly)))) +
  #setting the limits of the color scale to be symmetric around zero based on the maximum absolute    anomaly value
  labs(title = "Sea Level Anomaly Stripes (1878 to 1961)",
       subtitle = sprintf("Baseline = segment mean (%.0f mm)", baseline),
       x = NULL, y = NULL) +
  theme_minimal() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        panel.grid = element_blank()) #removing y-axis text, ticks, and grid for a cleaner stripe     visualization

print(p3)

cal <- seg %>%  #group the data by year and month
  group_by(year, month) %>%  
  #calculate the average sea level for each month of each year, ignoring NA values
  summarise(avg_sl = mean(sl_mm), .groups = "drop")  #ungroup the data after summarization

p4 <- ggplot(cal, aes(x = month, y = year, fill = avg_sl)) +  #plotting the calendar heatmap with month on x-axis, year on y-axis, and average sea level as fill color
  geom_tile(color = "white", linewidth = 0.1) +  
  #adds tiles to create the heatmap with white borders between tiles
  scale_fill_viridis_c(option = "plasma", name = "mm") +  
  #using the plasma color palette from viridis for the fill colors, with a label for the legend
  scale_x_continuous(breaks = 1:12, labels = month.abb) + 
  #setting x-axis breaks for each month and labeling them with abbreviated month names
  scale_y_continuous(breaks = seq(1880, 1960, 10)) +   #setting y-axis breaks every 10 years
  labs(title = "Sea Level Calendar Heatmap (1878 to 1961)",
       x = "Month", y = "Year") +
  theme_minimal() +
  theme(panel.grid = element_blank()) #removing grid lines for a cleaner heatmap visualization

print(p4)

stl_fit <- stl(sl_ts, s.window = 35, t.window = 19, robust = TRUE) #STL decomposition with specified seasonal and trend window sizes, and robust fitting to reduce the influence of outliers
plot(stl_fit, main = "STL Decomposition (1878 to 1961)") 
#plots the STL decomposition results, showing the original time series, seasonal component, trend component, and remainder (residual) component

sa <- sl_ts - stl_fit$time.series[, "seasonal"]  #calculating the seasonally adjusted series by removing the seasonal component from the original time series
plot(sa, main = "Seasonally Adjusted (1878 to 1961)", ylab = "mm")  
#plots the seasonally adjusted time series, which represents the original sea level data with the seasonal effects removed, allowing for clearer analysis of the underlying trend and variability

lines(stl_fit$time.series[, "trend"], col = "red", lwd = 2)  
#adds the trend component from the STL decomposition to the seasonally adjusted plot as a red line, allowing for visual comparison between the seasonally adjusted data and the underlying trend
legend("topleft", legend = c("Adjusted", "Trend"), col = c("black", "red"), lty = 1)  
#adds a legend to the plot to differentiate between the seasonally adjusted series (black) and the trend component (red)

lm_fit <- lm(mean_sl ~ year, data = annual)  
#fits a linear regression model to the annual mean sea level data, with mean_sl as the response variable and year as the predictor variable, to estimate the overall linear trend in sea level rise over time
print(summary(lm_fit)$coefficients) 
#prints the coefficients of the linear regression model, including the intercept and slope, along with their standard errors, t-values, and p-values to assess the statistical significance of the trend

cat(sprintf("Trend: %.3f mm/year, R² = %.3f\n\n", 
            coef(lm_fit)[2], summary(lm_fit)$r.squared)) 
#prints the estimated trend in millimeters per year (the slope of the linear regression) and the R-squared value, which indicates the proportion of variance in the annual mean sea level that is explained by the linear model
cat("-------------------------------------------\n\n")

mk <- mk.test(annual$mean_sl)  
#performs the Mann-Kendall trend test on the annual mean sea level data to assess the presence of a monotonic trend without assuming any specific distribution for the data, providing a non-parametric alternative to linear regression for trend analysis
print(mk)  
#prints the results of the Mann-Kendall test, including the test statistic, p-value, and the direction of the trend (increasing or decreasing)


df_sen <- data.frame(sl = annual$mean_sl, yr = annual$year) 
#creates a data frame with the annual mean sea level (sl) and corresponding years (yr) to be used for Theil-Sen slope estimation
sen <- zyp::zyp.sen(sl ~ yr, data = df_sen)  
#calculates the Theil-Sen slope estimator for the annual mean sea level data, which provides a robust estimate of the trend slope that is less sensitive to outliers compared to ordinary least squares regression
cat(sprintf("\nTHEIL-SEN: %.3f mm/year\n\n", coef(sen)[2])) 
#prints the estimated Theil-Sen slope in millimeters per year, which represents the median slope of all pairwise comparisons of the annual mean sea level data, providing an alternative measure of the long-term trend

smk <- smk.test(sl_ts) 
#performs the Seasonal Mann-Kendall test on the monthly sea level time series data to assess the presence of a monotonic trend while accounting for seasonal variability, providing a non-parametric method for trend analysis in seasonal time series data
print(smk) 
#prints the results of the Seasonal Mann-Kendall test, including the test statistic, p-value, and the direction of the trend (increasing or decreasing) while considering the seasonal structure of the data

train <- window(sl_ts, end = c(1959, 12))  
#creates a training time series object that includes all monthly sea level observations from the start of the series (January 1878) up to December 1959, which will be used to fit the ARIMA model
test  <- window(sl_ts, start = c(1960, 1))  
#creates a test time series object that includes the monthly sea level observations from January 1960 to December 1961, which will be used to evaluate the forecasting performance of the ARIMA model

cat(sprintf("Training: %d months\n", length(train)))  
#prints the number of months in the training dataset, which includes all observations from January 1878 to December 1959
cat(sprintf("Test: %d months\n\n", length(test)))  
#prints the number of months in the test dataset, which includes observations from January 1960 to December 1961

fit <- auto.arima(train, seasonal = TRUE, stepwise = FALSE) 
#fits an ARIMA model to the training time series data using the auto.arima function, which automatically selects the best-fitting ARIMA model based on AICc, allowing for seasonal components and using a more exhaustive search (stepwise = FALSE) to find the optimal model parameters

cat("ARIMA model:\n")
print(summary(fit))  
#prints a summary of the fitted ARIMA model, including the estimated coefficients for the AR and MA terms, the seasonal components, and the overall model fit statistics such as AICc

fc <- forecast(fit, h = 24) 
#generates forecasts for the next 24 months (2 years) using the fitted ARIMA model, which will provide predicted sea level values for the test period (January 1960 to December 1961) along with confidence intervals for the forecasts
plot(fc, main = "ARIMA Forecast vs Actual (Jan 1960 to Dec 1961)") 
#plots the forecasted values along with the actual observed values for the test period, allowing for visual comparison of the ARIMA model's performance in predicting sea level changes during the test period

lines(test, col = "red", lwd = 2)
legend("topleft", legend = c("Forecast", "80% CI", "95% CI", "Actual"),
       col = c("blue", "grey60", "grey80", "red"), lty = 1, lwd = c(2,1,1,2)) 
#adds a legend to the plot to differentiate between the forecasted values (blue), the 80% confidence interval (grey60), the 95% confidence interval (grey80), and the actual observed values (red)

acc <- accuracy(fc, test) 
#calculates the accuracy of the ARIMA forecasts by comparing the forecasted values to the actual observed values in the test dataset, providing various accuracy metrics such as Mean Absolute Error (MAE), Root Mean Squared Error (RMSE), and Theil's U statistic to evaluate the forecasting performance of the model
print(acc)  
#prints the accuracy metrics for the ARIMA forecasts, including MAE, RMSE, and Theil's U statistic, which can be used to assess how well the model's forecasts match the actual observed values in the test period

cat(sprintf("\nTheil's U: %.2f (%s)\n", acc[2, "Theil's U"],
            ifelse(acc[2, "Theil's U"] < 1, "beats naive", "worse than naive"))) 
#prints Theil's U statistic along with an interpretation of whether the ARIMA model's forecasts perform better than a naive forecast (Theil's U < 1) or worse than a naive forecast (Theil's U >= 1), providing insight into the relative performance of the ARIMA model in forecasting sea level changes during the test period


resid <- stl_fit$time.series[, "remainder"] 
#extracts the remainder (residual) component from the STL decomposition of the original sea level time series, which represents the unexplained variability after accounting for the trend and seasonal components

par(mfrow = c(1,2))  
acf(resid, lag.max = 36, main = "ACF")  
#plots the autocorrelation function (ACF) of the residuals up to a lag of 36 months (3 years) to assess whether there is any remaining autocorrelation in the residuals, which would indicate that the model has not fully captured the temporal dependencies in the data
pacf(resid, lag.max = 36, main = "PACF")  
#plots the partial autocorrelation function (PACF) of the residuals up to a lag of 36 months to further investigate the presence of autocorrelation at specific lags, which can help identify any remaining structure in the residuals that may need to be addressed in the modeling process
par(mfrow = c(1,1))

lb <- Box.test(resid, lag = 24, type = "Ljung-Box")
#performs the Ljung-Box test on the residuals with a lag of 24 months to statistically assess whether there is significant autocorrelation in the residuals, which would indicate that the model has not adequately captured the temporal dependencies in the data
print(lb) 

shapiro <- shapiro.test(resid)  
#performs the Shapiro-Wilk test on the residuals to assess whether they are normally distributed, which is an assumption of many statistical models and can affect the validity of inference and forecasting if violated
print(shapiro)

qqnorm(resid, main = "Q-Q Plot")  
#creates a Q-Q plot of the residuals to visually assess whether they follow a normal distribution, where points should approximately lie on a straight line if the residuals are normally distributed
qqline(resid, col = "red")