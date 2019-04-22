{% macro get_ride_tables(schema) %}

    {% set tables = [] %}
    {% for table_name in var('ride_tables') %}
        {% set _ = tables.append(schema~'.'~table_name) %}
    {% endfor %}

    {{return(tables)}}

{% endmacro %}
