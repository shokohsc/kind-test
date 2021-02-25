# Kind test cluster

kubectl create secret \
-n postgresql \
--dry-run=client \
-o yaml \
generic \
postgresql \
--from-literal=postgresql-postgres-password=my_password \
--from-literal=postgresql-password=my_password \
--from-literal=postgresql-replication-password=my_password | kubeseal -o yaml > sealed-secret.yaml
