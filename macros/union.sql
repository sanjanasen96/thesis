{% macro use_database(dbname) %}

    {% call statement('_') %}
        use database {{ dbname }};
    {% endcall %}

{% endmacro %}

{% macro union_tables(tables, source_db, column_override=none) -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set column_override = column_override if column_override is not none else {} %}

    {%- set table_columns = {} %}
    {%- set column_superset = {} %}

    {%- for table in tables -%}

        {%- set _ = table_columns.update({table: []}) %}

        {%- if table.name -%}
            {%- set schema, table_name = table.schema, table.name -%}
        {%- else -%}
            {%- set schema, table_name = (table | string).split(".") -%}
        {%- endif -%}

        {% set source_relation = api.Relation.create(database=source_db, schema=schema, identifier=table_name) %}
        {%- set cols = adapter.get_columns_in_relation(source_relation) %}

        {%- for col in cols -%}

            {# update the list of columns in this table #}
            {%- set _ = table_columns[table].append(col.column) %}

            {%- if col.column in column_superset -%}

                {%- set stored = column_superset[col.column] %}
                {%- if col.is_string() and stored.is_string() and col.string_size() > stored.string_size() -%}

                    {%- set _ = column_superset.update({col.column: col}) %}

                {%- endif %}

            {%- else -%}

                {%- set _ =  column_superset.update({col.column: col}) %}

            {%- endif -%}
        {%- endfor %}
    {%- endfor %}

    {%- set ordered_column_names = column_superset.keys() %}

    {%- for table in tables -%}

        (
            select

                '{{ table }}'::text as _dbt_source_table,

                {% for col_name in ordered_column_names -%}

                    {%- set col = column_superset[col_name] %}
                    {%- set col_type = column_override.get(col.column, col.data_type) %}
                    {%- set col_name = adapter.quote(col_name) if col_name in table_columns[table] else 'null' %}

                    {{ col_name }}::{{ col_type }} as {{ col.quoted }} {% if not loop.last %},{% endif %}
                {%- endfor %}

            from {{ source_db }}.{{ table }}
        )

        {% if not loop.last %} union all {% endif %}

    {%- endfor %}

{%- endmacro %}
