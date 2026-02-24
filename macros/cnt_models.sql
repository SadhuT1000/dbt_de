{% macro cnt_models(model_name) %}

    {% set cnt_models = [] %}
    {% set cnt_seeds = [] %}
    {% set cnt_snapshot = [] %}

{% if execute %}
    {% for node in graph.nodes.values() %}
     | {% if node.resource_type == 'model' %}
        {% do cnt_models.append(node.name) %}
       {% elif node.resource_type == 'seed' %}
        {% do cnt_seeds.append(node.name) %}
       {% elif node.resource_type == 'snapshot' %}
        {% do cnt_snapshot.append(node.name) %}
    {% endif %}
{% endfor %}



{% do log("Количесво моделей " ~ cnt_models | length, True) %}  
{% do log("Количесво seed " ~ cnt_seeds | length, True) %}  
{% do log("Количесво snapshots " ~ cnt_snapshot | length, True) %}  


{% endif %}


{% endmacro %}
