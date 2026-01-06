{{
  config(
    materialized = 'table',
    )
}}


select 
    passenger_id
from {{ ref('id_passenger') }}