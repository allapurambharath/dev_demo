{%macro rename_column(table_nm, old_column, new_column)%}
{%set query%}
    ALTER TABLE {{ ref(table_nm) }}
    RENAME COLUMN {{ old_column }} TO {{ new_column }};
{%end set%}
{% do run(query) %}
{%end macro%}