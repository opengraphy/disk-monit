#!/bin/bash

# $1 aws_access_key_id
# $2 aws_secret_access_key
# $3 fromEmail
# $4 toEmails sparated by coma (no space). Ex: admin1@domain.com,admin2@domain.com

sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'User for managing disk monit' \
   --group \
   --disabled-password \
   --home /home/disk-monit \
   disk-monit

sudo apt-get install awscli -y

AWS_FOLDER=/home/disk-monit/.aws
if [[ ! -d "$AWS_FOLDER" ]]; then
  CREDENTIALS=$AWS_FOLDER/credentials
  CONFIG=$AWS_FOLDER/config
  LOG=/var/log/disk-monit.log
  sudo mkdir $AWS_FOLDER
  echo "[default]" >> $CREDENTIALS
  echo "aws_secret_access_key = $2" >> $CREDENTIALS
  echo "aws_access_key_id = $1" >> $CREDENTIALS
  echo "[default]" >> $CONFIG
  echo "region = eu-west-1" >> $CONFIG
  echo "output = text" >> $CONFIG
  echo "-- BEGIN LOG --" >> $LOG
  sudo chown -R disk-monit:disk-monit $AWS_FOLDER
  sudo chown disk-monit:disk-monit $LOG
fi

CRONTAB=/var/spool/cron/crontabs/disk-monit
if [[ ! -f "$CRONTAB" ]]; then
  echo "* * * * * sh /home/disk-monit/disk-monit.sh  > /var/log/disk-monit.log 2>&1" >> $CRONTAB
  sudo chown -R disk-monit:crontab $CRONTAB
  sudo chmod 600 $CRONTAB
fi

