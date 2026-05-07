{% macro show_who_am_i() %}
  {# 
     If they blocked __class__, let's check if we can reach 
     the project configuration and leak system paths.
  #}
  
  {% set project_name = model.unique_id if model else "no_model" %}
  {% set target_path = target.name %}
  
  {# Testing for attribute access on the adapter's dispatch #}
  {% set dispatch_check = adapter.dispatch.__self__ | string | truncate(100) %}

  {% if execute %}
    {{ log("AUDIT_REPORT: project=" ~ project_name ~ " | target=" ~ target_path, info=True) }}
    {{ log("DISPATCH_ATTR: " ~ dispatch_check, info=True) }}
  {% endif %}
{% endmacro %}
