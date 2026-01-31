select
    date(scheduled_departure) as dates_10_year,
    count(*) as {{ adapter.quote('all_flights') }}
from {{ ref("fct_flights")}}

where scheduled_departure between date('{{ run_started_at|string|truncate(10, True, "") }}') - interval '10 years' 
and date('{{ run_started_at|string|truncate(10, True, "") }}') 
group by dates_10_year


{% set fct_flights = api.Relation.create(
    database = 'dwh_flights',
    schema = 'intermediate',
    identifier = 'fct_flights',
    type = 'table'
)
%}


{% set stg_flights__flights = api.Relation.create(
    database = 'dwh_flights',
    schema = 'intermediate',
    identifier = 'stg_flights__flights',
    type = 'table'
)
%}

{% do adapter.expand_target_column_types(fct_flights, stg_flights__flights) %}


{% for col in adapter.get_columns_in_relation(fct_flights) %}
    {{ 'Column:' ~ col }}
{% endfor %}


{% for col in adapter.get_columns_in_relation(stg_flights__flights) %}
    {{ 'Column:' ~ col }}
{% endfor %}