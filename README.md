# disk-monit

sudo su\
cd\
git clone https://github.com/opengraphy/disk-monit.git \
cd disk-monit\
./install-disk-monit.sh $1 $2 $3 $4\
\
$1 aws_access_key_id\
$2 aws_secret_access_key\
$3 fromEmail\
$4 toEmails sparated by coma (no space). Ex: admin1@domain.com,admin2@domain.com

IAM user need to have AmazonSESFullAccess and DescribeTags perms\
fromEmail and toEmails need to be registered to SES Amazon.
