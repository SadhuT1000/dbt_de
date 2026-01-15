{% set air_query %}

select distinct
    aircraft_code
from {{ ref("fct_flights") }}

{% endset %}

{% set air_query_result = run_query(air_query) %}

{% if execute %}
    {% set aircrafts_impotant = air_query_result.columns[0].values() %}

{% else %}
    {% set aircrafts_impotant = [] %}

{% endif %}

select
  
   {% for air in aircrafts_impotant -%}
    sum(case when aircraft_code = '{{ air }}' then 1 else 0 end) as fligts_{{ air|title|replace('73', 'oo') }}
     {%- if not loop.last %}, {% endif %}
     -- {{ loop.index }}
   {% endfor %}


from {{ ref("fct_flights") }}