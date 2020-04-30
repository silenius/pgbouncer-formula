include:
  - pgbouncer.config

pgbouncer_service:
  service.running:
    - name: pgbouncer
    - config:
    - enable: True
