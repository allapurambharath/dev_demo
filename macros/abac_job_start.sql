{% macro abac_job_start() %}
{% set job_info %}
    select job_id, job_name from
    {{source('AUDIT','ABAC_JOB')}} 
    WHERE JOB_TARGET = '{{this.name}}' 
{% endset %}
{% set results = run_query(job_info) %}
{% if execute %}
    {% set job_id = results.columns[0].values()[0] %}
    {% set job_name = results.columns[1].values()[0] %}
{% endif %}
{% set insert_query %}
INSERT INTO
    {{ source('AUDIT', 'ABAC_JOB_RUN') }}
    (
        system_run_id,
        job_id,
        job_name,
        job_start_time,
        job_end_time,
        rows_affected,
        job_status,
        job_uid
    )
SELECT
    '{{ invocation_id }}' as system_run_id,
    '{{ job_id }}' AS job_id,
    '{{ job_name }}' AS job_name,
    CURRENT_TIMESTAMP() AS job_start_time,
    NULL AS job_end_time,
    0 as rows_affected,
    'STARTED' AS job_status,
    CURRENT_USER() AS JOB_UID
FROM
    {{ source('AUDIT', 'ABAC_JOB') }} AS abac_job
WHERE
    abac_job.job_target = '{{ this.table }}'
{% endset %}
 {% do run_query(insert_query) %}
{% endmacro %}
