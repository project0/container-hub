<?php
$config['des_key'] = '{{ random.AlphaNum 24 }}';
$config['db_dsnw'] = 'sqlite:////{{ .Env.ROUNDCUBEMAIL_DB_DIR }}/sqlite.db?mode=0646';
$config['log_driver'] = 'stdout';

$config['imap_host'] = 'localhost:143';
$config['smtp_host'] = 'localhost:587';

$config['skin'] = 'larry';
$config['plugins'] = ['archive', 'zipdownload'];
$config['zipdownload_selection'] = true;

# every config can be set or overwritten by env var ROUNDCUBE_<UPPERCASE_CONFIG>