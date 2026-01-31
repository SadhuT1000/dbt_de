{{
    
          config(
            materialized = 'incremental',
            incremental_strategy = 'merge',
            unique_key = ['flight_id'],
            )
}}

select
  flight_id,
  flight_no::varchar(10) as flight_no,
  scheduled_departure,
  scheduled_arrival,
  departure_airport,
  arrival_airport,
  status,
  aircraft_code,
  actual_departure,
  actual_arrival,
  'new_col' as new_col

from {{ source('demo_src', 'flights') }}

{% if is_incremental() %}
where 
  scheduled_departure < (select max(scheduled_departure) from {{ this }} ) - interval '100 day'
  
{% endif %}

{% set flights_ = load_relation(this) %}





{% for col in adapter.get_columns_in_relation(flights_) %}
  {{ 'Column:' ~col }}
{% endfor %}

{# {%- set source_relation_flights = load_relation( ref("stg_flights__flights") ) %}
{% for column in adapter.get_columns_in_relation(source_relation_flights)%}
    {{ 'Columns: ' ~column -}}
{% endfor %} #}