#! /usr/bin/perl -w


use strict;
use Getopt::Long;
use vars qw($opt_V $opt_h $opt_w $opt_c $opt_H $opt_C $opt_A $opt_X $opt_v $nr $rawstatus $status $warning $critical $PROGNAME);
use lib "/usr/lib/nagios/plugins/"  ;
use utils qw(%ERRORS &support &usage);

$PROGNAME = "check_paloalto_portstatus.pl";

sub print_help ();
sub print_usage ();

$ENV{'PATH'}='';
$ENV{'BASH_ENV'}='';
$ENV{'ENV'}='';

Getopt::Long::Configure('bundling');
GetOptions
        ("V"   => \$opt_V, "version"    => \$opt_V,
         "h"   => \$opt_h, "help"       => \$opt_h,
         "H=s" => \$opt_H, "hostname=s" => \$opt_H,
         "v=s" => \$opt_v, "ifalias=s" => \$opt_v,
         "u=s" => \$opt_C, "username=s" => \$opt_C,
         "A=s" => \$opt_A, "authpassword=s" => \$opt_A,
         "X=s" => \$opt_X, "privpassword=s" => \$opt_X);


if ($opt_V) {
        print ("$PROGNAME v1.0.0\n");
        exit $ERRORS{'OK'};
}


if ($opt_h) {print_help(); exit $ERRORS{'OK'};}

($opt_H) || usage("Host name/address is not specified (-H)\n");
my $host = $1 if ($opt_H =~ /([-.A-Za-z0-9]+)/);
($host) || usage("Invalid host: $opt_H\n");

($opt_C) || usage("Username is not specified (-u)\n");
my $username = $1 if ($opt_C =~ /([-.A-Za-z0-9]+)/);
($username) || usage("Invalid username: $opt_C\n");

($opt_A) || usage("AuthPassword is not specified (-A)\n");
my $authpass = $1 if ($opt_A =~ /([-.A-Za-z0-9]+)/);
($authpass) || usage("Invalid AuthPassword: $opt_A\n");

($opt_X) || usage("PrivPassword is not specified (-X)\n");
my $privpass = $1 if ($opt_X =~ /([-.A-Za-z0-9]+)/);
($privpass) || usage("Invalid PrivPassword: $opt_X\n");

($opt_v) || usage("Interface name is not specified (-v)\n");
my $ifalias = $1 if ($opt_v =~ /([-.A-Za-z0-9_]+)/);
($ifalias) || usage("Invalid interface: $opt_v\n");

#($opt_w) || usage("Warning threshold not specified\n");
#my $warning = $1 ;
#($warning) || usage("Invalid warning threshold: $opt_w\n");

#($opt_c) || usage("Critical threshold not specified\n");
#my $critical = $1 ;
#($critical) || usage("Invalid critical threshold: $opt_c\n");

$critical="down";

($opt_C) || ($opt_C = "username") ;
($opt_A) || ($opt_A = "authpassword") ;
($opt_X) || ($opt_X = "privpassword") ;

my $nr=0;
$nr=`/usr/bin/snmpwalk -v 3 -u $opt_C -l authPriv -a SHA -A $opt_A -x AES -X $opt_X $host IF-MIB::ifAlias | /bin/grep -w $ifalias| /usr/bin/awk -F' ' '{print \$1}' | /usr/bin/awk -F. '{print \$NF}' `;
$rawstatus=`/usr/bin/snmpwalk -v 3 -u $opt_C -l authPriv -a SHA -A $opt_A -x AES -X $opt_X $host IF-MIB::ifOperStatus.$nr`;
$status=`printf "$rawstatus" | /usr/bin/awk -F' ' '{print \$4}' | /usr/bin/awk -F'(' '{print \$1}'`;

if ($status =~ "up"){
                        print "OK - $ifalias status: $status"; exit $ERRORS{'OK'};
 }else{
                        print "CRITICAL - $ifalias usage: $status"; exit $ERRORS{'CRITICAL'};
 }



#if ($status=$warning){ print "WARNING - $ifalias usage: $status"; exit $ERRORS{'WARNING'} };

sub print_usage () {
        print "Usage: $PROGNAME -H <host> [-u username] [-A authpassword] [-u privpassword] [-v Interface Name/Alias] -w <warn> -c <crit>\n";
}

sub print_help () {
        print ("$PROGNAME v1.0.0\n");
        print "Modified by Step

This plugin reports the status of a Palo Alto Interface: IfAlias

";
        print_usage();
        print "
-H, --hostname=HOST
   Name or IP address of host to check
-v, --IfAlias=IfAlias
   Name of the port to check
-u, --username=username
   SNMPv3 username (default username)
-A, --authpassword=authpassword
   SNMPv3 authpassword (default authpassword)
-X, --privpassword=privpassword
   SNMPv3 privpassword (default privpassword)
-w, --warning=INTEGER
   Percentage above which a WARNING status will result
-c, --critical=INTEGER
   Percentage above which a CRITICAL status will result

";
#       support();
}
