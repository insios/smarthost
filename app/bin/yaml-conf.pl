#!/usr/bin/perl

use strict;
use warnings;
use YAML;
use Hash::Merge::Simple qw/ merge /;
use Data::Dumper;

my $config = {};
my @users = ();
my @domains = ();

my @yaml_files = (
    glob($ENV{APP_LIB} . "/etc/yaml.d/*yaml"),
    glob($ENV{APP_CONF} . "/yaml.d/*yaml")
);
foreach (@yaml_files) {
	my $yaml = YAML::LoadFile($_);
    if (exists $yaml->{config}) {
        $config = merge $config, $yaml->{config};
    }
    if (exists $yaml->{users}) {
        push(@users, @{$yaml->{users}});
    }
    if (exists $yaml->{domains}) {
        push(@domains, @{$yaml->{domains}});
    }
}

# print Dumper($config);

while (my($cname, $cval) = each %{$config}) {
    if ("verbose" eq $cname) {
        if ("true" eq $cval) {
            system("postconf -M -e submission/inet=\"submission inet n - n - - smtpd -v\"");
        }

    } elsif ("hostname" eq $cname) {
        system("postconf -e myhostname=\"$cval\"");
        my $helo_name = substr(`postconf -h smtp_helo_name`, 0, -1);
        if ("localhost.localdomain" eq $helo_name) {
            system("postconf -e smtp_helo_name=\"$cval\"");
        }

    } elsif ("relay" eq $cname) {
        system("postconf -e relayhost=\"$cval->{host}\"");
        if ((exists $cval->{tls}) && ("true" eq $cval->{tls})) {
            system("postconf -e smtp_tls_security_level=\"encrypt\"");
        }
        if ((exists $cval->{username}) && $cval->{username}) {
            system("postconf -e smtp_sasl_auth_enable=\"yes\"");
            system("postconf -e smtp_sasl_security_options=\"noanonymous\"");
            system("postconf -e smtp_sasl_password_maps=\"static:$cval->{username}:$cval->{password}\"");
        }

    } elsif ("allowed_networks" eq $cname) {
        if (ref($cval) eq "ARRAY") {
            $cval = join(', ', @{$cval});
        }
        system("postconf -e mynetworks=\"$cval\"");

    } elsif ("auth" eq $cname) {
        if ("true" eq $cval) {
            system("postconf -e smtpd_sasl_auth_enable=\"yes\"");
            system("postconf -e smtpd_client_restrictions=\"permit_sasl_authenticated, reject\"");
        }

    } elsif ("tls" eq $cname) {
        if ("" ne $cval->{level}) {
            system("postconf -e smtpd_tls_security_level=\"$cval->{level}\"");
            if (exists $cval->{crt_file}) {
                system("postconf -e smtpd_tls_cert_file=\"$ENV{APP_CONF}/$cval->{crt_file}\"");
            } elsif (exists $cval->{crt}) {
                my $crt_file = $ENV{APP_VAR} . "/postfix/tls.crt";
                open(my $fh, '>', $crt_file);
                print $fh $cval->{crt};
                close $fh;
                system("postconf -e smtpd_tls_cert_file=\"$crt_file\"");
            }
            if (exists $cval->{key_file}) {
                system("postconf -e smtpd_tls_key_file=\"$ENV{APP_CONF}/$cval->{key_file}\"");
            } elsif (exists $cval->{key}) {
                my $key_file = $ENV{APP_VAR} . "/postfix/tls.key";
                open(my $fh, '>', $key_file);
                print $fh $cval->{key};
                chmod 0600, $fh;
                close $fh;
                system("postconf -e smtpd_tls_key_file=\"$key_file\"");
            }
        }

    } elsif ("sender_restrictions" eq $cname) {
        if ("email" eq $cval) {
            my $sl_map = $ENV{APP_VAR} . "/postfix/sender_login.map";
            system("touch \"$sl_map\"");
            system("postconf -e smtpd_sender_login_maps=\"texthash:$sl_map\"");
            system("postconf -e smtpd_sender_restrictions=\"reject_sender_login_mismatch\"");
        } elsif ("domain" eq $cval) {
            my $dom_map = $ENV{APP_VAR} . "/postfix/allowed_domains.map";
            system("touch \"$dom_map\"");
            system("postconf -e smtpd_sender_restrictions=\"check_sender_access texthash:$dom_map, reject\"");
        }

    } elsif ("postconf" eq $cname) {
        foreach (@{$cval}) {
            system("postconf $_");
        }

    } else {
        print "Unknown config name $cname\n";
    }
}

if (@users) {
    my $sasl_dom = substr(`postconf -h smtpd_sasl_local_domain`, 0, -1);
    my %sender_login = ();
    foreach (@users) {
        system("echo \"$_->{password}\" | saslpasswd2 -p -c -u \"$sasl_dom\" \"$_->{name}\"");
        my @allowed_from = ("*");
        if (exists $_->{allowed_from}) {
            @allowed_from = @{$_->{allowed_from}};
        }
        my $user = "$_->{name}\@$sasl_dom";
        foreach (@allowed_from) {
            if (! exists $sender_login{$_}) {
                @{$sender_login{$_}} = ();
            }
            push(@{$sender_login{$_}}, $user);
        }
    }
    # print Dumper(\%sender_login);
    my $sl_map = $ENV{APP_VAR} . "/postfix/sender_login.map";
    system("touch \"$sl_map\"");
    open(my $fh, '>>', $sl_map);
    foreach my $dom (keys %sender_login) {
        print $fh "$dom ";
        print $fh join(' ', @{$sender_login{$dom}});
        if ($dom =~ /.+(@.*)$/) {
            if (exists $sender_login{$1}) {
                print $fh " ";
                print $fh join(' ', @{$sender_login{$1}});
            }
        }
        if (exists $sender_login{"*"}) {
            print $fh " ";
            print $fh join(' ', @{$sender_login{"*"}});
        }
        print $fh "\n";
    }
    close $fh;
}

if (@domains) {
    my $dom_f = $ENV{APP_VAR} . "/postfix/allowed_domains.map";
    my $sig_f = $ENV{APP_VAR} . "/opendkim/signingtable";
    my $key_f = $ENV{APP_VAR} . "/opendkim/keytable";
    system("touch \"$dom_f\"");
    system("touch \"$sig_f\"");
    system("touch \"$key_f\"");
    open(my $dom_h, '>>', $dom_f);
    open(my $sig_h, '>>', $sig_f);
    open(my $key_h, '>>', $key_f);
    foreach (@domains) {
        print $dom_h "$_->{name} OK\n";
        if (exists $_->{dkim}) {
            my $dom_s = "$_->{dkim}{selector}._domainkey.$_->{name}";
            my $key_file = "";
            if (exists $_->{dkim}{key_file}) {
                $key_file = "$ENV{APP_CONF}/$_->{dkim}{key_file}";
            } elsif (exists $_->{dkim}{key}) {
                $key_file = "$ENV{APP_VAR}/opendkim/$_->{name}.key";
                open(my $fh, '>', $key_file);
                print $fh $_->{dkim}{key};
                chmod 0600, $fh;
                close $fh;
            }
            print $sig_h "$_->{name} $dom_s\n";
            if ("" ne $key_file) {
                print $key_h "$dom_s $_->{name}:$_->{dkim}{selector}:$key_file\n";
            }
        }
    }
    close $dom_h;
    close $sig_h;
    close $key_h;
}
