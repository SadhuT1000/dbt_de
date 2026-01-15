select
    date(scheduled_departure) as dates_10_year,
    count(flight_id) as all_flights
from {{ ref("fct_flights")}}

where scheduled_departure between date('{{ run_started_at|string|truncate(10, True, "") }}') - interval '10 years' 
and date('{{ run_started_at|string|truncate(10, True, "") }}') 
group by dates_10_year