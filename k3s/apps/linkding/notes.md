# Linkding with postgresql using cloudnative-pg operator


```text
❯ k cnpg status linkding-db-production-cnpg-v1 --verbose
Cluster Summary
Name                 linkding/linkding-db-production-cnpg-v1
System ID:           7477561069837893650
PostgreSQL Image:    quay.io/enterprisedb/postgresql:16.1
Primary instance:    linkding-db-production-cnpg-v1-1
Primary start time:  2025-03-03 12:36:08 +0000 UTC (uptime 7h55m22s)
Status:              Cluster in healthy state
Instances:           3
Ready instances:     3
Size:                192M
Current Write LSN:   0/A000060 (Timeline: 1 - WAL File: 00000001000000000000000A)

Continuous Backup status
Not configured

Physical backups
No running physical backups found

Streaming Replication status
Replication Slots Enabled
Name                              Sent LSN   Write LSN  Flush LSN  Replay LSN  Write Lag  Flush Lag  Replay Lag  State      Sync State  Sync Priority  Replication Slot  Slot Restart LSN  Slot WAL Status  Slot Safe WAL Size
----                              --------   ---------  ---------  ----------  ---------  ---------  ----------  -----      ----------  -------------  ----------------  ----------------  ---------------  ------------------
linkding-db-production-cnpg-v1-2  0/A000060  0/A000060  0/A000060  0/A000060   00:00:00   00:00:00   00:00:00    streaming  async       0              active            0/A000060         reserved         NULL
linkding-db-production-cnpg-v1-3  0/A000060  0/A000060  0/A000060  0/A000060   00:00:00   00:00:00   00:00:00    streaming  async       0              active            0/A000060         reserved         NULL

Unmanaged Replication Slot Status
No unmanaged replication slots found

Managed roles status
No roles managed

Tablespaces status
No managed tablespaces

Pod Disruption Budgets status
Name                                    Role     Expected Pods  Current Healthy  Minimum Desired Healthy  Disruptions Allowed
----                                    ----     -------------  ---------------  -----------------------  -------------------
linkding-db-production-cnpg-v1          replica  2              2                1                        1
linkding-db-production-cnpg-v1-primary  primary  1              1                1                        0

Instances status
Name                              Current LSN  Replication role  Status  QoS        Manager Version  Node
----                              -----------  ----------------  ------  ---        ---------------  ----
linkding-db-production-cnpg-v1-1  0/A000060    Primary           OK      Burstable  1.25.1           k3s-04
linkding-db-production-cnpg-v1-2  0/A000060    Standby (async)   OK      Burstable  1.25.1           k3s-02
linkding-db-production-cnpg-v1-3  0/A000060    Standby (async)   OK      Burstable  1.25.1           k3s-03

Plugins status
No plugins found
```
