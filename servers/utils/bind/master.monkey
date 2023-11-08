$TTL    60
@       IN      SOA     ns.master.monkey. root.master.monkey. (
                 2023012110         ; Serial
                     60         ; Refresh
                      86400         ; Retry
                    2419200         ; Expire
                     60 )       ; Negative Cache TTL
;
@       IN      NS      ns.master.monkey.
@       IN      A       10.1.0.1
ns      IN      A       10.1.0.1
styx    IN      A       10.1.0.1
helios  IN      A       10.1.0.2