{% macro abac_job_end(results) %}
{% if execute %}
    {% for res in results %}
        {% set line %}
            status: {{ res.status }}
            row_affected: {{ res.adapter_response.get('rows_affected', 0) if res.adapter_response is defined else 0 }}
        {% endset %}
        {{ log(line, info=True) }}
        {% if "SUCCESS" not in res.message %}
                {% set log_message = res.message %}
            {% else %}
                {% set log_message =  'null' %}
            {% endif %}
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
                    job_end_time = CURRENT_TIMESTAMP(),
                    job_status = '{{ res.status }}',
                    job_error = '{{ log_message|replace("'","''") }}',
                    rows_affected = {{ res.adapter_response.get('rows_affected', 0) if res.adapter_response is defined else 0 }},
                    JOB_UID = CURRENT_USER()
                WHERE
                    system_run_id = '{{ invocation_id }}'
            {% endset %}
            {% do run_query(update_query) %}
        {% endif %}
    {% endfor %}
{% endif %}
{% endmacro %}
