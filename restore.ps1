Param([string]$arg1)

if(-not($arg1)){
    throw "Backup files postfix is required"
}

$BACKUP_DATE = $arg1


$APP_VOLUME = "mayan_app"
$DB_VOLUME = "mayan_postgres"

$APP_BACKUP_FILE_NAME = "${APP_VOLUME}-backup-${BACKUP_DATE}.tar.gz"
$DB_BACKUP_FILE_NAME = "${DB_VOLUME}-backup-${BACKUP_DATE}.tar.gz"

if (Test-Path -Path ${PWD}/$APP_BACKUP_FILE_NAME -PathType Leaf) {
    if (Test-Path -Path ${PWD}/$DB_BACKUP_FILE_NAME -PathType Leaf) {
        docker-compose stop
        # Restore:
        docker run --rm -v "${APP_VOLUME}:/data" -v "${PWD}:/backup-dir" ubuntu bash -c "rm -rf /data/{*,.*}; cd /data && tar xvzf /backup-dir/$APP_BACKUP_FILE_NAME --strip 1"
        docker run --rm -v "${DB_VOLUME}:/data" -v "${PWD}:/backup-dir" ubuntu bash -c "rm -rf /data/{*,.*}; cd /data && tar xvzf /backup-dir/$DB_BACKUP_FILE_NAME --strip 1"


        docker-compose up -d

    }
    else {
        Write-Host "Cannot restore MAYAN DB Docker Volumes. [$DB_BACKUP_FILE_NAME] file does not exist."
    }
}
else {
    Write-Host "Cannot restore MAYAN APP Docker Volumes. [$APP_BACKUP_FILE_NAME] file does not exist."
}