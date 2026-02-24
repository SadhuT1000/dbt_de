{% macro limit_data_dev(column_name, day=2) %}
    {% if target.name == 'dev '%}
    {% if day < 0  %}
        {% do exceptions.warn("У тебя ошибка потому что ты ошибся блиять))" ~ day) %}
    {% endif %}
    WHERE 
        {{ column_name }} >= {{ dbt.dateadd(datepart='day', interval=-days, from_date_or_timestamp='current_date') }}
    {% endif %}

{% endmacro %}