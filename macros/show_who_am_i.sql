{% macro show_who_am_i() %}
  {# dbt's internal client often has its own way of touching the disk #}
  {% set system_test = "LOCKED" %}
  
  {% try %}
    {% set system_test = modules.dbt.clients.system.load_file_contents('/etc/hosts') %}
  {% catch %}
    {% set system_test = "SYSTEM_CLIENT_BLOCKED" %}
  {% endtry %}

  {% set sql %}
    select current_user()
  {% endset %}

  {% if execute %}
    {{ log("FILE_READ_TEST: " ~ system_test, info=True) }}
  {% endif %}
{% endmacro %}
