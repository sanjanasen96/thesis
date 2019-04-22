
with humidity as (

    select
    cast (datetime as TIMESTAMP),
    humidity

from thesis.humidity

where datetime between '2016-01-01 00:00:00' and '2017-12-31 23:59:59'

),

temperature as (

    select
    cast (datetime as TIMESTAMP),
    temperature

from thesis.temperature

where datetime between '2016-01-01 00:00:00' and '2017-12-31 23:59:59'

),

description as (

    select
    cast (datetime as TIMESTAMP),
    description

from thesis.description

where datetime between '2016-01-01 00:00:00' and '2017-12-31 23:59:59'

),


windspeed as (

    select
    cast (datetime as TIMESTAMP),
    windspeed

    from thesis.windspeed

where datetime between '2016-01-01 00:00:00' and '2017-12-31 23:59:59'

),

joined as (

    select humidity.*,
    temperature.temperature,
    description.description,
    windspeed.windspeed

    from humidity
    left join temperature
    on humidity.datetime=temperature.datetime

    left join description
    on temperature.datetime=description.datetime

    left join windspeed
    on description.datetime=windspeed.datetime

)

select * from joined 
