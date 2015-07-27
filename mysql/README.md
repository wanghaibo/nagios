# nagios plugin source
    https://github.com/wanghaibo/nagios-mysql
# depend
    ```Shell
    yum -y install perl-Params-Validate perl-Math-Calc-Units perl-Regexp-Commonperl-Class-Accessor perl-Config-Tiny perl-Nagios-Plugin.noarch
    ```
# add mysql nagios account
    ```Shell
    create user 'nagios'@'your_nagios_server' identified by 'nagios';
    grant usage on *.* to nagios@'your_nagios_server' identified by 'nagios';
    ```
# usage 
    ```
    command[check_mysql_commands]=/usr/lib64/nagios/plugins/check_mysql_commands -H localhost -u testuser -p password 
    command[check_mysql_connections]=/usr/lib64/nagios/plugins/check_mysql_connections -H localhost -u testuser -p password -w 75 -c 90
    command[check_mysql_selects]=/usr/lib64/nagios/plugins/check_mysql_selects -H localhost -u testuser -p password
    ```
