
with rides_1 as (

    select * from {{ref('stg_citibikes')}}

),

normalized_timestamp as (

  select * ,
   case when to_timestamp(starttime, 'YYYY-MM-DD HH24:MI:SS')::timestamp >= '2016-10-01'
   THEN to_timestamp(starttime, 'YYYY-MM-DD HH24:MI:SS')::timestamp
   ELSE to_timestamp(starttime, 'MM/DD/YYYY HH24:MI:SS')::timestamp
   END AS fixed_timestamp

from rides_1
),


fix_dates_1 as (

    select
       date_trunc('hour', fixed_timestamp) as start_time,
       extract(hour from fixed_timestamp) as start_hour,
     fixed_timestamp::date as date_day,
       *
   from normalized_timestamp

),

hourly_1 as (

    select
        start_time,
        start_hour,
        date_day,
        count(*) as total_rides
    from fix_dates_1
    group by 1,2,3

)

select * from hourly_1
