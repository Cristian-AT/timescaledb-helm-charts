{{/*
This file and its contents are licensed under the Apache License 2.0.
Please see the included NOTICE for copyright information and LICENSE for a copy of the license.
*/}}
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "timescaledb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "timescaledb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "timescaledb.dataname" -}}
{{ template "timescaledb.fullname" . }}-data
{{- end -}}


{{- define "timescaledb.accessname" -}}
{{ template "timescaledb.fullname" . }}-access
{{- end -}}

{{- define "postgres.uid" -}}
{{- default .Values.uid "1000" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "timescaledb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.tplvalues.render" -}}
{{- if .scope }}
  {{- if typeIs "string" .value }}
    {{- tpl (cat "{{- with $.RelativeScope -}}" .value  "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- else }}
    {{- tpl (cat "{{- with $.RelativeScope -}}" (.value | toYaml)  "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- end }}
{{- else }}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{- else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use.
*/}}
{{- define "timescaledb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "timescaledb.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
