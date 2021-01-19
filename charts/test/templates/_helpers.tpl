{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openvpn-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openvpn-server.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openvpn-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "openvpn-server.labels" -}}
helm.sh/chart: {{ include "openvpn-server.chart" . }}
{{ include "openvpn-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openvpn-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openvpn-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the proper Storage Class
*/}}
{{- define "openvpn-server.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.persistence.storageClass }}
    {{- if (eq "-" .Values.persistence.storageClass) }}
        {{- printf "storageClassName: \"\"" -}}
    {{- else }}
        {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Return the fallback protocol if option if defined
*/}}
{{- define "openvpn-server.fallbackProtocol" -}}
{{- if and .Values.service.fallback (eq .Values.service.protocol "TCP") }}
{{- printf "udp" }}
{{- else }}
{{- printf "tcp" }}
{{- end }}
{{- end}}

{{/*
Return OpenVPN random passphrase
*/}}
{{- define "openvpn-server.randomPassphrase" -}}
{{- printf "pass:%s" (randAlphaNum 18) -}}
{{- end -}}

{{/*
Return OpenVPN passphrase
*/}}
{{- define "openvpn-server.passphrase" -}}
{{- if .Values.easyrsa.secret.passphrase -}}
    {{- .Values.easyrsa.secret.passphrase -}}
{{- else -}}
    {{- include "openvpn-server.randomPassphrase" . -}}
{{- end -}}
{{- end -}}

{{/*
Get the passphrase secret.
*/}}
{{- define "openvpn-server.secretName" -}}
{{- if .Values.easyrsa.secret.existingSecret -}}
    {{- printf "%s" (tpl .Values.easyrsa.secret.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "openvpn-server.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existingSecret.
*/}}
{{- define "openvpn-server.useExistingSecret" -}}
{{- if .Values.easyrsa.secret.existingSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "openvpn-server.createSecret" -}}
{{- if not (include "openvpn-server.useExistingSecret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}
