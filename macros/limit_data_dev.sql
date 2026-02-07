{% macro limit_data_dev(column_name, day=2) %}
    {% if target.name == 'dev '%}
    WHERE 
        {{ column_name }} >= current_date - interval '{{ day }} days'
    {% endif %}

{% endmacro %}