# LEDGER.md — connectome-amygdala Requirements Ledger (AMYGDALA series)

> The Connectome program's method is to BUILD a region and let the build surface
> what PrologAI cannot yet express. This valence and salience region rests on four
> enforced PrologAI invariants — **N6** (bind a pack's layer to its stratum ordinal),
> **N8** (the membership contract), **N11** (its accessor form), and the Wave 8 Part
> One **once-deterministic mode** (N14) — and records here what an APPRAISING region
> forced PrologAI to lack.
>
> Series **AMYGDALA-1, AMYGDALA-2, …** so findings never collide with the spike's
> L-series, PrologAI's N-series, the slice's P-series, or the ATOMIC / LOOPS / STRATA
> / ARBITER / HIPPO / CEREBELLUM series. Each finding names the construct that forced
> it, what PrologAI could not express, the evidence (file:line), and the minimum
> remedy. Parents are cited for second sightings.
>
> The region was built at a PINNED PrologAI commit,
> **a1b23432c6a357b8768422daa41a3abcbcf52de2** (main, Wave 10 Stage 1, the Causalontology 3.0.0
> adoption), reused read-only through `PROLOGAI_HOME`; PrologAI was not modified. A gap is
> a Ledger entry, never a commit against PrologAI.

Legend: **S** = severity for the Connectome plan (H/M/L).
Status: **OPEN** (recorded, not fixed here) · **CLOSED**.

---

## What the enforced invariants carried (the positive result)

Three things the region needed, PrologAI already gave it — so they are NOT findings,
they are the program working as designed:

- **No undefined valence was a single declaration, not a hand-rolled guard.** The
  committed appraisal must name a valence in the legal set — or the explicit
  `no_appraisal`. The legal set is CONTEXT-DEPENDENT (under stress, `appetitive` is
  not legal) and carries a CONTINUOUS salience, so it is neither a fixed list nor
  countable — the exact case the accessor form (N11) and the once mode (N14) were
  built for. So `region_stratum_commit_appraisal/2` DECLARES the membership contract
  in its accessor form against a legal-appraisal test goal, in once mode
  (`packs/region_stratum/prolog/region_stratum.pl`,
  `:- membership_contract_enforce_goal(region_stratum_commit_appraisal/2, 2,
  region_stratum_legal_appraisal, no_appraisal, once)`). The no-undefined-valence
  battery inspects 192 attempts with 0 escapes and 9 out-of-set refusals (invented
  tags, out-of-range salience, and appetitive-under-stress); the set is never
  materialised, and the committed answer is guarded deterministically. Nothing is
  hand-rolled.
- **The reentrant conditioning loop needed nothing the closure hybrid did not give.**
  Appraise → condition → re-appraise is a real reentrant loop, and it rode the Lattice
  cleanly: the conditioning tick awaits a numbered cue, does one step, and re-posts its
  own cue, reentering via stigmergy plus notification — never in-process recursion
  (proved non-vacuously by `bin/check_no_coupling.sh`). The learned association changes
  **monotonically** under a steady schedule (acquisition `[0.0, 0.5, 0.75, 0.875,
  0.9375, 0.969]` toward 1.0; extinction toward 0.0) and the loop converges (the
  association settles), bounded-stops (an alternating partial-reinforcement schedule
  that never settles — a legal "not fully conditioned"), or never hangs.
- **The cellular stratum was occupied cleanly, and the cortisol skip was a legal
  downward edge.** The region occupies ordinal 6 (the lateral-amygdala input and
  central-nucleus output neurons), which the memory region left empty — a clean
  five-stratum ladder (4, 6, 7, 9, 14) whose layers fall out order-preserving (1, 2, 3,
  4, 5) with zero binding violations, and whose cortisol channel is a legal downward
  skip that both the N6 binding checker and the skip classifier accept.

---

## AMYGDALA-1 — PrologAI has no first-class construct for a persisted, modulatory affective state · S=H · **OPEN** (a new gap)

- **The construct that forced it.** APPRAISE — the amygdala's defining function.
  Appraisal is not a one-shot output like a selection or a correction: it is an
  affective STATE (a valence and a salience) that PERSISTS and COLOURS later
  processing, and whose very legality depends on a persisted CONTEXT (the cortisol
  regime).
- **What PrologAI could not express.** There is no first-class construct for a held,
  modulatory affective state. Concretely, on two fronts:
  1. **The contract guards a value, not a value-in-context.** PrologAI's membership
     contract (even its accessor form) checks membership of the OUTPUT alone — its test
     goal is called `once(call(TestGoal, Out))`, receiving only the committed value. But
     whether a valence is legal DEPENDS on the cortisol context (under stress,
     `appetitive` is not legal). The contract has no notion of "context"; it can only
     ask "is `Out` a member". So the region must **smuggle the cortisol regime INTO the
     committed value** — the appraisal is the triple `appraisal(Valence, Salience,
     Regime)`, not `appraisal(Valence, Salience)` — purely so the accessor can judge
     legality in context. Affect's context-dependence cannot be expressed as context; it
     must be folded into the value.
  2. **Persisted affect is carried as ad-hoc data.** The learned association and the
     cortisol tone must persist across stimuli and modulate the next appraisal, but there
     is no affect/mood construct to hold them — they are ordinary fields on the Lattice
     conditioning-loop state (`assoc`, `cortisol`), plain numbers threaded by hand. The
     Lattice CAN carry them (stigmergy), so they are representable — but as data, not as
     a first-class persisted appraisal that automatically colours later processing.
- **Evidence.** `packs/region_stratum/prolog/region_stratum.pl`:
  `region_stratum_legal_appraisal/1` matches `appraisal(Valence, Salience, Regime)` and
  defers to `region_stratum_valence_in_regime/2` (the context-dependent, never-
  materialised set); the `Regime` field exists ONLY so the stateless accessor can judge
  legality in context. The conditioning tick `region_stratum_condition_tick/1` carries
  `assoc` and `cortisol` as plain state-dict fields — the persisted affect, as data.
- **The honest workaround, recorded as a workaround.** Fold the cortisol regime into the
  committed appraisal term so the accessor is pure and context-aware; carry the learned
  association and the cortisol tone as ordinary Lattice state. Honest and correct, but not
  what a first-class affect construct would give: the region DESCRIBES an affective state
  as data, rather than HOLDING it as a construct that modulates later processing natively.
- **Minimum remedy.** A first-class affective-state (or "modulatory context") construct:
  a held valence/salience/mood that (a) the membership contract can consult as CONTEXT
  when judging an appraisal's legality (a context-aware accessor, `call(TestGoal, Out,
  Context)`), and (b) automatically colours subsequent appraisals without being threaded
  by hand. This is the region's headline finding, and the reason an appraising region was
  chosen. **No direct parent** — selection (arbiter), storage (hippocampus), and
  correction (cerebellum) never had to hold an affective state; this is a new gap.

## AMYGDALA-2 — the cortisol channel is a cross-stratal skip with no modelled intervening mechanism · S=L · **OPEN** (recurrence of P1 / P2 / HIPPO-3 / CEREBELLUM-2)

- **The construct that forced it.** MODULATE BY CORTISOL — the cortisol channel the Wave
  2 slice minted, re-engaged: a social/contextual stressor raises cortisol, which
  modulates the appraisal.
- **What PrologAI could not express (that this cut chose not to).** The cortisol relation
  jumps from the community-and-society stratum (ordinal 14) to the macromolecular stratum
  (ordinal 4), skipping every stratum between (region 9, synaptic 7, cellular 6). This cut
  does not model the intervening endocrine pathway (the hypothalamic-pituitary-adrenal
  axis), so the CRO carries `skips:true` honestly and classifies as a clean skip
  (validated: `skipping`, `skip-gaps=[]`). The absence of a modelled intervening mechanism
  across strata is the same unmanaged cross-stratal seam the slice (P1/P2), the strata arm,
  the memory region (HIPPO-3), and the cerebellum (CEREBELLUM-2) recorded. Here it is
  re-engaged deliberately, not re-invented — the same shape as the slice's channel.
- **Evidence.** `packs/community_stratum/prolog/community_stratum.pl`,
  `community_stratum_cortisol_skip_cro/1` (`cm_cro([OStressor.id], [OReceptor.id],
  [skips-true], Out)`, community 14 → macromolecular 4), validated by
  `community_stratum_skip_check/2` and `bin/validate_structure.sh`.
- **Minimum remedy.** As P1/P2/HIPPO-3/CEREBELLUM-2 named it: model the intervening strata
  (the hypothalamic-pituitary-adrenal occurrents the cortisol signal actually flows through,
  so the relation is a chain of adjacent-stratum steps), or a first-class "managed seam"
  construct. Recorded as an honest skip, not closed. **Parents: P1, P2, HIPPO-3, CEREBELLUM-2.**

## AMYGDALA-3 — once mode was declared for the committed appraisal, but it did NOT bite (the appraisal is deterministic) · S=L · **CLOSED** (a Wave 8.5 honesty classification; parent N10 / the hippocampus recall)

- **The Wave 8.5 honesty hedge.** The Wave 8 Part Three order had the region declare the
  membership contract in ONCE mode "because the region commits one appraisal per stimulus".
  A pre-flight review supplied the missing honesty clause: once mode only BITES — only
  changes behaviour — when a predicate generates SEVERAL candidate outputs on backtracking
  and commits one (the arbiter's nondeterministic-select-then-commit shape). This entry
  records, truthfully, whether it bit here.
- **Classification: DETERMINISTIC.** The committed appraisal is computed in a SINGLE
  solution. `region_stratum_appraise/4` is an if-then-else over the sensory encoding
  (`packs/region_stratum/prolog/region_stratum.pl`), `region_stratum_decide_valence/3` is a
  deterministic if-then-else chain, and `region_stratum_commit_appraisal(Proposed, Proposed)`
  is a single fact (line 196). `test(commit_is_deterministic)` confirms `findall` returns
  exactly one appraisal. So once mode did NOT bite — it is correct for intent and harmless,
  but inert, exactly the Wave 6 hippocampus recall and gap N10.
- **No contrivance was present or removed.** There is no spurious candidate generator and
  no extra choice points introduced to make once mode appear to fire; the appraisal pipeline
  is honestly deterministic. (The "candidate" appraisals in the no-undefined-valence battery
  are the TEST harness's adversarial INPUTS, not outputs the region generates.) Nothing was
  rewritten — no dynamics, decomposition, strata, or structure records changed, and the
  committed appraisal's value is unchanged.
- **The membership guarantee still holds on the single committed output.** Whether or not
  once mode bit, the committed appraisal is still a member of the legal valence set (in its
  regime) or the explicit no_appraisal; the no-undefined-valence battery remains green (192
  attempts, 0 escapes).
- **Documentation.** The six-file SPARC set already describes the committed appraisal as
  deterministic (Refinement: "the committed appraisal is deterministic (exactly one
  solution, the once mode)"; Specification and Completion: "checked deterministically"), so
  the honest classification corrects no claim and no SPARC file needed a version bump — this
  Ledger entry is the record. **Parent: N10 (the per-solution versus deterministic-single-
  solution distinction) and the Wave 6 hippocampus recall, where once mode likewise did not
  bite.**

---

## Summary

Two open findings, plus one honesty classification. **AMYGDALA-1** is the one the program predicted and chose this
region to surface: PrologAI has no first-class construct for a persisted, modulatory
affective state, so an appraising region can only DESCRIBE affect as data (the cortisol
regime smuggled into the committed appraisal so the stateless contract can judge it in
context; the learned association and cortisol tone carried as ordinary Lattice state) —
a new gap the earlier regions never hit. **AMYGDALA-2** is the familiar cross-stratal seam
recurring, here as the re-engaged cortisol channel (community 14 → macromolecular 4).
**AMYGDALA-3** (Wave 8.5, CLOSED) records the honest truth that once mode, though correctly
declared for the committed appraisal, did NOT bite because the appraisal is deterministic —
the same pattern as the hippocampus recall and gap N10; no contrivance was present, and the
membership guarantee holds regardless. The safety property (no undefined valence) and the
reentrant conditioning loop were both carried by the enforced invariants — N8/N11/N14 made
the guarantee a one-line declaration, and the closure hybrid carried the loop — so those are
not findings, they are the program working as designed. The affect/appraisal gap and the
cortisol seam stay open and honestly recorded; they are the product of the program.
