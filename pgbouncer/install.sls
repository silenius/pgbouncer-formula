{% from "pgbouncer/map.jinja" import pgbouncer with context %}

pgbouncer_pkg:
  pkg.installed:
    - name: {{ pgbouncer.pkg }}
