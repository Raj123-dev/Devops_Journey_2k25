{{/* Generate a name for resources */}}
{{- define "flask-app.name" -}}
flask-app
{{- end -}}

{{- define "flask-app.fullname" -}}
{{ include "flask-app.name" . }}
{{- end -}}
