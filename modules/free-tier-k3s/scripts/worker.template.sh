#!/bin/bash
yum install epel-release -y
yum update -y
yum install jq -y

systemctl disable firewalld --now

cat << 'EOF' >> /opt/backup.sh
#!/usr/bin/env bash
source ~/.zshrc

PROFILE_NAME=DEFAULT
BACKUP_NAME=[your_manual_backup_name]
TMP_BACKUP_NAME=$$(date +%Y-%m-%d_%H-%M-%S)

echo "Running at $${TMP_BACKUP_NAME}."
echo "Getting previous backup..."

OUTPUT=$$(oci bv backup list --display-name $${BACKUP_NAME} --lifecycle-state AVAILABLE --query "data [0].{id:\"id\",id:id}" --raw-output --profile $${PROFILE_NAME})
LAST_BACKUP_ID=$$(echo $$OUTPUT | /usr/local/bin/jq -r '.id')
BLOCK_VOLUME_ID=$$(echo $$OUTPUT | /usr/local/bin/jq -r '.id')

echo "Last backup id: $$LAST_BACKUP_ID"
echo "Block volume id: $$BLOCK_VOLUME_ID"

echo "Creating new backup..."
NEW_BACKUP_ID=$$(oci bv backup create --volume-id $${BLOCK_VOLUME_ID} --type FULL --display-name $${TMP_BACKUP_NAME} --wait-for-state AVAILABLE --query "data.id" --raw-output --profile $${PROFILE_NAME})

if [ -z "$$NEW_BACKUP_ID" ]
then
    echo "New backup creation failed...Exiting script!"; exit
else
    echo "New backup id: $$NEW_BACKUP_ID"
fi

echo "Deleting old backup..."
DELETED_BACKUP=$$(oci bv backup delete --force --volume-backup-id $${LAST_BACKUP_ID} --wait-for-state TERMINATED --profile $${PROFILE_NAME})

echo "Renaming temp backup..."
RENAMED_BACKUP=$$(oci bv backup update --volume-backup-id $${NEW_BACKUP_ID} --display-name $${BACKUP_NAME} --profile $${PROFILE_NAME})

echo "Backup process complete! Goodbye!"
EOF

chmod 700 /opt/backup.sh

curl -sfL https://get.k3s.io | K3S_URL=https://server.public.main.oraclevcn.com:6443 K3S_CLUSTER_SECRET='${cluster_token}' sh -