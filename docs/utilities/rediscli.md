Delete all
`redis-cli > FLUSHALL ; zservice_server restart

Get hash keys
`hgetall ui-gce-va-1.broadsign.iponweb.net:zabbix_triggers 

Get type of record
`type ui-gce-va-1.broadsign.iponweb.net:zabbix_prototype_triggers 

Get all keys with specified pattern
`KEYS ui-gce-va-1*
