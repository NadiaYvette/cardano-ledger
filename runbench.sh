#!/bin/sh
# This path almost certainly won't apply more generally.
# The options available from CHaP are likely preferable.
TOOLPATH=$HOME/.ghcup/bin
CABAL=$TOOLPATH/cabal-3.8.1.0
GHC8=$TOOLPATH/ghc-8.10.7
GHC9=$TOOLPATH/ghc-9.2.8
# GHC9=$TOOLPATH/ghc-9.6.2


run_ledger()
{
        GHC=ghc-$2
        case $1 in
                bench)  $CABAL -v --enable-nix --disable-doc           \
                                --with-compiler=$TOOLPATH/$GHC         \
                                bench cardano-ledger-test              \
                                --benchmark-options="+RTS -r$GHC.ticky"
                        ;;
                test)   $CABAL -v --enable-nix --disable-doc           \
                                run cardano-ledger-core:test:tests     \
                                -- +RTS -r$GHC.ticky
                        ;;
                *)      echo "cmd $1 unrecognized"
                        exit 1
                        ;;
        esac
        RET=$?
        if [ $RET -ne 0 ]
        then
                echo "$1 of $2 failed"
                # exit $RET
        fi
}

run_ledger  test   8.10.7
run_ledger  test   9.2.8

run_ledger  bench  8.10.7
run_ledger  bench  9.2.8

run_ledger  test   9.6.2
run_ledger  bench  9.6.2
exit 0
