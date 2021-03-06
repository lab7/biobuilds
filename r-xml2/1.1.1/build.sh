#!/bin/bash

# 'Autobrew' is being used by more and more packages these days
# to grab static libraries from Homebrew bottles. These bottles
# are fetched via Homebrew's --force-bottle option which grabs
# a bottle for the build machine which may not be macOS 10.9.
# Also, we want to use conda packages (and shared libraries) for
# these 'system' dependencies. See:
# https://github.com/jeroen/autobrew/issues/3
export DISABLE_AUTOBREW=1

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

# Force use of the C++11 standard, or the build will fail when using g++ 4.8.*
# (i.e., the default compiler for POWER) with "error: 'char16_t' does not name
# a type" caused by the UChar typedef in <unicode/umachine.h>.
echo 'CXX_STD = CXX11' >> src/Makevars.in

$R CMD INSTALL --build .
