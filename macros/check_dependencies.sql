{% macro check_dependencies(model_name) %}
  {% if execute %}
    {% for node in graph.nodes.values() %}
      {% if node.name == model_name %}
        {% set dep_count = node.depends_on.nodes | length %}
        {% if dep_count > 1 %}
          {% do exceptions.warn("⚠️ Модель " ~ model_name ~ " зависит от " ~ dep_count ~ " объектов!") %}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endmacro %}
