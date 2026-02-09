{{
  config(
    materialized = 'table',
    meta = {
      'owner': 'sql_file_owner@mail.com'
    }
    )
}}

select 
    {{ show_columns_relation('stg_flights__bookings') }}
from 
    {{ ref("stg_flights__bookings") }}