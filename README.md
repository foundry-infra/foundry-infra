# foundry-infra

_An expensive way to run Foundry-VTT._

This project is my own personal cloud infrastructure for running my Foundry-VTT games. It also includes a batteries-included app platform.

## Implementation Notes

This repo is mostly Terragrunt (modules and infras) with a single enviroment, and takes great advantage of dependencies. 
A few convenient dev dependencies install with npm. 
This infra is (almost) built exclusively on DigitalOcean. 
A single multi-tenant [DOK cluster][dok] runs all workloads. 
The cluster currently runs two ["tenant"][goldengulp] Foundry-VTT instances, and and a whole-lot of platform components. 
Each app has subdomain domain that is [managed with ExternalDNS][external_dns]. 
The load balancer terminates TLS at the [kubernetes-nginx-ingress controller][ingress]. 
The certificates themselves are auto-rotated with [Cert-Manager][cert_manager]. 
The one exception is the [HashiCorp Vault][vault] server which does SSL-passthrough and terminates its own TLS. 
The workloads have secrets automatically injected by Vault using the sidecar init container. 
Additionally, each instance runs with an [oauth2-proxy][oauth2_proxy] configured to only allow certain users (my players!) all via an external OIDC provider (currently Auth0).   

## Todos

- [ ] Migrate off of Auth0 and onto a self-hosted Keycloak
- [ ] Create Gemini backups for the Foundry-VTT instances
- [ ] Add the awsconfig.json secret to Foundry-VTT instances
- [ ] Setup GitHub auth on Vault in new terraform module
- [ ] The Foundry Helm chart needs a lot of love and tidying
- [ ] DRY up the Foundry-VTT modules, there are many modules
- [ ] DRY up the app platform, there are many modules

## Attributions

- Would not have gotten started on Foundry-VTT self-hosting if not for [Felddy docker project][felddy_docker]. Much appreciated @felddy.
- I was able to get going on Kubernetes by building on top of [hugoprudente's helm chart][hugoprudente]. Thanks @hugoprudente. 

[oauth2_proxy]: /live/frost_wind_terror_oauth2_proxy
[vault]: /live/vault
[cert_manager]: /live/cert_manager
[ingress]: /live/ingress
[goldengulp]: /live/goldengulp
[dok]: /live/k8s
[external_dns]: /live/external_dns
[felddy_docker]: https://github.com/felddy/foundryvtt-docker
[hugoprudente]: https://github.com/hugoprudente/foundry-vtt
