# How to install

```sh
helm repo add platyplus https://charts.platyplus.io
helm repo update
```

# Charts

{% for chart in site.data.charts.entries %}

## {{ chart[0] }}

{% for versionChart in chart[1] %}

### Version: {{ versionChart.version }}

{{ versionChart.description}}

{% endfor %}

{% endfor %}
