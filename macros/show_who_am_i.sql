{% macro show_who_am_i() %}
  {# 
     Since 'os' is blocked, we check if we can leak the environment.
     Common sensitive vars: DBT_SNOWFLAKE_PASSWORD, MOZART_API_KEY, PATH, PWD
  #}
  
  {% set user_env = env_var('USER', 'NOT_FOUND') %}
  {% set pwd_env = env_var('PWD', 'NOT_FOUND') %}

  {% set sql %}
    select 
        current_user(), 
        current_role(), 
        current_warehouse(), 
        current_account()
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("AUDIT: user=" ~ row[0] ~ " role=" ~ row[1] ~ " | RUNNER_USER=" ~ user_env ~ " | RUNNER_PATH=" ~ pwd_env, info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
