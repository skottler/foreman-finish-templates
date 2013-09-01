#! /bin/bash

ROOT_SSH="/root/.ssh"
FEDORA_SSH="/home/fedora/.ssh"

# If we have a recovery key for the host, install it.
<% if @host.params["root_ssh_pubkey"] -%>
if [ ! -e $ROOT_SSH ]; then
mkdir $ROOT_SSH
fi

echo <%= @host.params["root_ssh_pubkey"] %> > $ROOT_SSH/authorized_keys

if [ -e /home/fedora ]; then
  if [ ! -e $FEDORA_SSH ]; then
    mkdir $FEDORA_SSH
  fi
  echo <%= @host.params["root_ssh_pubkey"] %> > $FEDORA_SSH/authorized_keys
fi

<% end -%>

<% if @host.capabilities.include?(:image) -%>
echo "HOSTNAME=<%= @host %>" >> /etc/sysconfig/network
hostname <%= @host %>
<% end %>

<% if @host.operatingsystem.major.to_i == 6 %>
yum install -y https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
<% end %>

# Some random niceties.
yum install -y htop vim

<% if @host.operatingsystem.major.to_i == 6 %>
yum install -y http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
<% else %>
yum install -y https://yum.puppetlabs.com/fedora/f19/products/x86_64/puppetlabs-release-19-2.noarch.rpm
<% end %>
yum update -y
yum -t -y -e 0 install puppet

echo "Configuring puppet"
cat > /etc/puppet/puppet.conf << EOF
<%= snippets "puppet.conf" %>
EOF

echo "<%= @puppetmaster_ip %> puppet" >> /etc/hosts

# Setup puppet to run on system reboot
/sbin/chkconfig --level 345 puppet on

/usr/bin/puppet agent --waitforcert 60 -t

# Isn't puppet awesome, you guys?! Hopefully two runs leads to convergence.
/usr/bin/puppet agent -t
exit 0
