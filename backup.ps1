

$APP_VOLUME = "mayan_app"
$DB_VOLUME = "mayan_postgres"

$APP_BACKUP_FILE_NAME = "${APP_VOLUME}-backup-$(get-date -f yyyy-MM-dd).tar.gz"
$DB_BACKUP_FILE_NAME = "${DB_VOLUME}-backup-$(get-date -f yyyy-MM-dd).tar.gz"

if (-not(Test-Path -Path ${PWD}/$APP_BACKUP_FILE_NAME -PathType Leaf)) {
    if (-not(Test-Path -Path ${PWD}/$DB_BACKUP_FILE_NAME -PathType Leaf)) {
        docker-compose stop
        # Backup:
        docker run --rm -v "${APP_VOLUME}:/data" -v "${PWD}:/backup-dir" ubuntu tar cvzf /backup-dir/${APP_BACKUP_FILE_NAME} /data
        docker run --rm -v "${DB_VOLUME}:/data" -v "${PWD}:/backup-dir" ubuntu tar cvzf /backup-dir/${DB_BACKUP_FILE_NAME} /data

        docker-compose up -d
    }
    else {
        Write-Host "Cannot backup MAYAN DB Docker Volumes. [$DB_BACKUP_FILE_NAME] file already exists."
    }
}
else {
    Write-Host "Cannot backup MAYAN APP Docker Volumes. [$APP_BACKUP_FILE_NAME] file already exists."
}