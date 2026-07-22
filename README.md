# connectome-amygdala

**A minimal, honest valence and salience region — appraise a stimulus with a valence
and a salience, learn threat by association (fear conditioning), and modulate the
appraisal by cortisol — built stratum-primary on PrologAI's enforced invariants (the
N6 binding, the N8 membership contract, its N11 accessor form, and the Wave 8
once-deterministic mode), whose committed appraisal can never carry a valence outside
the defined set.**

> **THE DELIVERABLE IS THE FINDING — ESPECIALLY ABOUT AFFECT/APPRAISAL AND THE
> CROSS-STRATAL CORTISOL SKIP.** The region runs and its no-undefined-valence guarantee
> holds; but the point of building an appraising region is the [LEDGER.md](LEDGER.md)
> (series AMYGDALA-1, AMYGDALA-2). The headline finding: **PrologAI has no first-class
> construct for a persisted, modulatory affective state.** The earlier regions
> selected, stored, and corrected; none had to HOLD an appraisal (a valence/salience/
> mood) that persists and colours later processing. The membership contract guards a
> single committed appraisal, but it is stateless and its accessor sees only the
> value — so to make the legal valence set *context-dependent on cortisol* the region
> must **smuggle the cortisol regime into the committed term** (`appraisal(Valence,
> Salience, Regime)`), and it must carry the learned association and the cortisol tone
> as ordinary Lattice/module data. Affect can be represented as ad-hoc data, not as a
> first-class construct. The second finding: the **cortisol channel is a cross-stratal
> skip** (community-and-society 14 → macromolecular 4) with no modelled endocrine
> pathway — a re-engagement of the Wave 2 slice's channel, and a recurrence of the same
> unmanaged seam the slice (P1/P2), the memory region (HIPPO-3), and the cerebellum
> (CEREBELLUM-2) recorded.

This is **Wave 8, Part Three** of the Connectome program: the first region whose job
is to **appraise** — to assign affective meaning to a stimulus and to learn threat by
association. Its dynamics (affective appraisal and associative fear learning) are
genuinely distinct from selection (`connectome-arbiter`), storage
(`connectome-hippocampus`), and supervised correction (`connectome-cerebellum`). It is
independent of Part Two (the cerebellum) — neither blocks the other — but both rest on
Part One (the once mode). It is built under the Wave 3 verdict (`WAVE_3_VERDICT.txt`):
**stratum-primary on the outside, atomic-style construct sub-modules on the inside**.

## The circuit

- **Appraise** — assign a stimulus a **valence** (its affective tag: `threat`, `safe`,
  `appetitive`, or `neutral`) and a **salience** (how much it matters, a bounded rate).
  The appraisal combines the stimulus's innate threat/reward feature (read down from
  the cellular projection neurons) with the **learned association**, **modulated by
  cortisol** (threat gain up, reward suppressed under stress). An unknown stimulus
  yields the explicit **no-appraisal** — the region abstains, never inventing a tag.
- **Condition** — fear conditioning: a previously neutral cue paired with an aversive
  outcome acquires a threat association (lateral-amygdala long-term potentiation), so
  it later evokes threat; an unpaired cue extinguishes it. DYNAMICS, kept native.
- **Modulate by cortisol** — the appraisal is modulated by the cortisol channel the
  Wave 2 slice minted: the stress signal that descends from the community-and-society
  stratum to the macromolecular stratum, the **layer-skipping channel**, RE-ENGAGED.

## No undefined valence is the safety property — DECLARED, not hand-rolled

The committed appraisal must be a member of the **valence set** — or the explicit
no-appraisal — and the region may never emit a valence outside the defined set (an
invented affective tag). The legal set is **context-dependent** on the cortisol regime
(under stress, `appetitive` is suppressed and is not a legal appraisal) and carries a
**continuous** salience, so it is neither a fixed list nor even countable. So the commit
predicate declares PrologAI's membership contract in its **accessor form** (a
membership-test goal — the set is never materialised, N11) and in **once mode** (one
appraisal per stimulus, guarded deterministically, N14):

```prolog
% the legal valence set narrows under stress — a membership-test goal, never a list
region_stratum_valence_in_regime(baseline, V) :- member(V, [threat, safe, appetitive, neutral]).
region_stratum_valence_in_regime(stress,   V) :- member(V, [threat, safe, neutral]).

% a committed appraisal is legal iff its salience is well-formed and its valence is legal IN ITS REGIME
region_stratum_legal_appraisal(appraisal(Valence, Salience, Regime)) :-
    number(Salience), Salience >= 0.0, Salience =< 1.0,
    region_stratum_valence_in_regime(Regime, Valence).

% the committed appraisal must satisfy that test (or be no_appraisal), checked once, deterministically
:- membership_contract_enforce_goal(region_stratum_commit_appraisal/2, 2,
        region_stratum_legal_appraisal, no_appraisal, once).
```

An invented valence, an out-of-range salience, or a contextually-illegal appraisal
(appetitive under stress) is **refused** by the contract. Nothing is hand-rolled.

## The decomposition — one pack per stratum, sub-modules inside

