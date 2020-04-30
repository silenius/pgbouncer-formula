{% from "pgbouncer/map.jinja" import pgbouncer with context %}

include:
  - pgbouncer.install
  - pgbouncer.service

{% if pgbouncer.users is defined %}
pgbouncer_users:
  file.managed:
    - name: {{ pgbouncer.lookup.users }}
    - user: {{ pgbouncer.lookup.user }}
    - group: {{ pgbouncer.lookup.group }}
    - mode: 640
    - contents: |
      {%- for user, password in pgbouncer.users.items() %}
        "{{ user }}" "{{ password }}"
      {%- endfor %}
    - require:
      - pkg: {{ pgbouncer.lookup.pkg }}
    - require_in:
      - ini: pgbouncer_ini
{% endif %}

pgbouncer_ini:
  ini.options_present:
    - name: {{ pgbouncer.lookup.config }}
    - sections: 
        {{ pgbouncer.config|yaml }} 
    - require:
      - pkg: pgbouncer
    - watch_in:
      - service: pgbouncer_service
