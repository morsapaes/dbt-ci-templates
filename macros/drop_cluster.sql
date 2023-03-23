{#
-- This macro drops a cluster used in CI.
#}
{% macro drop_cluster(cluster_name=env_var('CI_TAG')) %}

{%- if cluster_name -%}

  {{ log("Dropping cluster " ~ cluster_name ~ "...", info=True) }}

  {% call statement('create_cluster', fetch_result=True, auto_begin=False) -%}
      DROP CLUSTER IF EXISTS {{ cluster_name }} CASCADE
  {%- endcall %}

  {%- set result = load_result('create_cluster') -%}
  {{ log(result['data'][0][0], info=True)}}

  {% else %}

    {{ exceptions.raise_compiler_error("Invalid arguments. Missing cluster name!") }}

  {% endif %}

{% endmacro %}