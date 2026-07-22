/*  connectome-amygdala — region_stratum (ordinal 9 -> pack layer 4): THE AMYGDALAR CIRCUIT.

    The valence and salience region's heart: the amygdalar circuit, at the region
    stratum (Causalontology ordinal 9). Under the Wave 3 verdict's rule it is one
    pack per stratum on the OUTSIDE, and one construct per module on the INSIDE: the
    circuit's machinery is THREE independently testable internal sub-modules —
      - APPRAISE  (region_stratum_appraise/4): assign a stimulus a VALENCE (its
                  affective tag — threat, safe, appetitive, or neutral) and a
                  SALIENCE (how much it matters, a bounded rate). The appraisal
                  combines the stimulus's innate threat/reward feature (read down
                  from the cellular projection neurons) with the LEARNED association,
                  MODULATED by cortisol (the threat gain and the reward suppression
                  read down from the macromolecular receptor cascade). An unknown
                  stimulus yields the explicit no_appraisal — the region abstains,
                  never inventing an affective tag.
      - CONDITION (region_stratum_condition/3): fear conditioning — associate a
                  previously neutral cue with an aversive outcome (or extinguish it),
                  by the associative plasticity write (read down to the synaptic
                  stratum). DYNAMICS, kept native (an associative rule, never a CRO).
      - MODULATE  by cortisol: the appraisal is modulated by the cortisol channel the
                  Wave 2 slice minted — the stress signal that descends from the
                  community-and-society stratum to the macromolecular stratum, the
                  LAYER-SKIPPING channel, RE-ENGAGED (the community stratum pack owns
                  the skipping CRO; this region reads the transduced regime and gain).

    THE SAFETY PROPERTY: NO UNDEFINED VALENCE. The committed appraisal must be a
    member of the VALENCE SET — or the explicit no_appraisal — and the region may
    NEVER emit a valence outside the defined set (an invented affective tag). The
    legal valence set is CONTEXT-DEPENDENT on the cortisol regime (under stress,
    APPETITIVE is suppressed — it is not a legal appraisal while stressed), and the
    committed appraisal carries a CONTINUOUS salience, so the legal set is neither a
    fixed list nor even countable. So region_stratum_commit_appraisal/2 DECLARES the
    membership contract in its ACCESSOR form (a membership-TEST goal, N11 — the set
    is never materialised) AND in ONCE mode (Wave 8 Part One — the region commits ONE
    appraisal per stimulus, checked deterministically). Nothing is hand-rolled.

    THE CONDITIONING LOOP is a real reentrant loop — appraise, condition, re-appraise
    — settling as a cue acquires (or extinguishes) a learned valence, coordinated
    through the Lattice (stigmergy plus notification, zero actor-to-actor references,
    no busy-poll). The association changes MONOTONICALLY toward its asymptote under a
    steady schedule; the loop CONVERGES (the association settles), BOUNDED-STOPS
    (reaches its trial bound — a legal "not fully conditioned", as partial
    reinforcement does), or — never — hangs.

    Its STRUCTURE is grounded in Causalontology 3.0.0. It imports the cellular
    projection neurons (Layer 2), the synaptic associative write (Layer 3), and the
    macromolecular cortisol cascade (Layer 1) — all DOWNWARD edges — plus the minting
    vocabulary, the Lattice, and PrologAI's membership_contract construct. Its
    layer(4), matching ordinal 9 as the region stratum, passes the layer rule and the
    N6 binding. It does NOT import the community stratum (ordinal 14, layer 5): the
    social source of cortisol is UPSTREAM, and the region reads only the transduced
    signal — so no upward edge is created.
*/

