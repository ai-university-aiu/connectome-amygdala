#!/usr/bin/env bash
# check_membership.sh — the valence and salience region's FLAGSHIP gate: run the no-undefined-valence battery.
#
# Thin wrapper (plumbing only) around bin/check_membership.pl, the dedicated
# adversarial battery that TRIES to make the region commit an appraisal outside the
# legal valence set — an invented affective tag, an out-of-range salience, and a
# contextually-illegal appraisal (appetitive under stress) — as well as the full
# appraise-then-commit pipeline over a wide sweep of stimuli, cortisol levels, and
# learned associations, and confirms it cannot. It assembles the same SWI-Prolog
# library path the sibling gates use (the region packs plus the PrologAI grounding
# engine, the Lattice, and the membership_contract the region declares) and PROPAGATES
# the battery's exit code: exit 0 iff zero escapes, non-zero otherwise. It does NOT
# alter the battery.
set -u
# Resolve the region repository root from this script's location.
cd "$(dirname "$0")/.." || exit 2
# Resolve the PrologAI checkout (honour PROLOGAI_HOME, else the local default) — same as the sibling gates.
PROLOGAI_HOME="${PROLOGAI_HOME:-/home/ccaitwo/PrologAI}"
# The conformance harness directory holding schema_check.pl, signing.pl, ed25519.pl, schema/.
HARNESS="$PROLOGAI_HOME/tests/causalontology_conformance"
# Confirm the harness exists before building the library path (the same guard the validator uses).
if [ ! -f "$HARNESS/schema_check.pl" ]; then
  echo "check_membership.sh: cannot find the conformance harness at $HARNESS (set PROLOGAI_HOME)" >&2
  exit 2
fi
# Confirm the membership_contract construct (N8/N11/once) the region declares its guarantee with is reachable.
if [ ! -f "$PROLOGAI_HOME/packs/membership_contract/prolog/membership_contract.pl" ]; then
  echo "check_membership.sh: cannot find PrologAI's library(membership_contract) at $PROLOGAI_HOME — the region's guarantee rests on it (set PROLOGAI_HOME)" >&2
  exit 2
fi
# Start the library path with every region pack's prolog directory.
LIB=""
for d in packs/*/prolog; do LIB="$LIB -p library=$d"; done
# Add PrologAI's causal_core engine, the Lattice pack (region co-locates structure with runtime), the membership contract, and the harness.
LIB="$LIB -p library=$PROLOGAI_HOME/packs/causal_core/prolog"
LIB="$LIB -p library=$PROLOGAI_HOME/packs/lattice/prolog"
LIB="$LIB -p library=$PROLOGAI_HOME/packs/membership_contract/prolog"
LIB="$LIB -p library=$HARNESS"
# Run the UNMODIFIED battery; its initialization goal runs the attempts and halts with the verdict code.
swipl -q $LIB bin/check_membership.pl
# Propagate the battery's exit code (0 = zero escapes; non-zero = an undefined valence was committed).
exit $?
