with rides_2 as (

    select * from {{ref('stg_citibikes_1')}}

),

fix_dates_2 as (

    select
       date_trunc('hour', (to_timestamp(starttime, 'YYYY-MM-DD HH24:MI:SS'))::timestamp) as start_time,
       extract(hour from (to_timestamp(starttime, 'YYYY-MM-DD HH24:MI:SS'))::timestamp) as start_hour,
       *
   from rides_2

),

hourly_2 as (

    select
        start_time,
        start_hour,
        count(*) as total_rides
    from fix_dates_2
    group by 1,2

)

select * from hourly_1
