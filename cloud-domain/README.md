# Cloud-Domain: A Cloud Active Directory Domain Services for Small Businesses & Home Labs

This Docker image provides a Cloud Active Directory Domain Services (AD DS) for small businesses and home labs. It is based on Alpine Linux and includes Samba for AD DC functionality.

When the container is first run, it will create the following default AD structure:

```text
dc=realm,dc=localhost
│
├── ou=Groups
│   ├── cn=Admins
│   └── cn=Members
│   └── cn=ServiceAccounts
│
├── ou=People
│   ├── cn=alice (example, not created)
│   └── cn=bob (example, not created)
│
├── ou=Devices
│   ├── cn=tv (example, not created)
│   ├── cn=smartphone (example, not created)
│
└── ou=Services
    └── cn=externalServiceAccount (example, not created)
```

## Usage

### Environment Variables

You can customize the behavior of the container using the following environment variables:

- `REALM`: The realm for the AD DC (default: `realm.localhost`).
- `DOMAIN`: The domain for the AD DC (default: `realm`).
- `SAMBA_FS_GLOBAL_FORCE_USER`: The user to force for Samba file system (default: `oci`).
- `SAMBA_FS_GLOBAL_FORCE_GROUP`: The group to force for Samba file system (default: `oci`).
- `SAMBA_DC_ADMIN_PASSWORD`: The password for the AD DC administrator (default: `change_it`).
- `SAMBA_DC_GROUPS_OU`: The Organizational Unit for groups (default: `Groups`).
- `SAMBA_DC_PEOPLE_OU`: The Organizational Unit for people (default: `People`).
- `SAMBA_DC_DEVICES_OU`: The Organizational Unit for devices (default: `Devices`).
- `SAMBA_DC_SERVICES_OU`: The Organizational Unit for services (default: `Services`).
- `SAMBA_DC_USERS_GROUP`: The group for users (default: `Members`).
- `SAMBA_DC_ADMINS_GROUP`: The group for administrators (default: `Admins`).
- `SAMBA_DC_SERVICE_ACCOUNTS_GROUP`: The group for service accounts (default: `ServiceAccounts`).
- `SAMBA_DC_PWD_COMPLEXITY`: Enable password complexity (default: `on`).
- `SAMBA_DC_MIN_PWD_LENGTH`: Minimum password length (default: `14`).
- `SAMBA_DC_MIN_PWD_AGE`: Minimum password age (default: `0`).
- `SAMBA_DC_MAX_PWD_AGE`: Maximum password age (default: `0`).
- `SAMBA_DC_ACCOUNT_LOCKOUT_THRESHOLD`: Account lockout threshold (default: `3`).
- `SAMBA_DC_HISTORY_LENGTH`: Password history length (default: `0`).

### Example Docker Compose File

You can also use Docker Compose to manage the container. Here is an example `docker-compose.yml` file:

```yaml
version: '3'

services:
  cloud-domain:
    image: oci-cloud-domain
    container_name: oci-cloud-domain
    ports:
      - "139:139"
      - "445:445"
      - "389:389"
      - "636:636"
    volumes:
      - /path/to/shares:/shares
      - /path/to/entrypoint.d:/app/entrypoint.d
      - /path/to/samba/conf.d:/app/samba/conf.d
    environment:
      REALM: realm.localhost
      DOMAIN: realm
      SAMBA_FS_GLOBAL_FORCE_USER: oci
      SAMBA_FS_GLOBAL_FORCE_GROUP: oci
      SAMBA_DC_ADMIN_PASSWORD: change_it
      SAMBA_DC_GROUPS_OU: Groups
      SAMBA_DC_PEOPLE_OU: People
      SAMBA_DC_DEVICES_OU: Devices
      SAMBA_DC_SERVICES_OU: Services
      SAMBA_DC_USERS_GROUP: Members
      SAMBA_DC_ADMINS_GROUP: Admins
      SAMBA_DC_SERVICE_ACCOUNTS_GROUP: ServiceAccounts
      SAMBA_DC_PWD_COMPLEXITY: on
      SAMBA_DC_MIN_PWD_LENGTH: 14
      SAMBA_DC_MIN_PWD_AGE: 0
      SAMBA_DC_MAX_PWD_AGE: 0
      SAMBA_DC_ACCOUNT_LOCKOUT_THRESHOLD: 3
      SAMBA_DC_HISTORY_LENGTH: 0
```

To start the container using Docker Compose, run:

```sh
docker-compose up -d
```
