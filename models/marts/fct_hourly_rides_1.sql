with rides_1 as (

    select * from {{ref('stg_citibikes_1')}}

),

fix_dates_1 as (

    select
       date_trunc('hour', (to_timestamp(starttime, 'MM/DD/YYYY HH24:MI:SS'))::timestamp) as start_time,
       extract(hour from (to_timestamp(starttime, 'MM/DD/YYYY HH24:MI:SS'))::timestamp) as start_hour,
       *
   from rides_1

),

hourly_1 as (

    select
        start_time,
        start_hour,
        count(*) as total_rides
    from fix_dates_1
    group by 1,2

)

select * from hourly_1
