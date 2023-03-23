{#
-- This macro creates a new cluster that will be torn down once the PR is closed (or merged).
#}
{% macro create_cluster(cluster_name=env_var('CI_TAG')) %}

{%- if cluster_name -%}

  {%- call statement('catalog', fetch_result=True) -%}
      SELECT name
      FROM mz_clusters
      WHERE name = lower('{{ cluster_name }}')
  {%- endcall -%}

  {%- set result_catalog = load_result('catalog') -%}

  {{ log(result_catalog['data'], info=True)}}

  {%- if result_catalog['data']|length > 0 -%}

    {{ log("Cluster " ~ cluster_name ~ " already exists, skipping cluster creation...", info=True) }}

    {% else %}

      {{ log("Creating cluster " ~ cluster_name ~ "...", info=True) }}

      {% call statement('create_cluster', fetch_result=True, auto_begin=False) -%}
          CREATE CLUSTER {{ cluster_name }} REPLICAS (r1 (SIZE = '2xsmall'))
      {%- endcall %}

      {%- set result_create_cluster = load_result('create_cluster') -%}

    {% endif %}

  {% else %}

    {{ exceptions.raise_compiler_error("Invalid arguments. Missing cluster name!") }}

  {% endif %}

{% endmacro %}