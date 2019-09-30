#!/bin/sh

mysql -e "UPDATE mysql.user SET Password = PASSWORD('slurmpass') WHERE User = 'root'" 

# Kill the anonymous users 
mysql -e "DROP USER ''@'localhost'" 

#To disallow remote login for root 
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"

# Because our hostname varies we'll use some Bash magic here. 
mysql -e "DROP USER ''@'$(hostname)'" 

# Kill off the demo database 
mysql -e "DROP DATABASE test" 

# Make our changes take effect 
mysql -e "FLUSH PRIVILEGES"

#create slurm database
mysql -pslurmpass -e "grant all on slurm_acct_db.* TO 'slurm'@'localhost' identified by 'slurmpass' with grant option"
#mysql -pslurmpass -e "SHOW VARIABLES LIKE 'have_innodb'"
mysql -pslurmpass -e "create database slurm_acct_db"

cat > /etc/my.cnf.d/innodb.cnf << 'EOF'
[mysqld] 
innodb_buffer_pool_size=6144M
innodb_log_file_size=64M 
innodb_lock_wait_timeout=900
EOF
