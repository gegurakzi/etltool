{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zookeeper.name" -}}
{{- default "zookeeper" .Values.zookeeper.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "broker.name" -}}
{{- default "broker" .Values.broker.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "connect.name" -}}
{{- default "connect" .Values.connect.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride }}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "broker.fullname" -}}
{{- if .Values.broker.fullnameOverride }}
{{- .Values.broker.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "broker" .Values.broker.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "connect.fullname" -}}
{{- if .Values.connect.fullnameOverride }}
{{- .Values.connect.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "connect" .Values.connect.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zookeeper.labels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
{{ include "zookeeper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "broker.labels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
{{ include "broker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "connect.labels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
{{ include "connect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kafka.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kafka.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "zookeeper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zookeeper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "broker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "broker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "connect.selectorLabels" -}}
app.kubernetes.io/name: {{ include "connect.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "connect.serviceName" -}}
{{- printf "%s-%s" (include "connect.fullname" .) "public" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zookeeper.headlessName" -}}
{{- printf "%s-%s" (include "zookeeper.fullname" .) "headless" }}
{{- end }}

{{- define "broker.headlessName" -}}
{{- printf "%s-%s" (include "broker.fullname" .) "headless" }}
{{- end }}

{{- define "connect.headlessName" -}}
{{- printf "%s-%s" (include "connect.fullname" .) "headless" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "zookeeper.serviceAccountName" -}}
{{- if .Values.zookeeper.serviceAccount.create }}
{{- default (include "zookeeper.fullname" .) .Values.zookeeper.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.zookeeper.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "broker.serviceAccountName" -}}
{{- if .Values.broker.serviceAccount.create }}
{{- default (include "broker.fullname" .) .Values.broker.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.broker.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "connect.serviceAccountName" -}}
{{- if .Values.connect.serviceAccount.create }}
{{- default (include "connect.fullname" .) .Values.connect.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.connect.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Kafka config templates
*/}}
{{- define "zookeeper.configmapName" -}}
{{- printf "%s-%s" (include "zookeeper.fullname" .) "configmap" }}
{{- end }}

{{- define "broker.configmapName" -}}
{{- printf "%s-%s" (include "broker.fullname" .) "configmap" }}
{{- end }}

{{- define "connect.configmapName" -}}
{{- printf "%s-%s" (include "connect.fullname" .) "configmap" }}
{{- end }}


{{/*
server.properties - zookeeper.connect
*/}}
{{- define "broker.config.zookeeper-connect" -}}
{{- range $index := until (int .Values.zookeeper.replicaCount) }}{{ include "zookeeper.fqdnWithIdx" (list $ $index) }}:2181{{- if ne (add (int $.Values.zookeeper.replicaCount) -1 ) $index }},{{- end }}{{- end }}
{{- end }}

{{- define "connect.config.bootstrap-servers" -}}
{{- range $index := until (int .Values.broker.replicaCount) }}{{ include "broker.fqdnWithIdx" (list $ $index) }}:9092{{- if ne (add (int $.Values.broker.replicaCount) -1 ) $index }},{{- end }}{{- end }}
{{- end }}

{{/*
FQDN helper functions
*/}}
{{- define "zookeeper.fqdnWithIdx" -}}
{{- $ := index . 0 }}
{{- $idx := index . 1 }}{{ include "zookeeper.fullname" $ }}-{{ $idx }}.{{ include "zookeeper.headlessName" $ }}
{{- end }}

{{- define "broker.fqdnWithIdx" -}}
{{- $ := index . 0 }}
{{- $idx := index . 1 }}{{ include "broker.fullname" $ }}-{{ $idx }}.{{ include "broker.headlessName" $ }}
{{- end }}
