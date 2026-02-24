
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
  {{ koperk_to_ruble('total_amount', -2) }} as total_amount
  

from {{ source('demo_src', 'bookings') }}

{# {% if is_incremental() %}
  where 
  ('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})

{% endif %} #}

{% if execute %}

-- {{ graph.nodes.values() }}

{% for node in graph.nodes.values() %}
  {% if node.resource_type == 'model' %}
  -- {{ node.name }}
  -- -----------
  -- {{ node }}
  {% endif %}
{% endfor %}


{% endif %}