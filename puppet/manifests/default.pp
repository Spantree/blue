hiera_include('classes')

node default {

  $task = '/usr/local/bin/backup-to-s3.sh'

  file { $task:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/local_files/backup-to-s3.sh',
  }

  cron { $task:
    ensure  => present,
    command => "$task 2>&1 > /var/log/backup-to-s3.log",
    user    => 'root',
    minute    => ['0'],
  }
}
