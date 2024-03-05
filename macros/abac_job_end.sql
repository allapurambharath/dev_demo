{% macro abac_job_end(results) %}
{% if execute %}
    {% for res in results %}
        {% set line -%}
            status: {{ res.status }}
            {% if "SUCCESS" not in res.message %}
                message: {{ res.message }}
            {% else %}
                message: null
            {% endif %}
            row_affected: {{ res.adapter_response.rows_affected }}
        {%- endset %}
        {{ log(line, info=True) }}
        {% set table_nm = res.node.unique_id.split('.') %}
        {% set model_nm = table_nm[-1] %}
        {% set job_info %}
            select job_id, job_name from 
            {{ source('AUDIT','ABAC_JOB') }} 
            WHERE JOB_TARGET = '{{ model_nm }}' 
        {% endset %}
        {% set results = run_query(job_info) %}
        {% if execute %}
            {% set job_id = results.columns[0].values()[0] %}
            {% set job_name = results.columns[1].values()[0] %}
            {% set update_query %}
                update
                    {{ source('AUDIT', 'ABAC_JOB_RUN') }}
                set 
                    job_start_time = CURRENT_TIMESTAMP(),
                    job_end_time = NULL,
                    job_status = '{{ res.status }}',
                    rows_affected = {{ res.adapter_response.rows_affected }},
                    JOB_UID = CURRENT_USER()
                WHERE
                    system_run_id = '{{ invocation_id }}'
            {% endset %}
            {% do run_query(update_query) %}
        {% endif %}
    {% endfor %}
{% endif %}
{% endmacro %}
