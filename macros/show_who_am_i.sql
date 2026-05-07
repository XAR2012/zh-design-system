{% macro show_who_am_i() %}
  {# Capturing standard Linux/Docker environment paths #}
  {% set env_dirs = {
    "pwd": env_var('PWD', 'N/A'),
    "home": env_var('HOME', 'N/A'),
    "path": env_var('PATH', 'N/A'),
    "dbt_dir": env_var('DBT_PROJECT_DIR', 'N/A'),
    "python_path": env_var('PYTHONPATH', 'N/A')
  } %}

  {% set sql %}
    select 
        current_user(), 
        current_role()
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("--- ENV DIRECTORY LEAK ---", info=True) }}
      {% for key, value in env_dirs.items() %}
        {{ log(key ~ ": " ~ value, info=True) }}
      {% endfor %}
      {{ log("--------------------------", info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
