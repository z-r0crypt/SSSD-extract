# SSSD-Extract

Using this bash script it is possible to extract Active Directory accounts hashes when credential caching is enabled in SSSD.

```
zsh sssd-extract.sh [$FolderPath]
```

Without input arguments it takes the SSSD default path "/var/lib/sss/db/" but you can use a different one. If tdbdump is not installed it just lists the ldb files which contain the hashes, you can install it `apt install tdb-tools` or exfiltrate these files:

![image](https://private-user-images.githubusercontent.com/136485331/245736469-0711efe4-a1a4-47c8-8dac-5d8d349dfc0c.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE3MDI3MDYxNjUsIm5iZiI6MTcwMjcwNTg2NSwicGF0aCI6Ii8xMzY0ODUzMzEvMjQ1NzM2NDY5LTA3MTFlZmU0LWExYTQtNDdjOC04ZGFjLTVkOGQzNDlkZmMwYy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBSVdOSllBWDRDU1ZFSDUzQSUyRjIwMjMxMjE2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDIzMTIxNlQwNTUxMDVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMzU4ZTBlMzNkYmJhMDY1OWE1NjJmOWMyNGZiYmMxZDc3MzE4ZjY4ODcyN2M5NjExM2IwM2FjMWMwMDdjNTc1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.08ZdjMK6HBULNLN00xkgBl5OZtEhQS6yy55qHgst0DY)

**In a system with tdbdump installed the script will:**

1. Extracts cached accounts and hashes, dumping the results to the file _`hashes.txt`_. The hashes can then be cracked using Hashcat or John the Ripper:

```cmd
john hashes.txt --format=sha512crypt
```

2. Extract all the AD groups, Users and Machine accounts cached in the ldb file and save it to _`domain.txt`_

***Better approach would be to copy the ldb file to you attacking machine and run the script there.**

### Credit
+ ricardojoserf/SSSD-creds
