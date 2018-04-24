#! /usr/bin/gawk -f

# Trivial little script to convert from a makefile-style configuration
# file to a C header. No copyright claimed.

BEGIN {
  print "// autoconf.h generated from " ARGV[1] "\n" \
    "#ifndef KCONFIG_AUTOCONF_H\n" \
    "#define KCONFIG_AUTOCONF_H"
}

/^#/ { sub(/^#/,"//") }

/^CONFIG_.*=/ {
  if (/=n$/) {
    sub(/^/,"// ");
  } else {
    sub(/^/,"#define ")
    if (/=y$/) {
      sub(/=.*$/,"")
    } else {
      sub(/=/," ")
    }
  }
}

{ print }

END { print "#endif" }
