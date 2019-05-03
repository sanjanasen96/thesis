--Join rides and weather

with hourly_rides as (

select *

from {{ref('fct_hourly_rides')}}

),

hourly_weather as (

select *

from {{ref('fct_hourly_weather')}}

),

rides_weather_joined as (

select *

from hourly_rides
left join hourly_weather
using (start_time, start_hour)
)

select * from rides_weather_joined
