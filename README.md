# SSSD-Extract

Using this bash script it is possible to extract Active Directory accounts hashes when credential caching is enabled in SSSD.

```
zsh sssd-extract.sh [$FolderPath]
```

Without input arguments it takes the SSSD default path "/var/lib/sss/db/" but you can use a different one. If tdbdump is not installed it just lists the ldb files which contain the hashes, you can install it `apt install tdb-tools` or exfiltrate these files:

![](https://raw.githubusercontent.com/ricardojoserf/ricardojoserf.github.io/master/images/SSSD-creds/image1.png)

**In a system with tdbdump installed the script will:**

1. Extracts cached accounts and hashes, dumping the results to the file _`hashes.txt`_. The hashes can then be cracked using Hashcat or John the Ripper:

```cmd
john hashes.txt --format=sha512crypt
```

2. Extract all the AD groups, Users and Machine accounts cached in the ldb file and save it to _`domain.txt`_

***Better approach would be to copy the ldb file to you attacking machine and run the script there.**

### Credit
+ ricardojoserf/SSSD-creds
