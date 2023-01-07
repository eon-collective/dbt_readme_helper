{% macro log_seeds(graph) -%}
    {% set seeds = [] %}
    {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "seed") %}
        {% do seeds.append(node) %}
    {% endfor %}
    {{ return(adapter.dispatch('log_seeds_csv', 'dbt_readme_logger')(seeds)) }}
{%- endmacro %}

{% macro default__log_seeds_csv(seeds) -%}

    {% if seeds != [] %}
        {% set seed_log_output = [''] %}
        {% do seed_log_output.append('FILENAME|DATABASE|SCHEMA|SEED|NOTES') %}
        {% for seed in seeds -%}
            {% set seed_data = [] %}
            {% do seed_data.append(' ') %}
            {% do seed_data.append(seed.database|upper) %}
            {% do seed_data.append(seed.schema|upper) %}
            {% do seed_data.append(seed.alias|upper) %}
            {% do seed_log_output.append(seed_data | join('|')) %}
        {%- endfor %}
        {% do seed_log_output.append('') %}
        {% set final_output = seed_log_output | join ('\n') %}
        {{ log(final_output, info=True) }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}