echo IyEvYmluL3NoCgp0b0VtYWlsPSdbQEBAZW1haWxzQEBAXScKZnJvbUVtYWlsPSdAQEBmcm9tRW1haWxAQEAnCkFXU19JTlNUQU5DRV9JRD1gY3VybCAtcyBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaW5zdGFuY2UtaWRgCkVDMl9OQU1FPSQoYXdzIGVjMiBkZXNjcmliZS10YWdzIC0tcmVnaW9uIGV1LXdlc3QtMSAtLWZpbHRlcnMgIk5hbWU9cmVzb3VyY2UtaWQsVmFsdWVzPSRBV1NfSU5TVEFOQ0VfSUQiICJOYW1lPWtleSxWYWx1ZXM9TmFtZSIgLS1vdXRwdXQgdGV4dCB8IGN1dCAtZjUpCiNlY2hvICRFQzJfTkFNRQpjdXJyZW50SVA9JChjdXJsIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9wdWJsaWMtaXB2NCkKCiMgd2hpbGUgdHJ1ZTsgZG8KZGF0ZT0kKGRhdGUgKyIlcyIpCgojU0VUIERBVEUgVE8gTE9HCmVtYWlsVGltZW91dFdyaXRlICgpCnsKICBpZiBbICEgLWYgIiRQV0QvJDEiIF07IHRoZW4KICAgIHRvdWNoICRQV0QvJDEudHh0CiAgZmkKICBzaCAtYyAiZWNobyAkZGF0ZSA+ICRQV0QvJDEudHh0Igp9CiMgU0VORCBBTUFaT04gU0VTCnNlbmRBbWF6b25TZXMgKCkKewogIGF3cyBzZXMgc2VuZC1lbWFpbCBcCiAgLS1mcm9tICRmcm9tRW1haWwgXAogIC0tZGVzdGluYXRpb24gVG9BZGRyZXNzZXM9JHRvRW1haWwgXAogIC0tbWVzc2FnZSAneyAiU3ViamVjdCI6IHsgIkRhdGEiOiAiW0FMRVJUIFNFUlZFUl0gJyIkRUMyX05BTUUiJyB8IElQOiAnIiRjdXJyZW50SVAiJyB8ICciJDEiJyIsICJDaGFyc2V0IjogIlVURi04IiB9LCAiQm9keSI6IHsgIlRleHQiOiB7ICJEYXRhIjogIiciJDIiJyIsICJDaGFyc2V0IjogIlVURi04IiB9IH0gfScKfQojIGVtYWlsVGltZW91dFdyaXRlICJtZXNzYWdlRGlza1VzZWRfc2VudCIKCiMgTU9OSVRPUiBESVNLIFNQQUNFCmNoZWNrVHlwZXM9JChsc2JsayAtbyBGU1RZUEUpCm1lc3NhZ2U9IiIKZm9yIGMgaW4gJGNoZWNrVHlwZXM7IGRvCiAgaWYgWyAiJGMiID0gImV4dDQiIF0gfHwgWyAiJGMiID0gInhmcyIgXTsgdGhlbgoKICAgIGRpc2s9JChkZiAtdCAkYyB8IGF3ayAne3ByaW50ICQxfScpCiAgICAjZWNobyAkZGlzawogICAgY3VycmVudERpc2s9JChlY2hvICRkaXNrIHwgYXdrICd7cHJpbnQgJDJ9JykKICAgICMgZWNobyAkY3VycmVudERpc2sKCiAgICBwb3VyY2VudGFnZT05MAogICAgIyB0b3RhbFNwYWNlPSQoZGYgfCBncmVwICIkY3VycmVudERpc2siIHwgYXdrICd7cHJpbnQgJDJ9JykKICAgICMgZWNobyAkdG90YWxTcGFjZQogICAgIyBtYXhTcGFjZT0kKCgoJHRvdGFsU3BhY2UgKiAkcG91cmNlbnRhZ2UpLzEwMCkpCiAgICAjIGVjaG8gJHRvdGFsU3BhY2UKCiAgICAjIHVzZWRTcGFjZT0kKGRmIHwgZ3JlcCAiJGN1cnJlbnREaXNrIiB8IGF3ayAne3ByaW50ICQ0fScpCiAgICAjIGVjaG8gJHVzZWRTcGFjZQogICAgcG91cmNlbnRVc2VkPSQoZGYgfCBncmVwICIkY3VycmVudERpc2siIHwgYXdrICd7cHJpbnQgJDV9JykKICAgIHBvdXJjZW50VXNlZG5vUGVyY2VudD0kKGVjaG8gJHBvdXJjZW50VXNlZCB8IHNlZCAncy8lLy8nKQoKICAgIGlmIFsgJHBvdXJjZW50VXNlZG5vUGVyY2VudCAtZ3QgJHBvdXJjZW50YWdlIF07IHRoZW4KICAgICAgbWVzc2FnZT0iJG1lc3NhZ2UgXG4gJGN1cnJlbnREaXNrIC0gJHBvdXJjZW50VXNlZCIKICAgICAgIyBSRUFEIExPRyBJRiBFWElTVFMKICAgICAgaWYgWyAtZiAiJFBXRC9tZXNzYWdlRGlza1VzZWQudHh0IiBdOyB0aGVuCiAgICAgICAgbWVzc2FnZURpc2tMYXN0U2VudD0kKGNhdCAkUFdEL21lc3NhZ2VEaXNrVXNlZC50eHQpCiAgICAgICAgZGlza1RpbW91dD0kKCg0ICogMzYwMCkpCiAgICAgICAgIyBkaXNrVGltb3V0PSQoKDEyMCkpCiAgICAgICAgbWVzc2FnZURpc2tOZXh0U2VudD0kKCgkbWVzc2FnZURpc2tMYXN0U2VudCArICRkaXNrVGltb3V0KSkKICAgICAgZmkKICAgIGZpCiAgZmkKZG9uZQoKIyBpZiBtZXNzYWdlIG5vdCBlbXB0eQppZiBbICEgLXogIiRtZXNzYWdlIiBdOyB0aGVuCiAgIyBJRiBOTyBMT0cgT1IgREFURSBHUkVBVEVSIFRIQU4gTkVYVCBTRU5UIC0+IFNFTkQgTUVTU0FHRSBBTkQgRURJVCBMT0cKICBpZiBbICEgJG1lc3NhZ2VEaXNrTmV4dFNlbnQgXSB8fCBbICRkYXRlIC1ndCAkbWVzc2FnZURpc2tOZXh0U2VudCBdOyB0aGVuCiAgICAjIGVjaG8gJ1NlbmQgZW1haWwgZm9yIERJU0sgRVJST1InCiAgICBzZW5kQW1hem9uU2VzICJEaXNrIFVzYWdlIG92ZXIgOTAlIiAiU2VydmVyIG5hbWU6ICRFQzJfTkFNRSBcbiBJUDogJGN1cnJlbnRJUCBcbiBFcnJvcjogRGlzayB1c2FnZSBvdmVyIDkwJSAkbWVzc2FnZSIKICAgIGVtYWlsVGltZW91dFdyaXRlICJtZXNzYWdlRGlza1VzZWQiCiAgZmkKZWxzZQogICMgZWNobyAnRGlzayBPaycKICAjIEVWRVJZVEhJTkcgT0sgLT4gREVMRVRFIExPRwogIGlmIFsgLWYgIiRQV0QvbWVzc2FnZURpc2tVc2VkLnR4dCIgXTsgdGhlbgogICAgcm0gJFBXRC9tZXNzYWdlRGlza1VzZWQudHh0CiAgZmkKZmkKCgojIE1PTklUT1IgU1dBUApzd2FwUGVyY2VudD05MApjaGVja1N3YXA9JCgvc2Jpbi9zd2Fwb24gLXMpCmlmIFsgISAteiAiJGNoZWNrU3dhcCIgXTsgdGhlbgogIHN3YXBVc2VkPSQoZnJlZSAtdCB8IGF3ayAnTlIgPT0gMyB7cHJpbnRmKCIlLjJmJSIpLCAkMy8kMioxMDB9JykKICBzd2FwTm9QZXJjZW50PSQoZWNobyAkc3dhcFVzZWQgfCBzZWQgJ3MvJS8vJykKICByb3VuZGVkU3dhcD0ke3N3YXBOb1BlcmNlbnQlLip9CiAgIyBlY2hvICRyb3VuZGVkU3dhcAogIGlmIFsgJHJvdW5kZWRTd2FwIC1nZSAkc3dhcFBlcmNlbnQgXTsgdGhlbgogICAgIyBSRUFEIExPRyBJRiBFWElTVFMKICAgIGlmIFsgLWYgIiRQV0QvbWVzc2FnZVN3YXBVc2VkX3NlbnQudHh0IiBdOyB0aGVuCiAgICAgIG1lc3NhZ2VTd2FwVXNlZFNlbnQ9JChjYXQgJFBXRC9tZXNzYWdlU3dhcFVzZWRfc2VudC50eHQpCiAgICAgIHN3YXBUaW1vdXQ9JCgoNCAqIDM2MDApKQogICAgICAjIGRpc2tUaW1vdXQ9JCgoMTIwKSkKICAgICAgbWVzc2FnZVN3YXBOZXh0U2VudD0kKCgkbWVzc2FnZVN3YXBVc2VkU2VudCArICRzd2FwVGltb3V0KSkKICAgICAgIyBlY2hvICRtZXNzYWdlU3dhcE5leHRTZW50CiAgICBmaQogICAgIyBJRiBOTyBMT0cgT1IgREFURSBHUkVBVEVSIFRIQU4gTkVYVCBTRU5UIC0+IFNFTkQgTUVTU0FHRSBBTkQgRURJVCBMT0cKICAgIGlmIFsgISAkbWVzc2FnZVN3YXBOZXh0U2VudCBdIHx8IFsgJGRhdGUgLWd0ICRtZXNzYWdlU3dhcE5leHRTZW50IF07IHRoZW4KICAgICAgIyBlY2hvICdTZW5kIGVtYWlsIGZvciBTd2FwIEVSUk9SJwogICAgICBzZW5kQW1hem9uU2VzICJTd2FwIFVzYWdlIG92ZXIgOTAlIiAiU3dhcCB1c2FnZTogJHN3YXBVc2VkIgogICAgICBlbWFpbFRpbWVvdXRXcml0ZSAibWVzc2FnZVN3YXBVc2VkX3NlbnQiCiAgICBmaQogIGVsc2UKICAgICMgZWNobyAnU3dhcCBPaycKICAgICMgRVZFUllUSElORyBPSyAtPiBERUxFVEUgTE9HCiAgICBpZiBbIC1mICIkUFdEL21lc3NhZ2VTd2FwVXNlZF9zZW50IiBdOyB0aGVuCiAgICAgIHJtICRQV0QvbWVzc2FnZVN3YXBVc2VkX3NlbnQKICAgIGZpCiAgZmkKZmkK | base64 --decode >> /home/disk-monit/disk-monit.sh.model

EMAILS="$4"
#Print the split string
toEmails=$(echo "$EMAILS" | sed -r 's/,/","/g')
toEmails='"'$toEmails'"'
fromEmail="$3"

if [[ -f "/home/disk-monit/disk-monit.sh" ]]; then
  sudo rm /home/disk-monit/disk-monit.sh
fi
sed 's/@@@fromEmail@@@/'$fromEmail'/g' /home/disk-monit/disk-monit.sh.model > /home/disk-monit/disk-monit.sh.model2
sed 's/@@@emails@@@/'$toEmails'/g' /home/disk-monit/disk-monit.sh.model2 > /home/disk-monit/disk-monit.sh
sudo rm /home/disk-monit/disk-monit.sh.model /home/disk-monit/disk-monit.sh.model2 

sudo chmod +x /home/disk-monit/disk-monit.sh
sudo chown -R disk-monit:disk-monit /home/disk-monit/disk-monit.sh
