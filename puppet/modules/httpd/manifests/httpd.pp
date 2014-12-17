$untar_loc = "/tmp/httpd.tar.gz"
$extract_dir = "/tmp/httpd-2.4.10"

case $operatingsystem {
    'Redhat', 'CentOS': {
 	$path_httpd = "/etc/httpd" 
     }
     /^(Debian|Ubuntu)$/: {
        $path_httpd = "/etc/apache2"
     }
     default: { 
        $path_httpd = "/etc/httpd"
     }
}

exec {"apps_wget":
	command => "/usr/bin/wget http://www.apache.org/dist/httpd/httpd-2.4.10.tar.gz -O ${untar_loc}", 
	onlyif => "/bin/test ! -f ${untar_loc}",
	
    } ->

exec {"apps_untar":
	command => "/bin/tar -zxvf ${untar_loc} -C /tmp",
        onlyif => "/bin/test ! -f ${extract_dir}",
    } ->

exec {"configure": 
        command => "/bin/cd /tmp/httpd-2.4.10/; /tmp/httpd-2.4.10/configure --prefix=${path_httpd}",
    } -> 

exec {"make": 
        command => "/bin/cd /tmp/httpd-2.4.10/; make",
    } ->

exec {"make_install": 
        command => "/bin/cd /tmp/httpd-2.4.10/; make install",
    } ->

service { "httpd":
        ensure  => running,
        start   => "${path_httpd}/bin/apachectl start",
        stop    => "${path_httpd}/bin/apachectl stop",
}  
