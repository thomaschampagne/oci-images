# PyDAV

- Image based on [WsgiDAV](https://wsgidav.readthedocs.io/).

- Create `override.config.yaml` and map it to `/app/config/override.config.yaml` to override the default configuration `(/app/config/default.config.yaml`).

- `/app/config/override.config.yaml` sample:

```yaml
# Edit below yaml to override the default configuration (default.config.yaml)
# @see https://wsgidav.readthedocs.io/en/latest/user_guide_configure.html#sample-wsgidav-yaml
#---------------------------------------------------------------------------------------------

verbose: 3

logging:
    enable: true

dir_browser:
    enable: false

cors:
    allow_origin: false

http_authenticator:
    accept_basic: true
    accept_digest: true
    default_to_digest: true
    trusted_auth_header: null
    domain_controller: wsgidav.dc.simple_dc.SimpleDomainController

provider_mapping:
    "/": "/data"
    "/realm/default": "/data/realm/default"

# Additional options for SimpleDomainController only:
simple_dc:
    user_mapping:
        "*":
            "admin":
                password: "admin"
        "/realm/default":
            "default":
                password: "default"
```
