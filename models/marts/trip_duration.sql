select

tripduration::int, count(tripduration) as frequency

from {{ref('stg_citibikes')}}
group by 1
order by 1 
