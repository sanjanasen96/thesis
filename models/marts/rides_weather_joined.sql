--Join rides and weather

with hourly_rides as (

select *

from {{ref('fct_hourly_rides')}}

),

hourly_weather as (

select *

from {{ref('fct_hourly_weather')}}

),

holidays as (

    select *
    from {{ref('stg_holidays')}}


),

rides_weather_joined as (

select *,

case when holidays.holiday is not null
then 1
else 0
end as is_holiday

from hourly_rides
left join hourly_weather
using (start_time, start_hour)
left join holidays
using (date_day)
),

rides_weekday as (

select extract (dow from date_day) as dow,
extract (mon from date_day) as month ,
extract (d from date_day) as day,
*

from rides_weather_joined

),

weekend_flag as (

select *,

case when dow = 0 or dow = 6
then 1
else 0
end as is_weekend ,

case when month in (1 ,2) OR  (month = 3 and day < 20)
then 'winter'
when month in (3,4,5) OR (month = 6 and day < 20 )
then 'spring'
when month in (6, 7,8 ) OR (month = 9 and day < 22)
then 'summer'
when month in (9, 10, 11) OR (month = 12 and day < 22)
then 'fall'
when month = 12 and day >= 22 then 'winter'
else NULL

end as season

from rides_weekday

)

select * from weekend_flag
