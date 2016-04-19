node default {
  include apt
  include vim
  include git
  include java
}

package { 'curl':
  ensure => installed
}

class { 'ruby':
  version => '2.2.0'
}

class { 'ruby::dev': }

class { "elasticsearch":
  status       => 'enabled',
  manage_repo  => true,
  repo_version => '2.x',
  version      => '2.3.0',
  config       => {
    "path.conf"                   => "/etc/elasticsearch",
    "path.data"                   => "/var/lib/elasticsearch",
    "gateway.expected_nodes"      => 1,
    "gateway.recover_after_nodes" => 1
  }
}

elasticsearch::instance { 'primary':
  ensure => present,
  status => 'enabled',
  config => { "node.name" => "el-example" }
}

elasticsearch::plugin { 'license':
  instances => 'primary'
}

elasticsearch::plugin { 'marvel-agent':
  instances => 'primary',
  require   => Elasticsearch::Plugin['license']
}

elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
  instances => 'primary'
}

# add logstash repository to /etc/apt/sources.list.d/
apt::source { 'logstash':
  comment     => 'This is the official logstash repository',
  location    => 'http://packages.elasticsearch.org/logstash/2.3/debian/',
  repos       => 'main',
  release     => 'stable',
  key         => 'D88E42B4',
  include_src => false
} -> class { "logstash": }


# Kibana

file { '/usr/share/kibana':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}

exec { 'download_kibana':
  command => '/usr/bin/curl -L https://download.elasticsearch.org/kibana/kibana/kibana-4.5.0-linux-x64.tar.gz | /bin/tar xvz -C /usr/share/kibana',
  require => [ Package['curl'], File['/usr/share/kibana'], Class['elasticsearch'] ],
}

file { '/etc/init.d/kibana':
  ensure  => 'present',
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => template('custom/kibana'),
  require => [ Exec['download_kibana'] ]
}

service { 'kibana':
  name    => 'kibana',
  ensure  => 'running',
  require => File['/etc/init.d/kibana'],
}

Package['java'] -> Package['elasticsearch']
Package['java'] -> Package['logstash']
