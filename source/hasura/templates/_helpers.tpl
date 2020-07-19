{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper host name
*/}}
{{- define "hostname" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.hostname }}
        {{- printf "%s" .Values.global.hostname -}}
    {{- else -}}
        {{- printf "%s" required "Valid hostname is required" .Values.hostname -}}
    {{- end -}}
{{- else -}}
        {{- printf "%s" required "Valid hostname is required" .Values.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Return the jwt Key
*/}}
{{- define "hasura.jwtKey" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.jwt }}
    {{- if .Values.jwt.key }}
        {{- printf "%s" .Values.jwt.key -}}
    {{- else -}}
        {{- fail "jwt key is required" -}}
    {{- end -}}
{{- else -}}
    {{- fail "jwt key is required" -}}
{{- end -}}
{{- end -}}

{{/*
Return the jwt algorithm
*/}}
{{- define "hasura.jwtAlgo" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.jwt }}
    {{- if .Values.jwt.algorithm }}
        {{- printf "%s" .Values.jwt.algorithm -}}
    {{- else -}}
        {{- printf "HS256" -}}
    {{- end -}}
{{- else -}}
    {{- printf "HS256" -}}
{{- end -}}
{{- end -}}

{{/*
Return the postgresql url name
*/}}
{{- define "postgresql.url" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- (printf "postgres://%s:%s@%s-postgresql:%d/%s" (.Values.postgresql.postgresqlUsername | default "postgres") .Values.postgresql.postgresqlPassword .Release.Name (.Values.postgresql.servicePort |int) (required ".Values.postgresql.postgresqlDatabase is required" .Values.postgresql.postgresqlDatabase)) -}}
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
