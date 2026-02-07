
{{
    
          config(
            materialized = 'incremental',
            incremental_strategy = 'append',
            tags = ['bookings']
            )
}}

select
  {{ bookref_to_bigint('book_ref') }} as book_ref,

  book_date,
  {{ koperk_to_ruble('total_amount') }} as total_amount
  

from {{ source('demo_src', 'bookings') }}

{# {% if is_incremental() %}
  where 
  ('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})

{% endif %} #}

    