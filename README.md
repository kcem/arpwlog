# Arpwlog
Simple tool to log mails from ArpWatch to log file.

## Example usage:
Add to /etc/default/arpwatch:

```bash
ARGS="-N -p -s /path/to/arpwlog.pl"
```

/etc/arpwatch.conf:

```
eth0 -m root
```
