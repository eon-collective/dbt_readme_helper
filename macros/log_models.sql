{% macro log_models(graph) -%}
    {% set models = [] %}
    {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}
        {% do models.append(node) %}
    {% endfor %}
    {{ return(adapter.dispatch('log_models_csv', 'dbt_readme_logger')(models)) }}
{%- endmacro %}

{% macro default__log_models_csv(models) -%}

    {% if models != [] %}
        {% set model_log_output = [''] %}
        {% do model_log_output.append('DATABASE|SCHEMA|MODEL|MATERIALIZATION|TAGS|NOTES') %}
        {% for model in models -%}
            {% set model_data = [] %}
            {% do model_data.append(model.database|upper) %}
            {% do model_data.append(model.schema|upper) %}
            {% do model_data.append(model.name|upper) %}
            {% do model_data.append(model.config.materialized|upper) %}
            {% do model_data.append(tojson(model.tags)) %}
            {% do model_log_output.append(model_data | join('|')) %}
        {%- endfor %}
        {% do model_log_output.append('') %}
        {% set final_output = model_log_output | join ('\n') %}
        {{ log(final_output, info=True) }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}
