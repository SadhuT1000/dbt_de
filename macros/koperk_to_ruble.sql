{% macro koperk_to_ruble(column_name, scale=2) %}
    {% if scale < 0  %}
        {% do exceptions.warn("У тебя ошибка потому что ты ошибся я тебя предупредил))" ~ scale) %}
    {% endif %}
    ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}