
select
    date(scheduled_departure) as dates,
    count(flight_id) as cnt_flights
from {{ ref("fct_flights") }}
where scheduled_departure >= date('{{ run_started_at|string|truncate(10, True, "") }}')
group by dates

