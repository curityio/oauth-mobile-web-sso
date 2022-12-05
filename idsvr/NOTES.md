## SQL Backup

Run this command to update the backed up postgres data

```bash
docker exec -it mobileweb-curity-data-1 bash -c 'export PGPASSWORD=Password1 && pg_dump -U postgres -d idsvr' > ./idsvr/data-backup.sql
```