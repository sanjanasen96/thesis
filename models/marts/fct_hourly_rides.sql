with rides as (

    select * from {{ref('stg_citibikes')}}

),

fix_dates as (

    select
       date_trunc('hour', (to_timestamp(starttime, 'MM/DD/YYYY HH12:MI:SS'))::timestamp) as start_time,
       extract(hour from (to_timestamp(starttime, 'MM/DD/YYYY HH12:MI:SS'))::timestamp) as start_hour,
       *
   from rides

),

hourly as (

    select
        start_time,
        start_hour,
        count(*) as total_rides
    from fix_dates
    group by 1,2

)

select * from hourly
