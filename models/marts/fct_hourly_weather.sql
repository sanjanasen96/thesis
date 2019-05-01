
with weather as (

    select *

from thesis.weather

),

weather_fixed as (

    select date_trunc('hour', (to_timestamp(measure_time, 'DD/MM/YYYY HH24:MI:SS'))::timestamp) as start_time,
       extract(hour from (to_timestamp(measure_time, 'DD/MM/YYYY HH24:MI:SS'))::timestamp) as start_hour,
       *

from weather

)

select * from weather_fixed
