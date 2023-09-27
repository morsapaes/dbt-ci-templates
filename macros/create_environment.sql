{#
-- This macro creates a new cluster that will be torn down once the PR is closed (or merged).
#}
{% macro create_environment(cluster_name=env_var('CI_TAG')) %}

{%- if cluster_name -%}
  # We removed the IF NOT EXISTS clause from CREATE CLUSTER in #12002, so need a
  # workaround to handle pushes
  # https://github.com/MaterializeInc/materialize/pull/12002
  {%- call statement('catalog', fetch_result=True) -%}
      SELECT name
      FROM mz_clusters
      WHERE name = lower('{{ cluster_name }}')
  {%- endcall -%}

  {%- set result_catalog = load_result('catalog') -%}

  {%- if result_catalog['data']|length > 0 -%}

    {{ log("Cluster " ~ cluster_name ~ " already exists, skipping cluster creation...", info=True) }}

    {% else %}

      {{ log("Creating cluster " ~ cluster_name ~ "...", info=True) }}

      {% call statement('create_cluster', fetch_result=True, auto_begin=False) -%}
          CREATE CLUSTER {{ cluster_name }} SIZE = '2xsmall'
      {%- endcall %}

      {%- set result_create_cluster = load_result('create_cluster') -%}

  {% endif %}

{% else %}

  {{ exceptions.raise_compiler_error("Invalid arguments. Missing cluster name!") }}

{% endif %}

{% endmacro %}
