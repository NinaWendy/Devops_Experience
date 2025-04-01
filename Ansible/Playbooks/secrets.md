# Secrets Management

In `secrets1.yaml` and `secrets2.yaml`, the variables `ansible_become_password` and `ansible_become_password_alt` are defined. The playbook sets the `ansible_become_password` variable to the value of `ansible_become_password` if it is defined, otherwise it sets it to the value of `ansible_become_password_alt`. This allows the playbook to dynamically set the sudo password based on the value of the variables defined in the secrets files.

To create and add content to the secrets files, follow these steps:

1. Create the `secrets1.yaml` file using Ansible Vault:

```sh
ansible-vault create secrets1.yaml
```

2. Add the following content to the `secrets1.yaml` file:

```yaml
---
ansible_become_password: "password1"
```

3. Create the `secrets2.yaml` file using Ansible Vault:

```sh
ansible-vault create secrets2.yaml
```

4. Add the following content to the `secrets2.yaml` file:

```yaml
---
ansible_become_password_alt: "password2"
```

Dry Run

```sh
ansible-playbook -i inventory_production.yaml playbook.yaml --ask-vault-pass --check
```
