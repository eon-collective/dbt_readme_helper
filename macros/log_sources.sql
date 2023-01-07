{% macro log_sources(graph) -%}
    {% set sources = [] %}
    {% for node in graph.sources.values() %}
        {% do sources.append(node) %}
    {% endfor %}
    {{ return(adapter.dispatch('log_sources_csv', 'dbt_readme_logger')(sources)) }}
{%- endmacro %}

{% macro default__log_sources_csv(sources) -%}

    {% if sources != [] %}
        {% set source_log_output = [''] %}
        {% do source_log_output.append('DATABASE|SCHEMA|TABLE|NOTES') %}
        {% for source in sources -%}
            {% set source_data = [] %}
            {% do source_data.append(source.database|upper) %}
            {% do source_data.append(source.schema|upper) %}
            {% do source_data.append(source.name|upper) %}
            {% do source_log_output.append(source_data | join('|')) %}
        {%- endfor %}
        {% do source_log_output.append('') %}
        {% set final_output = source_log_output | join ('\n') %}
        {{ log(final_output, info=True) }}
    {% else %}
        {{ return("") }}
    {% endif %}
{% endmacro -%}