% Declare the module: the three sub-modules, the committed appraisal, the conditioning loop, and the structure accessors.
:- module(region_stratum, [
    % region_stratum_appraise/4: the appraisal sub-module — a stimulus's valence and salience given cortisol and the learned association.
    region_stratum_appraise/4,
    % region_stratum_legal_appraisal/1: the membership-TEST goal — a committed appraisal legal in its regime (never materialised).
    region_stratum_legal_appraisal/1,
    % region_stratum_valence_in_regime/2: the (context-dependent) legal valence tags for a cortisol regime.
    region_stratum_valence_in_regime/2,
    % region_stratum_commit_appraisal/2: the guarded commit — the committed appraisal is a member of the valence set (once mode).
    region_stratum_commit_appraisal/2,
    % region_stratum_appraise_committed/4: appraise a stimulus and commit the appraisal THROUGH the contract.
    region_stratum_appraise_committed/4,
    % region_stratum_condition/3: the conditioning sub-module — strengthen or extinguish the learned association.
    region_stratum_condition/3,
    % region_stratum_condition_tick/1: the reentrant conditioning actor — one appraise/condition step via the Lattice.
    region_stratum_condition_tick/1,
    % region_stratum_run_conditioning/3: drive the reentrant conditioning loop for one episode and read its outcome.
    region_stratum_run_conditioning/3,
    % region_stratum_appraisal_occurrent/1: the appraisal occurrent (referenced by this pack's structure records).
    region_stratum_appraisal_occurrent/1,
    % region_stratum_conditioning_occurrent/1: the fear-conditioning occurrent (referenced by this pack's structure records).
    region_stratum_conditioning_occurrent/1,
    % region_stratum_stratum/1: the region stratum record (its ordinal is read by the binding and skip checks).
    region_stratum_stratum/1,
    % region_stratum_records/1: the labelled list of this stratum's eleven structure records.
    region_stratum_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).
% Import the Lattice substrate (Layer 0) for the reentrant conditioning loop.
:- use_module(library(neural_lattice)).
% Import the cellular projection neurons (Layer 2) for the sensory encoding and the bounded salience projection.
:- use_module(library(cellular_stratum)).
% Import the synaptic associative write (Layer 3) for the conditioning step, and the plasticity occurrent the input port names.
:- use_module(library(synaptic_stratum)).
% Import the macromolecular cortisol cascade (Layer 1) for the regime, threat gain, and reward suppression.
:- use_module(library(macromolecular_stratum)).
% Import PrologAI's MEMBERSHIP CONTRACT construct (N8/N11/N14, external) — the committed appraisal DECLARES it.
:- use_module(library(membership_contract)).
% Import PrologAI's Lattice directly for the reentrant loop's cue post and BOUNDED result await.
:- use_module(library(lattice), [lattice_put/4, lattice_await/5, lattice_take/4]).
% Import list utilities.
:- use_module(library(lists)).

% ---------------------------------------------------------------------------
% The native constants of appraisal and conditioning (kept native — thresholds and rates, not CROs).
% ---------------------------------------------------------------------------

% The effective-threat level at or above which the appraisal is THREAT.
region_stratum_threat_cut(0.5).
% The effective-reward level at or above which the appraisal is APPETITIVE (baseline only — stress suppresses reward).
region_stratum_reward_cut(0.5).
% The level at or above which a sub-threshold threat or reward reads as SAFE (wary) rather than neutral.
region_stratum_safe_cut(0.2).
% The association change at or below which the conditioning loop declares the association SETTLED (converged).
region_stratum_settle_tolerance(0.05).
% The maximum number of conditioning trials before an explicit bounded-stop (a legal "not fully conditioned").
region_stratum_settling_bound(8).

% ---------------------------------------------------------------------------
% APPRAISE / CONDITION — the sub-modules.
% ---------------------------------------------------------------------------

% -- region_stratum_appraise(+Stimulus, +Cortisol, +Assoc, -Appraisal): assign a valence and a salience.
% Combines the stimulus's innate threat/reward feature (down from the cellular neurons) with the LEARNED association,
% MODULATED by cortisol (threat gain up, reward suppressed under stress — down from the macromolecular cascade). An
% UNKNOWN stimulus yields no_appraisal — the region abstains, never inventing a tag. Otherwise Appraisal is the term
% appraisal(Valence, Salience, Regime), carrying its cortisol regime so its legality can be judged in context.
region_stratum_appraise(Stimulus, Cortisol, Assoc, Appraisal) :-
    % An unknown stimulus (the cellular neurons do not encode it) means the region abstains.
    ( cellular_stratum_encode(Stimulus, feature(Threat, Reward))
    ->  % Read the cortisol regime, the threat gain, and the reward suppression (the transduced modulation).
        macromolecular_stratum_cortisol_regime(Cortisol, Regime),
        macromolecular_stratum_threat_gain(Cortisol, Gain),
        macromolecular_stratum_reward_suppression(Regime, RewardFactor),
        % The effective threat is the innate threat plus the learned association, gained by cortisol, projected to a bounded rate.
        ThreatDrive is (Threat + Assoc) * Gain,
        cellular_stratum_project(ThreatDrive, EffThreat),
        % The effective reward is the innate reward, suppressed by cortisol under stress, projected to a bounded rate.
        RewardDrive is Reward * RewardFactor,
        cellular_stratum_project(RewardDrive, EffReward),
        % Decide the valence from the effective threat and reward against the cuts.
        region_stratum_decide_valence(EffThreat, EffReward, Valence),
        % The salience is the larger of the two effective magnitudes (how much the stimulus matters).
        ( EffThreat >= EffReward -> Salience = EffThreat ; Salience = EffReward ),
        % Assemble the appraisal, carrying its regime.
        Appraisal = appraisal(Valence, Salience, Regime)
    ;   % No encoding — abstain.
        Appraisal = no_appraisal ).

% -- region_stratum_decide_valence(+EffThreat, +EffReward, -Valence): the valence tag from the effective magnitudes.
region_stratum_decide_valence(EffThreat, EffReward, Valence) :-
    % Read the three cuts.
    region_stratum_threat_cut(ThreatCut),
    region_stratum_reward_cut(RewardCut),
    region_stratum_safe_cut(SafeCut),
    % A strong effective threat is THREAT; else a strong effective reward is APPETITIVE; else a mild signal is SAFE; else NEUTRAL.
    ( EffThreat >= ThreatCut       -> Valence = threat
    ; EffReward >= RewardCut       -> Valence = appetitive
    ; ( EffThreat >= SafeCut ; EffReward >= SafeCut ) -> Valence = safe
    ;   Valence = neutral ).

% -- region_stratum_condition(+Assoc0, +Paired, -Assoc1): one fear-conditioning (or extinction) trial.
% Delegates to the synaptic associative write: a paired trial strengthens the association, an unpaired one weakens it.
% DYNAMICS, kept native (the synaptic rate law), never forced into a causal_relation_object.
region_stratum_condition(Assoc0, Paired, Assoc1) :-
    % The learned association is written by the synaptic stratum's associative plasticity (a downward call).
    synaptic_stratum_potentiate(Assoc0, Paired, Assoc1).

% ---------------------------------------------------------------------------
% NO UNDEFINED VALENCE — the legal valence set, and the committed appraisal that DECLARES the contract.
% ---------------------------------------------------------------------------

% -- region_stratum_valence_in_regime(+Regime, ?Valence): the legal valence tags for a cortisol regime.
% This is where the legal set is CONTEXT-DEPENDENT: at BASELINE all four valences are legal; under STRESS the
% appetitive (reward/approach) appraisal is SUPPRESSED and is NOT a legal tag. Cortisol narrows the valence set —
% the exact case the accessor form (a membership-TEST goal) exists for.
region_stratum_valence_in_regime(baseline, Valence) :-
    % At baseline the amygdala may assign any of the four defined valences.
    member(Valence, [threat, safe, appetitive, neutral]).
region_stratum_valence_in_regime(stress, Valence) :-
    % Under stress the reward/approach appraisal is suppressed — appetitive is not available.
    member(Valence, [threat, safe, neutral]).

% -- region_stratum_legal_appraisal(+Appraisal): the membership-TEST goal for a committed appraisal.
% Succeeds when the appraisal names a valence LEGAL IN ITS REGIME and a well-formed salience in [0.0, 1.0]. The set of
% legal appraisals is context-dependent (the regime) AND uncountable (the continuous salience), so the accessor form
% checks membership against THIS goal WITHOUT materialising any set. This is a PURE, deterministic membership test.
region_stratum_legal_appraisal(appraisal(Valence, Salience, Regime)) :-
    % The salience must be a number within the unit interval.
    number(Salience),
    Salience >= 0.0,
    Salience =< 1.0,
    % The valence must be a legal tag IN this appraisal's cortisol regime (the context-dependent, never-materialised set).
    region_stratum_valence_in_regime(Regime, Valence).

% -- region_stratum_commit_appraisal(+Proposed, -Committed): the guarded commit of one appraisal.
% Deliberately thin: it returns the proposed appraisal, and the DECLARED membership contract (below) is what refuses
% one whose valence is undefined (an invented tag), out of range, or illegal in its regime. The region commits ONE
% appraisal per stimulus, so the contract is in ONCE mode.
region_stratum_commit_appraisal(Proposed, Proposed).
% DECLARE THE MEMBERSHIP CONTRACT: argument 2 (the committed appraisal) must satisfy the legal-appraisal test goal (a
% context-dependent, uncountable set, never materialised — the N11 accessor form), or be the explicit no_appraisal,
% and it is checked on the COMMITTED single answer, deterministically (ONCE mode, Wave 8 Part One). Nothing hand-rolled.
:- membership_contract_enforce_goal(region_stratum_commit_appraisal/2, 2,
        region_stratum_legal_appraisal, no_appraisal, once).

% -- region_stratum_appraise_committed(+Stimulus, +Cortisol, +Assoc, -Committed): appraise and commit THROUGH the contract.
% The appraisal the region actually emits: appraise the stimulus, then commit the result, so every emitted appraisal has
% passed the once-mode membership contract (a legal valence in its regime, or the explicit no_appraisal).
region_stratum_appraise_committed(Stimulus, Cortisol, Assoc, Committed) :-
    % Compute the appraisal.
    region_stratum_appraise(Stimulus, Cortisol, Assoc, Proposed),
    % Commit it through the DECLARED once-mode membership contract.
    region_stratum_commit_appraisal(Proposed, Committed).

% ---------------------------------------------------------------------------
% THE CONDITIONING LOOP — the reentrant runtime actor, closed with the Lattice hybrid.
% ---------------------------------------------------------------------------

% -- region_stratum_condition_tick(+Nexus): one conditioning pass, coordinated through the Lattice.
% Awaits the numbered trial cue (phase 1), APPRAISES the cue (committing through the contract), does ONE conditioning
% step, and either POSTS THE NEXT TRIAL CUE (reentry through the Lattice) or posts the settled result (phase 2). The
% association changes MONOTONICALLY under a steady schedule; a partial schedule oscillates and bounded-stops.
region_stratum_condition_tick(Nexus) :-
    % Block with no busy-poll until the trial cue (phase 1) exists, then take it.
    neural_lattice_await_cue(Nexus, 1, State0),
    % Read the cue stimulus, the cortisol level, the current association, the schedule, the trial counter, the last change, and the token.
    get_dict(stimulus, State0, Stimulus),
    get_dict(cortisol, State0, Cortisol),
    get_dict(assoc, State0, Assoc),
    get_dict(schedule, State0, Schedule),
    get_dict(iter, State0, Iter0),
    get_dict(last_change, State0, LastChange),
    get_dict(token, State0, Token0),
    % APPRAISE the cue at the current association and commit it through the once-mode contract (the guarantee holds every trial).
    region_stratum_appraise_committed(Stimulus, Cortisol, Assoc, Appraisal),
    % Advance the token by one for this conditioning hop.
    Token is Token0 + 1,
    % Record and print the conditioning hop; the beat arrived VIA the Lattice.
    neural_lattice_hop(lattice, amygdala_conditioning, Token),
    % Read the settling tolerance and the trial bound.
    region_stratum_settle_tolerance(Tol),
    region_stratum_settling_bound(Bound),
    % Route on whether the association has settled or the trial budget is spent.
    ( LastChange =< Tol
    % Converged: the association has stopped changing — the cue has settled to a stable learned valence.
    ->  region_stratum_valence_of(Appraisal, Valence),
        format(string(L1), "amygdala: CONVERGED after ~w trials — association ~3f, cue appraised ~w, salience ~w (the association settled)", [Iter0, Assoc, Valence, Appraisal]),
        neural_lattice_narrate('      ', L1),
        State1 = State0.put(_{result: converged(Assoc, Valence, Iter0), token: Token}),
        neural_lattice_post_cue(Nexus, 2, State1)
    ; Iter0 >= Bound
    % Bounded-stop: reached the trial bound with the association still changing — a legal "not fully conditioned" (partial reinforcement).
    ->  region_stratum_valence_of(Appraisal, Valence),
        format(string(L2), "amygdala: BOUNDED-STOP at ~w trials — association ~3f, cue appraised ~w (not fully conditioned, not a hang)", [Iter0, Assoc, Valence]),
        neural_lattice_narrate('      ', L2),
        State1 = State0.put(_{result: bounded_stop(Assoc, Valence, Iter0), token: Token}),
        neural_lattice_post_cue(Nexus, 2, State1)
    ;   % One conditioning step: decide the trial's pairing from the schedule, CONDITION, and RE-ENTER via the Lattice.
        region_stratum_trial_paired(Schedule, Iter0, Paired),
        region_stratum_condition(Assoc, Paired, Assoc1),
        Change is abs(Assoc1 - Assoc),
        Iter1 is Iter0 + 1,
        region_stratum_valence_of(Appraisal, Valence),
        format(string(L3), "amygdala: trial ~w (~w) — association ~3f -> ~3f, cue appraised ~w", [Iter1, Paired, Assoc, Assoc1, Valence]),
        neural_lattice_narrate('      ', L3),
        State1 = State0.put(_{assoc: Assoc1, iter: Iter1, last_change: Change, token: Token}),
        neural_lattice_post_cue(Nexus, 1, State1)
    ).

% -- region_stratum_valence_of(+Appraisal, -Valence): read the valence tag out of an appraisal (or 'none' for the abstention).
region_stratum_valence_of(appraisal(Valence, _, _), Valence) :- !.
region_stratum_valence_of(no_appraisal, none).

% -- region_stratum_trial_paired(+Schedule, +Iter, -Paired): whether this trial pairs the cue with the aversive outcome.
% A 'paired' schedule always pairs (acquisition); 'unpaired' never pairs (extinction); 'partial' alternates, so the
% association oscillates and never fully settles (partial reinforcement — the honest bounded-stop case).
region_stratum_trial_paired(paired, _Iter, true).
region_stratum_trial_paired(unpaired, _Iter, false).
region_stratum_trial_paired(partial, Iter, Paired) :-
    % Pair on even trials, omit on odd trials — an alternating schedule.
    ( 0 is Iter mod 2 -> Paired = true ; Paired = false ).

% -- region_stratum_run_conditioning(+Nexus, +Seed, -Result): post the trial cue, await the settled result.
% Blocks (BOUNDED) for the phase-2 result — converged(...) or bounded_stop(...) — so a hang FAILS rather than blocks.
region_stratum_run_conditioning(Nexus, Seed, Result) :-
    % Post the initial trial cue (phase 1) — the cue, cortisol, and starting association enter the conditioning loop.
    neural_lattice_post_cue(Nexus, 1, Seed),
    % Block (BOUNDED, 30 s) for the phase-2 result; on timeout this FAILS (a hang the runner reports).
    lattice_await(Nexus, phase_2, 30, _, _),
    % Consume exactly one phase-2 result cue.
    lattice_take(Nexus, phase_2, [Done], _),
    % Read the conditioning result the tick posted.
    get_dict(result, Done, Result).

% ---------------------------------------------------------------------------
% The structure records (co-located with the runtime, the verdict's stratum-primary stance).
% ---------------------------------------------------------------------------

% -- region_stratum_stratum(-Out): the brain-region stratum record (ordinal 9).
region_stratum_stratum(Out) :-
    % Mint the region stratum with the anatomy's fields (the shared neuroendocrine ladder).
    cm_stratum("region", "neuroendocrine", 9, "brain_region", ["systems_neuroscience"], Out).

% -- region_stratum_amygdala_continuant(-Out): the amygdala bearer (the appraiser).
region_stratum_amygdala_continuant(Out) :-
    % Mint the amygdala continuant (the physical bearer of appraise -> condition -> re-appraise).
    cm_cnt("amygdala", "object", Out).

% -- region_stratum_appraisal_occurrent(-Out): the appraisal event, at the region stratum.
region_stratum_appraisal_occurrent(Out) :-
    % Read this pack's own stratum id.
    region_stratum_stratum(SRegion),
    % Mint the appraisal occurrent (the committed, membership-checked valence-and-salience assignment).
    cm_occ("affective_appraisal", "event", SRegion.id, Out).

% -- region_stratum_conditioning_occurrent(-Out): the fear-conditioning process, at the region stratum.
region_stratum_conditioning_occurrent(Out) :-
    % Read this pack's own stratum id.
    region_stratum_stratum(SRegion),
    % Mint the fear-conditioning occurrent (the associative learning that grows a cue's threat association).
    cm_occ("fear_conditioning", "process", SRegion.id, Out).

% -- region_stratum_salience_occurrent(-Out): the salience-tagging process, at the region stratum.
region_stratum_salience_occurrent(Out) :-
    % Read this pack's own stratum id.
    region_stratum_stratum(SRegion),
    % Mint the salience-tagging occurrent (the how-much-it-matters magnitude the appraisal carries).
    cm_occ("salience_tagging", "process", SRegion.id, Out).

% -- region_stratum_extinction_occurrent(-Out): the extinction process, at the region stratum.
region_stratum_extinction_occurrent(Out) :-
    % Read this pack's own stratum id.
    region_stratum_stratum(SRegion),
    % Mint the extinction occurrent (the unlearning of a cue's threat association under an unpaired schedule).
    cm_occ("extinction", "process", SRegion.id, Out).

% -- region_stratum_appraisal_realizable(-Out): the appraisal disposition of the amygdala.
region_stratum_appraisal_realizable(Out) :-
    % Read the amygdala bearer id.
    region_stratum_amygdala_continuant(CAmygdala),
    % Mint the appraisal disposition it bears.
    cm_rlz(CAmygdala.id, "disposition", "affective_appraisal", Out).

% -- region_stratum_stimulus_input_port(-Out): the stimulus input, accepting the sensory encoding and the associative write.
region_stratum_stimulus_input_port(Out) :-
    % The bearer is the amygdala.
    region_stratum_amygdala_continuant(CAmygdala),
    % The port accepts the sensory encoding (a downward reference to cellular_stratum).
    cellular_stratum_encoding_occurrent(OEncode),
    % It also accepts the associative plasticity write (a downward reference to synaptic_stratum).
    synaptic_stratum_plasticity_occurrent(OPlast),
    % Mint the input port accepting both the sensed stimulus and the learned association.
    cm_port(CAmygdala.id, "stimulus_input", "in", [OEncode.id, OPlast.id], Out).

% -- region_stratum_appraisal_output_port(-Out): the committed-appraisal output port.
region_stratum_appraisal_output_port(Out) :-
    % The bearer is the amygdala.
    region_stratum_amygdala_continuant(CAmygdala),
    % The port emits the appraisal occurrent.
    region_stratum_appraisal_occurrent(OAppraise),
    % Mint the output port.
    cm_port(CAmygdala.id, "appraisal_output", "out", [OAppraise.id], Out).

% -- region_stratum_appraisal_cro(-Out): the region-internal appraisal CRO (fear conditioning -> appraisal).
region_stratum_appraisal_cro(Out) :-
    % The cause is the fear-conditioning occurrent (the learned association).
    region_stratum_conditioning_occurrent(OCond),
    % The effect is the appraisal occurrent (both at the region stratum — no cross-stratal span; the cortisol skip lives in the community pack).
    region_stratum_appraisal_occurrent(OAppraise),
    % Mint the appraisal CRO: the learned association is sufficient to shift the cue's appraisal toward threat.
    cm_cro([OCond.id], [OAppraise.id],
           [modality-"sufficient", temporal-_{minimum_delay:0, maximum_delay:1, unit:"seconds"}],
           Out).

% -- region_stratum_appraisal_conduit(-Out): the COMPUTATIONAL appraisal pathway (transform = the appraisal CRO).
region_stratum_appraisal_conduit(Out) :-
    % The from-port is the stimulus input.
    region_stratum_stimulus_input_port(PIn),
    % The to-port is the appraisal output.
    region_stratum_appraisal_output_port(POut),
    % The carried occurrent is the appraisal.
    region_stratum_appraisal_occurrent(OAppraise),
    % The transform is the appraisal CRO — asserting the conduit computes (it appraises, a wire cannot).
    region_stratum_appraisal_cro(CroAppraise),
    % Mint the computational conduit.
    cm_conduit(PIn.id, POut.id, [OAppraise.id], "appraisal_pathway", CroAppraise.id, Out).

% -- region_stratum_records(-Records): this stratum's eleven structure records.
region_stratum_records(Records) :-
    % Mint the stratum, the bearer, and the four occurrents.
    region_stratum_stratum(SRegion),
    region_stratum_amygdala_continuant(CAmygdala),
    region_stratum_appraisal_occurrent(OAppraise),
    region_stratum_conditioning_occurrent(OCond),
    region_stratum_salience_occurrent(OSalience),
    region_stratum_extinction_occurrent(OExtinct),
    % Mint the realizable, the two ports, the appraisal CRO, and the appraisal conduit.
    region_stratum_appraisal_realizable(RAppraise),
    region_stratum_stimulus_input_port(PIn),
    region_stratum_appraisal_output_port(POut),
    region_stratum_appraisal_cro(CroAppraise),
    region_stratum_appraisal_conduit(KAppraise),
    % Assemble the labelled record list.
    Records = [
        record(stratum_region,             stratum,                SRegion),
        record(continuant_amygdala,        continuant,             CAmygdala),
        record(occurrent_affective_appraisal, occurrent,           OAppraise),
        record(occurrent_fear_conditioning, occurrent,             OCond),
        record(occurrent_salience_tagging, occurrent,              OSalience),
        record(occurrent_extinction,       occurrent,              OExtinct),
        record(realizable_affective_appraisal, realizable,         RAppraise),
        record(port_stimulus_input,        port,                   PIn),
        record(port_appraisal_output,      port,                   POut),
        record(cro_appraisal,              causal_relation_object, CroAppraise),
        record(conduit_appraisal,          conduit,                KAppraise)
    ].
