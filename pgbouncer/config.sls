{% from "pgbouncer/map.jinja" import pgbouncer with context %}

include:
  - pgbouncer.install
  - pgbouncer.service

{% if pgbouncer.users is defined %}
pgbouncer_users:
  file.managed:
    - name: {{ pgbouncer.users }}
    - user: {{ pgbouncer.user }}
    - group: {{ pgbouncer.group }}
    - mode: 640
    - contents: |
      {%- for user, password in pgbouncer.users.items() %}
        "{{ user }}" "{{ password }}"
      {%- endfor %}
    - require:
      - pkg: {{ pgbouncer.pkg }}
    - require_in:
      - ini: pgbouncer_ini
{% endif %}

{% if pgbouncer.config.present is defined %}
pgbouncer_ini_present:
  ini.options_present:
    - name: {{ pgbouncer.ini }}
    - sections: 
        {{ pgbouncer.config.present|yaml }} 
    - require:
      - pkg: pgbouncer
    - watch_in:
      - service: pgbouncer_service
{% endif %}

{% if pgbouncer.config.absent is defined %}
pgbouncer_ini_absent:
  ini.options_absent:
    - name: {{ pgbouncer.ini }}
    - sections: 
        {{ pgbouncer.config.absent|yaml }} 
    - require:
      - pkg: pgbouncer
    - watch_in:
      - service: pgbouncer_service
{% endif %}
