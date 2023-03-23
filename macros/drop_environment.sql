{#
-- This macro drops a cluster used in CI.
#}
{% macro drop_environment(cluster_name=env_var('CI_TAG')) %}

{%- if cluster_name -%}

  {{ log("Dropping cluster " ~ cluster_name ~ "...", info=True) }}

  {% call statement('drop_cluster', fetch_result=True, auto_begin=False) -%}
      DROP CLUSTER IF EXISTS {{ cluster_name }} CASCADE
  {%- endcall %}

  {%- set result = load_result('drop_cluster_cluster') -%}

  {% else %}

    {{ exceptions.raise_compiler_error("Invalid arguments. Missing cluster name!") }}

  {% endif %}

{% endmacro %}