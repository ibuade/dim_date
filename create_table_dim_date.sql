SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dim_date](
	[date_key] [int] NOT NULL,
	[full_date] [date] NOT NULL,
	[day_number_of_week] [tinyint] NOT NULL,
	[day_name_of_week] [varchar](10) NOT NULL,
	[day_number_of_month] [tinyint] NOT NULL,
	[day_number_of_year] [smallint] NOT NULL,
	[days_remaining_in_year] [smallint] NOT NULL,
	[weekday] bit NOT NULL,
	[week_number_of_year] [tinyint] NOT NULL,
	[week_start_date] [date] NOT NULL,
	[week_end_date] [date] NOT NULL,
	[week_key] [int] NOT NULL,
	[month_full_name] [varchar](10) NOT NULL,
	[month_abbr_name] [varchar](3) NOT NULL,
	[month_number_of_year] [tinyint] NOT NULL,
	[month_key] [int] NOT NULL,
	[month_start_date] [date] NOT NULL,
	[month_end_date] [date] NOT NULL,
	[month_end] bit NOT NULL,
	[calendar_quarter] [tinyint] NOT NULL,
	[calendar_quarter_key] [int] NOT NULL,
	[calendar_year] [smallint] NOT NULL,
	[leap_year] bit NOT NULL,
 CONSTRAINT [PK_Dim_Date_DateKey] PRIMARY KEY CLUSTERED 
(
	[date_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

