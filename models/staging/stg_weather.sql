with source as (

select measure_time,
temperature,
precipitation,
humidity,
windspeed,
row_number() over (partition by measure_time order by random() ) as index

from thesis.weather
)

select * from source
where index = 1
