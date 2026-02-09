{% macro concat_columns(columns, delin=', ') %}
    {%- for col in columns %}
    {{ col }} {% if not loop.last %} || '{{ delin }}' || {% endif %}
    {% endfor %}
{% endmacro %}



{% macro drop_old_relations(dryrun=False) %}

{# находим все модели seed, snapshot #}

{% set current_model = [] %}

{% for node in graph.nodes.values() | selectattr('resource_type', 'in', ['model', 'snapshot', 'seed']) %}
    {% do current_model.append(node.name) %}
{% endfor %}

--{% do log(current_model, True) %}
{# формирование скрипта удаления #}

{% set cleanup_query %}
WITH MODELS_TO_DROP AS (

    SELECT
        CASE
            WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
            WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
        END AS RELATION_TYPE,
        CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) AS RELATION_NAME
    FROM
        {{ target.database }}.INFORMATION_SCHEMA.TABLES
    WHERE
        TABLE_SCHEMA = '{{ target.schema }}'
        AND UPPER(TABLE_NAME) NOT IN (
            {%- for mod in current_model -%}
                '{{ mod.upper() }}'
                {%- if not loop.last -%}
                , 
                {%- endif %}
            {%- endfor %}
            )
)
SELECT 
    'DROP' || ' ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' as DROP_COMMANDS
FROM MODELS_TO_DROP
{% endset %}


{% do log(cleanup_query, True) %}


{# удаление и вывод в лог скрипта удаления #}
{% set drop_commands = run_query(cleanup_query).columns[0].values() %}


{% if drop_commands %}
    {% if dryrun | as_bool == False %}
        {% do log('Дропнем внахуй', True) %}
    {% else %}
         {% do log('ТОлько предупреждаем что дропнем', True) %}
    {% endif %}

    {% for com in drop_commands %}
        {% do log(com, True)%}
        {% if dryrun | as_bool == False %}
            {% do run_query(com) %}
        {% endif %}
    {% endfor %}
{% else %}
    {% do log('Нечего дропать', True) %}
{% endif %}



{% endmacro %}





{% macro show_columns_relation(table_name) %}

{% if execute %}
    {# Проверяем таблицу #}
    {% set exists = adapter.get_relation(
        database=target.database,
        schema=target.schema,
        identifier=table_name
    ) %}
    {% do log(exists, True) %}

    {%- if exists -%}
        {%- set cols = run_query(
            "SELECT COLUMN_NAME FROM "
            ~ target.database ~ ".INFORMATION_SCHEMA.COLUMNS "
            ~ "WHERE TABLE_SCHEMA = '" ~ target.schema ~ "' "
            ~ "AND TABLE_NAME = '" ~ table_name ~ "'"
        ).columns[0].values() -%}
        {{ cols | join(', ') }}
    {%- else -%}
        {{ log("Table '" ~ table_name ~ "' does not exist", True) }}
    {%- endif -%}

{% endif %}

{% endmacro %}
