{% macro clean_column(table_name, column_name) %}
    {% set clean_query %}
        UPDATE dev_demo.raw.column_clean_tbl
        SET {{ column_name }} = REGEXP_REPLACE({{ column_name }}, '[^[:print:]]', '');
    {% endset %}
    {% do run_query(clean_query) %}
{% endmacro %}
