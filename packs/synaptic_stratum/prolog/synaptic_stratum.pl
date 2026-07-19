/*  connectome-amygdala — synaptic_stratum (ordinal 7 -> pack layer 3): THE ASSOCIATIVE PLASTICITY WRITE.

    THE SYNAPSE WHERE A NEUTRAL CUE ACQUIRES A THREAT MEANING, at the synaptic
    stratum (Causalontology ordinal 7). Under the Wave 3 verdict's rule (one pack
    per stratum on the OUTSIDE, one construct per module on the INSIDE) this pack IS
    the synaptic stratum. Its ONE construct is the ASSOCIATIVE PLASTICITY WRITE: the
    long-term potentiation of the lateral-amygdala synapse where a conditioned
    stimulus (a tone) converges with an aversive unconditioned stimulus (a shock),
    so the tone later evokes threat — fear conditioning, and its reverse, extinction.
    That is DYNAMICS, kept native (an associative learning rule, never a
    causal_relation_object, per the grounding rule) — a single sub-module,
    synaptic_stratum_potentiate/3.

    Its STRUCTURE is grounded in Causalontology 2.0.0: the synaptic stratum record,
    the lateral-amygdala convergence synapse continuant that bears the plasticity,
    the sensory-afferent synapse continuant that delivers the cue, the potentiation
    (association-change) occurrent, and the plasticity disposition.

    THE PACK IS PURE — no runtime tick, no Lattice coordination. The write is a
    downward mechanism the region's conditioning step invokes. It imports the minting
    vocabulary (0) and nothing upward; its layer(3) matches ordinal 7, above the
    projection neurons (ordinal 6) and below the region circuit (ordinal 9).
*/

% Declare the module: the native associative write, its occurrent (referenced by the region), and the structure accessors.
:- module(synaptic_stratum, [
    % synaptic_stratum_potentiate/3: the native write — strengthen (paired) or weaken (unpaired) the learned association.
    synaptic_stratum_potentiate/3,
    % synaptic_stratum_plasticity_occurrent/1: the association-change occurrent (the region's conditioning endpoint).
    synaptic_stratum_plasticity_occurrent/1,
    % synaptic_stratum_stratum/1: the synaptic stratum record.
    synaptic_stratum_stratum/1,
    % synaptic_stratum_records/1: the labelled list of this stratum's five structure records.
    synaptic_stratum_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).

% ---------------------------------------------------------------------------
% The native dynamics (kept native per the grounding rule — an associative rule, not a CRO).
% ---------------------------------------------------------------------------

% The associative learning rate — the fraction of the gap to the asymptote closed per conditioning trial.
synaptic_stratum_learning_rate(0.5).

% -- synaptic_stratum_potentiate(+Assoc0, +Paired, -Assoc1): one associative plasticity write.
% When the conditioned stimulus is PAIRED with the aversive outcome, the association strengthens toward 1.0 (fear
% acquisition: a Rescorla-Wagner step closing half the remaining gap). When UNPAIRED, it weakens toward 0.0
% (extinction). The association is a strength in [0.0, 1.0]; the write only changes HOW STRONG it is, never invents
% a valence — the region's contract, not this write, guards the committed appraisal.
synaptic_stratum_potentiate(Assoc0, true, Assoc1) :-
    % Paired: confirm the current strength is a number, then COMMIT to this clause (the pairing selects it, deterministically).
    number(Assoc0), !,
    % Close half the gap to the ceiling (1.0) — the learned threat association grows, monotonically.
    synaptic_stratum_learning_rate(Lr),
    Assoc1 is Assoc0 + Lr * (1.0 - Assoc0).
synaptic_stratum_potentiate(Assoc0, false, Assoc1) :-
    % Unpaired: confirm the current strength is a number, then COMMIT to this clause (deterministically).
    number(Assoc0), !,
    % Decay toward the floor (0.0) — extinction of the learned association, monotonically.
    synaptic_stratum_learning_rate(Lr),
    Assoc1 is Assoc0 - Lr * Assoc0.

% ---------------------------------------------------------------------------
% The structure records (co-located with the pack, the verdict's stratum-primary stance).
% ---------------------------------------------------------------------------

% -- synaptic_stratum_stratum(-Out): the synaptic stratum record (ordinal 7).
synaptic_stratum_stratum(Out) :-
    % Mint the synaptic stratum with the anatomy's fields (the shared neuroendocrine ladder).
    cm_stratum("synaptic", "neuroendocrine", 7, "synapse", ["synaptic_physiology"], Out).

% -- synaptic_stratum_convergence_continuant(-Out): the lateral-amygdala convergence synapse bearer (the conditioned synapse).
synaptic_stratum_convergence_continuant(Out) :-
    % Mint the convergence synapse continuant (where the cue and the aversive outcome meet — the site of conditioning).
    cm_cnt("lateral_amygdala_convergence_synapse", "object", Out).

% -- synaptic_stratum_afferent_continuant(-Out): the sensory-afferent synapse bearer (delivers the cue).
synaptic_stratum_afferent_continuant(Out) :-
    % Mint the sensory-afferent synapse continuant (carries the conditioned stimulus to the convergence synapse).
    cm_cnt("sensory_afferent_synapse", "object", Out).

% -- synaptic_stratum_plasticity_occurrent(-Out): the association-change event, stamped at the synaptic stratum.
synaptic_stratum_plasticity_occurrent(Out) :-
    % Read this pack's own stratum id.
    synaptic_stratum_stratum(SSyn),
    % Mint the potentiation occurrent (the associative weight change that writes the learned fear association).
    cm_occ("associative_potentiation", "state_change", SSyn.id, Out).

% -- synaptic_stratum_plasticity_realizable(-Out): the plasticity disposition of the convergence synapse.
synaptic_stratum_plasticity_realizable(Out) :-
    % Read the convergence synapse bearer id.
    synaptic_stratum_convergence_continuant(CConverge),
    % Mint the plasticity disposition it bears.
    cm_rlz(CConverge.id, "disposition", "associative_plasticity", Out).

% -- synaptic_stratum_records(-Records): this stratum's five structure records.
synaptic_stratum_records(Records) :-
    % Mint the stratum, the two synapse bearers, the potentiation occurrent, and the plasticity disposition.
    synaptic_stratum_stratum(SSyn),
    synaptic_stratum_convergence_continuant(CConverge),
    synaptic_stratum_afferent_continuant(CAfferent),
    synaptic_stratum_plasticity_occurrent(OPlast),
    synaptic_stratum_plasticity_realizable(RPlast),
    % Assemble the labelled record list.
    Records = [
        record(stratum_synaptic,               stratum,     SSyn),
        record(continuant_convergence_synapse, continuant,  CConverge),
        record(continuant_afferent_synapse,    continuant,  CAfferent),
        record(occurrent_associative_potentiation, occurrent, OPlast),
        record(realizable_associative_plasticity, realizable, RPlast)
    ].
