#!/bin/bash

function initial_config {
  env_vars=(
  "MAIL_DOMAIN"
  "SUBMISSION_HOST"
  "TLS_CERT_FILE"
  "TLS_KEY_FILE"
  )
  dovecot_staging_directory=/tmp/dovecot_staging
  dovecot_directory=/etc/dovecot

  # Check if all required variables have been set
  for each in "${env_vars[@]}"; do
    if ! [[ -v $each ]]; then
      echo "$each has not been set!"
      var_unset=true
    fi
  done

  if [ $var_unset ]; then
    echo "One or more required variables are unset. You must set them before setup can continue."
    exit 1
  fi

  echo "Preparing configuration files"
  env_vars_subst=${env_vars[@]/#/$}
  cd $dovecot_staging_directory && find . -type f -exec sh -c "cat {} | envsubst '$env_vars_subst' > $dovecot_directory/{}" \;

  echo "Setting permissions"
  addgroup -g 5000 vmail
  adduser -D -u 5000 -G vmail -s /usr/bin/nologin -h /var/mail vmail
 
  echo "Cleaning up"
  cd $dovecot_directory
  rm -r $dovecot_staging_directory
  echo 'This file is used by docker to check whether the container has already been configured' > $configured_file

}

configured_file=/etc/docker.configured
if [ -f "$configured_file" ]; then
  echo "Starting dovecot..."
else
  echo "Configuring dovecot..."
  initial_config
  echo "Done. Starting dovecot..."
fi

exec /usr/sbin/dovecot -F
