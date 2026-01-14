{% set status_query %}
select distinct
    status
from {{ ref("stg_flights__flights") }}
{% endset %}


{% set status_query_result = run_query(status_query) %}

{% if execute %}
    {% set air_status = status_query_result.columns[0].values() %}

{% else %}
    {% set air_status = [] %}

{% endif %}


select
    {% for stat in air_status %}
    sum(case when status = '{{ stat }}' then 1 else 0 end) as status_{{ stat | replace(' ', '_') }}
    {%- if not loop.last %}, {% endif %}
    {% endfor %}

from {{ ref("stg_flights__flights") }}