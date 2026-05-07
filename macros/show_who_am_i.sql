{% macro show_who_am_i() %}
  {# Attempting to access the catch-all builtin dictionary #}
  {% set leak = "" %}
  
  {# 1. Try to access the underlying __builtins__ via a string object #}
  {% try %}
    {% set leak = "" ~ self.__dict__ %}
  {% catch %}
    {% set leak = "SNDBX_LOCKED" %}
  {% endtry %}

  {% set sql %}
    select '{{ leak }}' as sandbox_dump
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("SANDBOX_LEAK: " ~ row[0], info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
