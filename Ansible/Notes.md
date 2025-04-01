# Ansible Components and Best Practices

## Ansible Components

1. **Ansible installed on host**
2. **Inventory file**
3. **Managed Nodes**

## Inventory File

- Can be in YAML or INI format

### Definitions

- **metagroups**: Organize multiple groups in your inventory
- **vars**: Variables set values for managed nodes

### Best Practices

- Have inventory files for different environments
- Organize inventory files based on what, where, and when

## Playbook

At a minimum, each play defines two things:

1. The managed nodes to target, using a pattern
2. At least one task to execute

## Check Mode

Ansible’s check mode allows you to execute a playbook without applying any alterations to your systems. You can use check mode to test playbooks before implementing them in a production environment.

```sh
ansible-playbook --check playbook.yaml
```

You can use `ansible-lint` for detailed, Ansible-specific feedback on your playbooks before you execute them