| pack | layer | stratum (ordinal) | role |
|---|---|---|---|
| `neural_lattice` | 0 | — (substrate, unbound) | stigmergy + await/notify closure substrate (reused verbatim) |
| `causal_grounding` | 0 | — (substrate, unbound) | the shared Causalontology 3.0.0 minting vocabulary (reused verbatim) |
| `macromolecular_stratum` | 1 | macromolecular (4) | the glucocorticoid (cortisol) receptor cascade — the **low end** of the cortisol skip |
| `cellular_stratum` | 2 | **cellular (6)** | the lateral-amygdala input and central-nucleus output neurons — sense the stimulus, carry the appraisal |
| `synaptic_stratum` | 3 | synaptic (7) | the lateral-amygdala long-term potentiation that writes the learned fear association |
| `region_stratum` | 4 | region (9) | **appraise**, **condition**, **modulate**, the committed appraisal, and the reentrant loop |
| `community_stratum` | 5 | community_and_society (14) | the social source of cortisol — the **high end** of the cortisol skip |

Five strata (4, 6, 7, 9, 14) whose layers fall out order-preserving (1, 2, 3, 4, 5)
with zero binding violations. The region **occupies the cellular stratum (ordinal 6)**,
which the memory region left empty — as the cerebellum did.

## The cortisol skip — a legal downward cross-stratal edge

The cortisol channel descends from the community-and-society stratum (ordinal 14) to the
macromolecular stratum (ordinal 4), **skipping** every stratum between — a **legal
downward skip** (`skips:true`), the most natural cross-pack edge under a stratum-primary
decomposition, exactly as the Wave 3 verdict prized and the Wave 2 slice first minted.
The N6 binding checker passes it (a downward skip is legal; only an upward edge fails);
the structure validator classifies it as a clean skip (`skipping`, no gap).

## The reentrant conditioning loop, closed with the hybrid

The loop — appraise, condition, re-appraise — settles as a cue acquires (or extinguishes)
a learned valence. Its recurrence is **stigmergic**: the conditioning tick
(`region_stratum_condition_tick/1`, a PrologAI `cyclic_actor`) awaits a numbered cue on
the Lattice, does one appraise/condition step, and **re-posts its own cue**, reentering
via notification with no busy-poll and no in-process recursion. The association changes
**monotonically** under a steady schedule and the loop **converges** (the association
settles), **bounded-stops** (an alternating partial-reinforcement schedule that never
settles — a legal "not fully conditioned"), or never hangs; the runner tells the three
apart.

## Cross-repo provenance

The region reuses PrologAI **read-only, by checkout** — no vendoring, no fork. It is
pinned to PrologAI commit **`a1b23432c6a357b8768422daa41a3abcbcf52de2`** (main, Wave 10 Stage 1, the
Causalontology 3.0.0 adoption). Every gate resolves PrologAI through the **`PROLOGAI_HOME`**
environment variable (default `/home/ccaitwo/PrologAI`) and stops with a clear message
if PrologAI — or specifically the `membership_contract` construct — is not reachable.

## Running it

```bash
# Point at a PrologAI checkout at (or after) commit a1b2343 (with the once mode).
export PROLOGAI_HOME=/path/to/PrologAI

# Present stimuli, run the conditioning loop, and prove no undefined valence.
bin/run_amygdala.sh        # exit 0 iff every committed appraisal was legal, the loop settled/bounded-stopped, and nothing hung
```

The run narrates, glass-box, an appraisal of every valence (and the abstention), the
cortisol modulation (appetitive suppressed under stress; a part-conditioned cue amplified
to threat under stress), a cue acquiring a threat appraisal over trials, a conditioned
cue extinguishing, a partial-reinforcement episode bounded-stopping, and the adversarial
attempts to commit an undefined and a contextually-illegal valence being **refused**.

## The gates (all must hold; a skipped safety gate is a failed build)

```bash
bin/check_membership.sh        # 1. NO UNDEFINED VALENCE — the flagship gate (192 attempts, 0 escapes, 9 out-of-set refusals)
bin/run_tests.sh               # every pack's in-pack PLUnit suite
bin/validate_structure.sh      # 32 newly-minted Causalontology 3.0.0 records valid; the cortisol skip and the signature verify
bin/check_layers.sh            # L4 — zero upward edges among the declared packs
bin/check_layer_binding.sh     # N6 — every pack's layer is order-preserving with its stratum's ordinal (4/6/7/9/14 → layers 1/2/3/4/5)
bin/check_no_coupling.sh       # closure — the conditioning loop reenters through the Lattice; 0 actor-to-actor refs; no busy-poll
```

Plus the mini regression via PrologAI's own harness
(`$PROLOGAI_HOME/bin/run_mini_regression.sh`), in the honest ten-percent form: ARC-AGI-1
40/40 and ARC-AGI-2 12/12 (a spot-check; the full regression stays deferred — this is not
400/400).

## What is reused, what is new

- **Reused** (verbatim / read-only): the `neural_lattice` substrate and `causal_grounding`
  vocabulary; the closure hybrid; the structure-minting and validation discipline;
  PrologAI's Lattice, actors, Causalontology engine, and the membership contract (plain-
  list, accessor, and once mode); the shape of the Wave 2 slice's cortisol skip.
- **New**: the appraise / condition / modulate constructs; the affective-appraisal and
  associative-fear-learning dynamics, native; and the region's own **32** newly-minted
  Causalontology 3.0.0 structure records.

## What this repository does not do

It does not modify PrologAI, Mentova, the frozen `prologai-loops` spike,
`connectome-proto-agi`, the three frozen Wave 3 arms, `connectome-arbiter`,
`connectome-hippocampus`, or `connectome-cerebellum`. It does not hand-roll the
membership guarantee, weaken a gate, scale to the full connectome, or become a general
framework. It is one region, built stratum-primary. Open AMYGDALA Ledger gaps —
especially the affect/appraisal finding and the cross-stratal cortisol seam — stay open
and honestly recorded.
