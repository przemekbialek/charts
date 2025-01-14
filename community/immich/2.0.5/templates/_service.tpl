{{- define "immich.service" -}}
service:
  server:
    enabled: true
    primary: true
    {{- if .Values.immichNetwork.immichExpose }}
    type: NodePort
    {{- else }}
    type: ClusterIP
    {{- end }}
    targetSelector: server
    ports:
      server:
        enabled: true
        primary: true
        port: {{ .Values.immichNetwork.webuiPort }}
        {{- if .Values.immichNetwork.immichExpose }}
        nodePort: {{ .Values.immichNetwork.webuiPort }}
        {{- end }}
        protocol: http
        targetSelector: server

  microservices:
    enabled: true
    type: ClusterIP
    targetSelector: microservices
    ports:
      microservices:
        enabled: true
        primary: true
        port: {{ .Values.immichNetwork.microservicesPort }}
        protocol: http
        targetSelector: microservices

  {{- if .Values.immichConfig.enableML }}
  machinelearning:
    enabled: true
    type: ClusterIP
    targetSelector: machinelearning
    ports:
      machinelearning:
        enabled: true
        primary: true
        port: {{ .Values.immichNetwork.machinelearningPort }}
        protocol: http
        targetSelector: machinelearning
  {{- end -}}

  {{- if .Values.immichConfig.enableTypesense }}
  typesense:
    enabled: true
    type: ClusterIP
    targetSelector: typesense
    ports:
      typesense:
        enabled: true
        primary: true
        port: {{ .Values.immichNetwork.typesensePort }}
        protocol: http
        targetSelector: typesense
  {{- end }}

  redis:
    enabled: true
    type: ClusterIP
    targetSelector: redis
    ports:
      redis:
        enabled: true
        primary: true
        port: 6379
        targetPort: 6379
        targetSelector: redis

  {{- include "ix.v1.common.app.postgresService" $ | nindent 2 }}

{{- end -}}
