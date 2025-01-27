# check_paloalto_portstatus.pl
A Nagios plugin based on Perl and SNMPv3 to check the status of a Palo Alto Networks interface on a device.

| @18th May 2023 | Version |
|---------------:|----------|
| Tested on      |  PA-440 |
| PAN-OS         |  11.2.4-h2 |
| Nagios Core    |  4.5.9 |

<sub>Unsure who the author is. Credits to the unknown author.</sub>

[![GitHub release](https://img.shields.io/github/release/FoUStep/check_paloalto_portstatus.pl.svg)](https://GitHub.com/FoUStep/check_paloalto_portstatus.pl/releases/)

<sub>Due to security reasons this is SNMPv3 only.</sub>
```
# check_paloalto_portstatus.pl
Usage:
./check_paloalto_portstatus.pl -H [ip|fqdn] -u [username] -A [authpassword] -X [privpassword] -v [interface name] -w [warning value] -c [critical value]

-H = IP/FQDN of the PA
-u = Username
-A = AuthPassword
-X = PrivPassword
-v = Interface Name/Alias
-w = Warning Value
-c = Critical Value

-h = Help
-V = Version
```
