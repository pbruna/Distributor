# Primero configurar EPEL e instalar puppet
include mysql
include	httpd
include postfix
include os
include ruby

class mysql {
	package {"mysql-server":
		ensure => present,
	}
	
	package {"mysql":
		ensure => present,
	}
	
	package {"mysql-devel":
		ensure => present,
	}
	
	service {"mysqld":
		ensure => running,
		require => [Package["mysql-server"],File["/etc/hosts"]],
	}
}

class httpd {
	package {"httpd":
		ensure => present,
	}
	
	package {"httpd-devel":
		ensure => present,
	}
	
	file {"distributor.conf":
		ensure => file,
		path => "/etc/httpd/conf.d/distributor.conf",
		owner => 'root',
		group => 'root',
		source => "/etc/puppet/modules/apache/files/distributor.conf",
		require => Package["httpd"],
		notify => Service["httpd"]
	}
	
	file {"httpd.conf":
		ensure => file,
		path => "/etc/httpd/conf/httpd.conf",
		owner => 'root',
		group => 'root',
		source => "/etc/puppet/modules/apache/files/httpd.conf",
		require => Package["httpd"],
		notify => Service["httpd"]
	}
	
	service {"httpd":
		ensure => running,
		require => [Package["httpd"], Rvm_gemset['ruby-1.9.3-p0@rails-3.2']]
	}
}

class postfix {
	# package { "postfix":
	# 	ensure => installed,
	# }
	# 
	# package {"sendmail":
	# 	ensure => absent,
	# }
	# 
	# service {"postix":
	# 	ensure => running,
	# 	require => [Package["postfix"], File["/etc/hosts"]],
	# }
}

class os {
	package {"file":
		ensure => present,
	}
	
	package {"nodejs":
		ensure => present
	}
	
	package { "git":
		ensure => installed,
	}

	package {"sqlite":
		ensure => present,
	}

	package {"sqlite-devel":
		ensure => present,
	}
	
	package { "vim-enhanced":
		ensure => installed,
	}
	
	package { "monit":
		ensure => installed,
	}
	
	file { "/etc/hosts":
		ensure => file,
		owner => 'root',
		group => 'root',
		content => "${::ipaddress}\t ${::fqdn}\t ${::hostname}\n127.0.0.1\tlocalhost.localdomain\tlocalhost\n"
	}
	
}

class ruby {
	include rvm
	rvm_system_ruby {
		'ruby-1.9.3-p0':
		    ensure => 'present',
			require =>  Exec["update_rvm"],
		    default_use => true;
	}
	
	exec { "update_rvm":
		command => "/usr/local/rvm/bin/rvm get head && /usr/local/rvm/bin/rvm reload",
		creates => "/var/lib/update_rvm",
		onlyif => "/usr/local/rvm/bin/rvm",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		#refreshonly => true,
	}
	
	rvm_gemset {
		'ruby-1.9.3-p0@rails-3.2':
			ensure => present,
			require => [Rvm_system_ruby['ruby-1.9.3-p0']];
	}
	
	rvm_gem {
		'ruby-1.9.3-p0@rails-3.2/rails':
			ensure => present,
			require => Rvm_gemset['ruby-1.9.3-p0@rails-3.2'];
	}
	
	rvm_gem {
		'ruby-1.9.3-p0@rails-3.2/puppet':
			ensure => present,
			require => Rvm_gemset['ruby-1.9.3-p0@rails-3.2'];
	}

	class {
	  'rvm::passenger::apache':
	    version => '3.0.12',
	    ruby_version => 'ruby-1.9.3-p0@rails-3.2',
	    mininstances => '3',
	    maxinstancesperapp => '0',
	    maxpoolsize => '30',
	    spawnmethod => 'smart-lv2',
		require => [Package['httpd-devel'], Rvm_gemset['ruby-1.9.3-p0@rails-3.2']],
		notify => Service["httpd"];
	}
	
}
