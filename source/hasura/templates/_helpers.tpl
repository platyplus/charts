{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper host name
*/}}
{{- define "hostname" -}}
{{- if .Values.global }}
    {{- if .Values.global.hostname }}
        {{- printf "%s" .Values.global.hostname -}}
    {{- else }}
        {{- printf "%s" required "Valid hostname is required" .Values.hostname -}}
    {{- end }}
{{- else }}
        {{- printf "%s" required "Valid hostname is required" .Values.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Return the jwt Key
*/}}
{{- define "hasura.jwtKey" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace "{{ .Release.Name }}-hasura") }}
{{- if .Values.jwt }}
    {{- if .Values.jwt.key }}
        {{- .Values.jwt.key }}
    {{- else }}
        {{- if $secret }}
            {{- (index $secret.data "jwt.key") | b64dec }}
        {{- else}}
            {{- randAlphaNum 64 }}
        {{- end -}}
    {{- end -}}
{{- else }}
    {{- if $secret }}
        {{- (index $secret.data "jwt.key") | b64dec }}
    {{- else}}
        {{- randAlphaNum 64 }}
    {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Return the jwt Key
*/}}
{{- define "hasura.adminSecret" -}}
{{- if .Values.adminSecret }}
  {{- .Values.adminSecret }}
{{- else}}
  {{- $secret := (lookup "v1" "Secret" .Release.Namespace "{{ .Release.Name }}-hasura") }}
  {{- if $secret }}
    {{- (index $secret.data "adminSecret") | b64dec }}
  {{- else}}
    {{- randAlphaNum 64 }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the jwt algorithm
*/}}
{{- define "hasura.jwtAlgo" -}}
{{- if .Values.jwt }}
    {{- if .Values.jwt.algorithm }}
        {{- .Values.jwt.algorithm }}
    {{- else }}
        {{- "HS256" }}
    {{- end -}}
{{- else }}
    {{- "HS256" }}
{{- end -}}
{{- end -}}

{{- define "call-nested" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 }}
{{- $template := index . 2 }}
{{- include $template (dict "Chart" (dict "Name" $subchart) "Values" (index $dot.Values $subchart) "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}


{{/*
Return the postgresql url
*/}}
{{- define "hasura.databaseSecrets" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace "{{ .Release.Name }}-hasura") }}
{{- $postgresPassword := randAlphaNum 16 }}
{{- if $secret }}
    {{- $postgresPassword:= (index $secret.data "postgresql-password") | b64dec }}
{{- else }}
    {{- if .Values.postgresql.postgresqlPassword }}
        {{- $postgresPassword := .Values.postgresql.postgresqlPassword }}
    {{- end -}}
{{- end -}}
postgresql-password: {{ $postgresPassword | b64enc | quote }}
databaseUrl: {{ (printf "postgres://%s:%s@%s-postgresql:%d/%s" (.Values.postgresql.postgresqlUsername | default "postgres") $postgresPassword .Release.Name (.Values.postgresql.servicePort |int) (required ".Values.postgresql.postgresqlDatabase is required" .Values.postgresql.postgresqlDatabase)) | b64enc | quote }}
{{- end -}}


{{/*
Expand the name of the chart.
*/}}
{{- define "hasura.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hasura.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hasura.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hasura.labels" -}}
helm.sh/chart: {{ include "hasura.chart" . }}
{{ include "hasura.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hasura.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hasura.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hasura.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hasura.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
