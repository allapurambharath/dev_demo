{% macro clean_column(table_nm, column_nm) %}
{% set clean_column_name = replace_regex(column_name, '[^\x20-\x7E]', '', 'g') %}
    {% set query %}
  ALTER TABLE dev_demo.raw.column_clean_tbl
RENAME COLUMN "{{ column_name }}" TO "{{ clean_column_name }}";
    {% endset %}
    {% do run_query(query) %}
{% endmacro %}