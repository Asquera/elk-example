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
  version => '2.0.0'
}

class { 'ruby::dev': }

class { "elasticsearch":
  status       => 'enabled',
  manage_repo  => true,
  repo_version => '1.4',
  version      => '1.4.2',
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

# add logstash repository to /etc/apt/sources.list.d/
apt::source { 'logstash':
  comment     => 'This is the official logstash repository',
  location    => 'http://packages.elasticsearch.org/logstash/1.3/debian/',
  repos       => 'main',
  release     => 'stable',
  key         => 'D88E42B4',
  include_src => false
} -> class { "logstash": }

# file { "/etc/init.d/logstash":
#   ensure  => absent,
#   require => Class['logstash']
# }

# file { "/etc/init.d/logstash-web":
#   ensure  => absent,
#   require => Class['logstash']
# }

Package['java'] -> Package['elasticsearch']
Package['java'] -> Package['logstash']
