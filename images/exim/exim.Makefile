# https://github.com/Exim/exim/blob/master/src/src/EDITME
CFLAGS  += -I/build/usr/include

BIN_DIRECTORY=/usr/bin
CONFIGURE_FILE=/etc/exim/exim.conf
EXIM_USER=ref:exim
SPOOL_DIRECTORY=/var/spool/exim

ROUTER_ACCEPT=yes
ROUTER_DNSLOOKUP=yes
ROUTER_IPLITERAL=yes
ROUTER_MANUALROUTE=yes
ROUTER_QUERYPROGRAM=yes
ROUTER_REDIRECT=yes

TRANSPORT_APPENDFILE=yes
TRANSPORT_AUTOREPLY=yes
TRANSPORT_PIPE=yes
TRANSPORT_SMTP=yes
TRANSPORT_LMTP=yes

SUPPORT_MAILDIR=yes

LOOKUP_DBM=yes
LOOKUP_LSEARCH=yes
LOOKUP_DNSDB=yes
LOOKUP_DSEARCH=yes
LOOKUP_MYSQL=yes
# LOOKUP_MYSQL_PC=mariadb
LOOKUP_INCLUDE=-I /usr/include/mysql
LOOKUP_LIBS=-L /usr/lib64/mysql -lmysqlclient

PCRE2_CONFIG=yes
SUPPORT_DANE=yes


WITH_CONTENT_SCAN=yes
# These scanners are claimed to be no longer existent.
DISABLE_MAL_AVE=yes
DISABLE_MAL_KAV=yes
DISABLE_MAL_MKS=yes

FIXED_NEVER_USERS=root

AUTH_CRAM_MD5=yes
AUTH_DOVECOT=yes
AUTH_PLAINTEXT=yes
AUTH_TLS=yes

HEADERS_CHARSET="ISO-8859-1"

SUPPORT_TLS=yes
# Uncomment one of these settings if you are using OpenSSL; pkg-config vs not
# USE_OPENSSL_PC=openssl
USE_OPENSSL=yes
TLS_LIBS=-lssl -lcrypto

LOG_FILE_PATH=/var/log/exim/%slog
SYSLOG_LOG_PID=yes
EXICYCLOG_MAX=10
COMPRESS_COMMAND=/usr/bin/gzip
COMPRESS_SUFFIX=gz
ZCAT_COMMAND=/usr/bin/zcat

SUPPORT_I18N=yes
SUPPORT_I18N_2008=yes
LDFLAGS += -lidn -lidn2

SUPPORT_SPF=yes
LDFLAGS += -L/build/usr/lib64 -lspf2

EXPERIMENTAL_ARC=ye

SUPPORT_SRS=yes
SUPPORT_DMARC=yes
# DMARC_API=100400
CFLAGS += -I/usr/local/include
LDFLAGS += -lopendmarc

SYSTEM_ALIASES_FILE=/etc/aliases
HAVE_IPV6=yes
EXIM_TMPDIR="/tmp"
MAX_NAMED_LIST=16
PID_FILE_PATH=/var/run/exim.pid