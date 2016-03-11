#!/bin/sh -ex
#
# Regenerate configure from configure.ac. Requires GNU autoconf.
#
# We use --no-recursive to prevent autoreconf from running itself in
# extern/gmp.  And we use '-I cnf/m4' as it helps with some older
# autoconf versions.
#
autoreconf -vif --no-recursive -I cnf/m4 `dirname "$0"`
