CREATE PROC create_dim_date
(
        @start_date date
       ,@end_date date
       ,@start_of_the_week int = 1
)

/********************************************************************************
* Description:
*      Populate reference.Dim_Date table with dates between the start and end date params
********************************************************************************/

AS

BEGIN

        --TRUNCATE TABLE
        TRUNCATE TABLE reference.Dim_date;

		--INSERT UNKNOWN DATE
	     INSERT [dim_date]
			([date_key],
			 [full_date],
			 [day_number_of_week],
			 [day_name_of_week],
			 [day_number_of_month],
			 [day_number_of_year],
			 [days_remaining_in_year],
			 [weekday],
			 [week_number_of_year],
			 [week_start_date],
			 [week_end_date],
			 [week_key],
			 [month_full_name],
			 [month_abbr_name],
			 [month_number_of_year],
			 [month_key],
			 [month_start_date],
			 [month_end_date],
			 [month_end],
			 [calendar_quarter],
			 [calendar_quarter_key],
			 [calendar_year],
			 [leap_year]) 
			 
		 SELECT -1, '01-Jan-1753', 1, 'Unknown', 1, 1, 364, 1, 1, '01-Jan-1753', '07-Jan-1753', 175301, 'Unknown', 'UnK', 1, 175301, '01-Jan-1753', '31-Jan-1753', 0, 1, '175301', 1753, 0
       
	   -- If start of the week value is outside of acceptable range
         IF @start_of_the_week not between 1 and 7
			BEGIN
              SELECT @start_of_the_week = 1
			END

       -- Set first day of the week
       SET DATEFIRST @start_of_the_week


       -- insert the rest of the calendar
       DECLARE @ProcessDate DATE = @start_date
       DECLARE @WeekYearFlag AS INT

       WHILE (@ProcessDate <= @end_date)
       BEGIN
              SELECT @WeekYearFlag = 7 - DATEPART(dw,@ProcessDate) 
              INSERT dim_date
					(
                        date_key,
						full_date,
						day_number_of_week,
						day_name_of_week,
						day_number_of_month,
						day_number_of_year,
						days_remaining_in_year,
						weekday,
                        week_number_of_year,
						week_start_date,
						week_end_date,
						week_key,
						month_full_name,
						month_abbr_name,
						month_number_of_year,
						month_key,
						month_start_date,
						month_end_date,
						month_end,
					    calendar_quarter,
						calendar_quarter_key,
                        calendar_year,
						leap_year
					)
                SELECT
                     convert(varchar, @ProcessDate, 112)                                                                       date_key                                                                      
                     ,convert(date,@ProcessDate,103)                                                                           full_date                                                                                          
                     ,datepart(dw,@ProcessDate)                                                                                day_number_of_week                                                                                       
                     ,datename(weekday,@ProcessDate)                                                                           day_name_of_week                                                                                        
                     ,day(@ProcessDate)                                                                                        day_number_of_month                                                                                              
                     ,datepart(dy,@ProcessDate)                                                                                day_number_of_year                                           
                     ,datediff(dd,dateadd(dd, 1, @ProcessDate), dateadd(year, datediff(year,0,@ProcessDate)+1,0))              days_remaining_in_year
                     ,case when DATENAME(WEEKDAY,@ProcessDate) in ('Saturday','sunday')  then 0 else 1 end                     [weekday]                         
					 ,datepart(wk, dateadd(dd,@WeekYearFlag,@ProcessDate))                                                      week_number_of_year
                     ,dateadd(dd,-(datepart(dw,@ProcessDate)-1),@ProcessDate)                                                   week_start_date
                     ,dateadd(dd,7-(datepart(dw,@ProcessDate)),@ProcessDate)                                                    week_end_date
                     ,(year(dateadd(dd,@WeekYearFlag,@ProcessDate))*100) + datepart(wk, dateadd(dd,@WeekYearFlag,@ProcessDate)) week_key
                     ,datename(month,@ProcessDate)                                                                              month_full_name                                   
                     ,substring(datename(month,@ProcessDate),1,3)                                                               month_abbr_name
					 ,month(@ProcessDate)                                                                                       month_number_of_year
                     ,convert(varchar, year(@ProcessDate)) + right('00' + convert(varchar, month(@ProcessDate)),2)              month_key
                     ,dateadd(dd,-datepart(dd,@ProcessDate)+1,@ProcessDate)                                                     month_start_date               
                     ,eomonth(@ProcessDate)                                                                                     month_end_date                                         
                     ,case when eomonth(@ProcessDate)=@ProcessDate then 1 else 0 end                                            month_end                                             
                     ,datepart(q,@ProcessDate)                                                                                  calendar_quarter                                   
                     ,convert(varchar, year(@ProcessDate)) + right('00' + convert(varchar, datepart(q,@ProcessDate)),2)         calendar_quarter_key
                     ,year(@ProcessDate)                                                                                        calendar_year                                                                                                                             
                     ,case when isdate(convert(varchar,year(@ProcessDate)) + '0229')   = 1 then 1 else 0 end                    leap_year                                                          

                     -- Go to the next date..
                     set @ProcessDate = dateadd(dd, 1, @ProcessDate)
       END
END

GO


