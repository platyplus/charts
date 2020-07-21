# Tilehuria Helm Chart

## Requirements

- A kubernetes cluster
- Cert-manager 0.15 installed in the `cert-manager` namespace
- Traefik 2 installed in the `traefik` namespace
- DNS records pointing to the cluster: example.org, hbp.example.org and hasura.example.org

## Installation

```sh
helm install tilehuria tilehuria --repo https://charts.platyplus.io --set global.hostname=example.org
```

## Configuration

Please have a look at the Helm Chart source for further configuration
