# PlatyPlus Helm Charts

## How to install

```sh
helm repo add platyplus https://charts.platyplus.io
helm repo update
```

## Charts

{% for chart in site.data.charts.entries %}

### {{ chart }}

#### {{ chart[0] }}

#### {{ chart[1] }}

{% endfor %}
