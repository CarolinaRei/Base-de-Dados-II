drop database link query_link;

create database link query_link connect to oltp_query identified by oltp_query
using
'
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = bd.ipg.pt)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = oltp)
    )
  )';