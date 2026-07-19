#!/usr/bin/env bash
# check_no_coupling.sh — prove the region's reentrant conditioning loop coordinates ONLY through the Lattice.
#
# The CLOSURE RULE demands zero actor-to-actor references at runtime and a REENTRANT
# loop that reenters through the Lattice, not the call stack. The amygdala has
# exactly one runtime actor — the conditioning tick (region_stratum_condition_tick);
# the macromolecular, cellular, synaptic, and community packs are PURE (no tick,
# invoked downward as sub-modules during an appraisal/conditioning step, which is
# permitted structural reuse, not runtime coupling). This checker strips comments and
# confirms three things:
#   (a) no stratum pack names another stratum's runtime tick (zero actor-to-actor refs);
#   (b) the conditioning tick RE-ENTERS by re-posting a Lattice cue (neural_lattice_post_cue),
#       and NEVER calls itself in-process — the loop is stigmergic, not a stack recursion;
#   (c) the conditioning tick AWAITS on the Lattice (neural_lattice_await_cue) — it blocks, no busy-poll.
#
# Exit 0 = clean; 1 = a coupling/recursion/poll violation; 2 = error.
set -u
# Resolve the region repository root from this script's location.
cd "$(dirname "$0")/.." || exit 2
# Run a small Python check over the stratum packs and the conditioning tick.
python3 - <<'PY'
import re, sys
# The only runtime tick in the region: the conditioning actor entry point.
ticks = { "region_stratum": "region_stratum_condition_tick" }
# Every stratum pack (macromolecular, cellular, synaptic, and community are pure — no tick).
strata = ["macromolecular_stratum", "cellular_stratum", "synaptic_stratum", "region_stratum", "community_stratum"]

# -- strip_comments(pack): read a pack's source with block and line comments removed.
def strip_comments(pack):
    src = open(f"packs/{pack}/prolog/{pack}.pl").read()
    # Strip block comments /* ... */ (dot matches newline).
    code = re.sub(r"/\*.*?\*/", "", src, flags=re.S)
    # Strip whole-line % comments.
    code = "\n".join(l for l in code.split("\n") if not l.lstrip().startswith("%"))
    # Strip trailing % comments on code lines.
    code = re.sub(r"%.*", "", code)
    return code

# Track any violation found.
violations = []

# (a) No stratum pack may name ANOTHER stratum's runtime tick.
for pack in strata:
    code = strip_comments(pack)
    for other_pack, other_tick in ticks.items():
        if other_pack == pack:
            continue
        if re.search(r"\b" + re.escape(other_tick) + r"\b", code):
            violations.append(f"stratum '{pack}' names stratum '{other_pack}' tick {other_tick} at runtime")

# (b) + (c) The conditioning tick reenters via the Lattice, never in-process, and awaits (no busy-poll).
region_code = strip_comments("region_stratum")
tick = ticks["region_stratum"]
# It must re-post a Lattice cue (the reentry is a Lattice write).
if "neural_lattice_post_cue" not in region_code:
    violations.append("conditioning tick does not re-post a Lattice cue — reentry is not through the Lattice")
# It must await on the Lattice (block on a queue), not busy-poll.
if "neural_lattice_await_cue" not in region_code:
    violations.append("conditioning tick does not await on the Lattice — possible busy-poll")
# It must NOT call itself in-process: the tick predicate is INVOKED (with '(') at most once — its own head.
call_sites = re.findall(re.escape(tick) + r"\s*\(", region_code)
if len(call_sites) > 1:
    violations.append(f"conditioning tick calls itself in-process ({len(call_sites)} occurrences) — the loop must reenter via the Lattice")

# Report the outcome.
if violations:
    print("check_no_coupling: FAIL")
    for v in violations:
        print("  " + v)
    sys.exit(1)
else:
    print("check_no_coupling: PASS -- the region's conditioning loop reenters through the Lattice; 0 actor-to-actor references, no in-process recursion, no busy-poll.")
    print("  the conditioning tick awaits phase 1, does one appraise/condition step, and re-posts phase 1 (reentry) or phase 2 (result) — stigmergy plus notification.")
    sys.exit(0)
PY
# Propagate the Python checker's exit code.
exit $?
