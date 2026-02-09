{% macro safe_select(table_name) %}

{% if execute %}
    {% set exists = adapter.get_relation(
        database=target.database,
        schema=target.schema,
        identifier=table_name
    ) %}
     {% do log(exists, True) %}
    {% if exists %}
        {% set cleanup_query %}
            SELECT * FROM {{ table_name }}
        {% endset %}
    {% else %}
        {% set cleanup_query %}
            SELECT NULL
        {% endset %}
    {% endif %}

{% else %}
    
    {% set cleanup_query %}
        SELECT NULL
    {% endset %}
{% endif %}

{{ cleanup_query }}
{% do log(cleanup_query, True) %}

{% endmacro %}
