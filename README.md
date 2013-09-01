foreman-finish-templates
========================

Fedora + RHEL provisioning templates for use with Foreman. This is just my personal repository, you should check out [the official community template repo](https://github.com/theforeman/community-templates/).

## Usage
### Important parameters

These parameters should be set somewhere in the parameter hierarchy (globally, domain, hostgroup, host, etc.).

`puppetmaster_ip`: The IP address of the puppetmaster that the host being provisioned will utilize.
`root_ssh_pubkey` (optional): the pubkey of a recovery key that can be used early in the provisioning process to access the host being provisioned. This is useful for tweaking the contents of a provisioning template and watching the result.

### Snippets
There is a template in this repository that should be configured as a snippet: `puppet.confx` Make sure to add it to your Foreman instance.
