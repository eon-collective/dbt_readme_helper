{% macro log_results_csv() -%}

    {% if execute %}
  			{%- do log("Logging sources csv", true) -%}
        {{ dbt_readme_helper.log_sources(graph) }}

        {% do log("Logging seeds csv", true) %}
        {{ dbt_readme_helper.log_seeds(graph) }}

        {% do log("Logging models csv", true) %}
        {{ dbt_readme_helper.log_models(graph) }}
    {% endif %}
  
{%- endmacro %}
