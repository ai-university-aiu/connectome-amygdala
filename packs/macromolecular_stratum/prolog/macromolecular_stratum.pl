/*  connectome-amygdala — macromolecular_stratum (ordinal 4 -> pack layer 1): THE CORTISOL RECEPTOR CASCADE.

    THE MOLECULAR BASIS OF STRESS MODULATION, at the macromolecular stratum
    (Causalontology ordinal 4). Under the Wave 3 verdict's rule (one pack per
    stratum on the OUTSIDE, one construct per module on the INSIDE) this pack IS
    the macromolecular stratum. Its ONE construct is the CORTISOL (glucocorticoid)
    RECEPTOR CASCADE: the stress hormone binds its receptor and transduces a
    circulating cortisol level into an effect on the amygdala's appraisal — a
    heightened threat gain and a suppressed reward appraisal under stress. That is
    DYNAMICS, kept native (transduction laws, never a causal_relation_object, per
    the grounding rule) — three thin sub-modules: the regime classifier, the threat
    gain, and the reward suppression.

    THIS PACK IS THE LOW END OF THE CORTISOL SKIP. The community-and-society stratum
    (ordinal 14) emits the social stress signal that descends here (ordinal 4),
    skipping every stratum between — the layer-skipping cortisol channel the Wave 2
    slice first minted, RE-ENGAGED, not re-invented. The community stratum pack owns
    the skipping causal_relation_object; this pack owns its low endpoint, the
    receptor-activation occurrent.

    Its STRUCTURE is grounded in Causalontology 3.0.0: the macromolecular stratum
    record, the glucocorticoid-receptor cascade continuant that bears the
    transduction, the receptor-activation occurrent (the skip's low endpoint), the
    appraisal-modulation occurrent, the modulation disposition, and the modulation
    causal_relation_object (receptor activation -> appraisal modulation, both at the
    macromolecular stratum).

    THE PACK IS PURE — no runtime tick, no Lattice coordination. Modulation is a
    downward mechanism the region's appraisal reads. It imports the minting
    vocabulary (0) and nothing upward; its layer(1) is the lowest stratum layer,
    matching ordinal 4 as the finest stratum the region touches (the N6 binding
    check confirms it).
*/

% Declare the module: the native cortisol transduction, the skip's low-end occurrent, and the structure accessors.
:- module(macromolecular_stratum, [
    % macromolecular_stratum_cortisol_regime/2: classify a cortisol level as the baseline or stress regime.
    macromolecular_stratum_cortisol_regime/2,
    % macromolecular_stratum_threat_gain/2: the threat-salience multiplier a cortisol level applies to the appraisal.
    macromolecular_stratum_threat_gain/2,
    % macromolecular_stratum_reward_suppression/2: the reward-appraisal suppression factor for a regime (stress zeroes it).
    macromolecular_stratum_reward_suppression/2,
    % macromolecular_stratum_receptor_occurrent/1: the receptor-activation occurrent (the cortisol skip's LOW endpoint).
    macromolecular_stratum_receptor_occurrent/1,
    % macromolecular_stratum_stratum/1: the macromolecular stratum record (its ordinal is read by the skip and binding checks).
    macromolecular_stratum_stratum/1,
    % macromolecular_stratum_records/1: the labelled list of this stratum's six structure records.
    macromolecular_stratum_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).

% ---------------------------------------------------------------------------
% The native dynamics (kept native per the grounding rule — transduction laws, not CROs).
% ---------------------------------------------------------------------------

% The circulating cortisol level at or above which the receptor cascade switches the amygdala into the stress regime.
macromolecular_stratum_stress_threshold(0.5).

% -- macromolecular_stratum_cortisol_regime(+Cortisol, -Regime): classify a cortisol level.
% A level at or above the stress threshold is the STRESS regime; below it is BASELINE. This is the transduced,
% discrete read-out of the receptor cascade that the region's appraisal carries in the committed appraisal term.
macromolecular_stratum_cortisol_regime(Cortisol, Regime) :-
    % The input must be a number in the unit interval.
    number(Cortisol),
    % Read the stress threshold.
    macromolecular_stratum_stress_threshold(Threshold),
    % At or above threshold is stress; below is baseline.
    ( Cortisol >= Threshold -> Regime = stress ; Regime = baseline ).

% -- macromolecular_stratum_threat_gain(+Cortisol, -Gain): the threat-salience multiplier the cascade applies.
% Cortisol potentiates threat appraisal: the gain rises with the cortisol level (1.0 at rest, higher under stress),
% so the same stimulus reads as more threatening when cortisol is high. A native rate law, never a CRO.
macromolecular_stratum_threat_gain(Cortisol, Gain) :-
    % The input must be a number in the unit interval.
    number(Cortisol),
    % The gain is one plus the cortisol level (1.0 at rest; 2.0 at maximum cortisol).
    Gain is 1.0 + Cortisol.

% -- macromolecular_stratum_reward_suppression(+Regime, -Factor): the reward-appraisal suppression for a regime.
% Under acute stress the glucocorticoid cascade suppresses reward/approach appraisal — the region cannot appraise a
% stimulus as appetitive while stressed. Baseline leaves reward intact (factor 1.0); stress zeroes it (factor 0.0).
macromolecular_stratum_reward_suppression(baseline, 1.0).
macromolecular_stratum_reward_suppression(stress, 0.0).

% ---------------------------------------------------------------------------
% The structure records (co-located with the pack, the verdict's stratum-primary stance).
% ---------------------------------------------------------------------------

% -- macromolecular_stratum_stratum(-Out): the macromolecular stratum record (ordinal 4).
macromolecular_stratum_stratum(Out) :-
    % Mint the macromolecular stratum with the anatomy's fields (the shared neuroendocrine ladder).
    cm_stratum("macromolecular", "neuroendocrine", 4, "macromolecule", ["molecular_neuroscience"], Out).

% -- macromolecular_stratum_receptor_continuant(-Out): the glucocorticoid-receptor cascade bearer.
macromolecular_stratum_receptor_continuant(Out) :-
    % Mint the glucocorticoid-receptor cascade continuant (the molecular basis of cortisol's effect on appraisal).
    cm_cnt("glucocorticoid_receptor_cascade", "object", Out).

% -- macromolecular_stratum_receptor_occurrent(-Out): the receptor-activation state, stamped at the macromolecular stratum.
% This is the LOW ENDPOINT of the cross-stratal cortisol skip (community 14 -> macromolecular 4): the social stress
% signal descends and activates this receptor. The community stratum pack references this occurrent as the skip's effect.
macromolecular_stratum_receptor_occurrent(Out) :-
    % Read this pack's own stratum id.
    macromolecular_stratum_stratum(SMacro),
    % Mint the receptor-activation occurrent (cortisol binding its receptor — the transduction event).
    cm_occ("glucocorticoid_receptor_activation", "state_change", SMacro.id, Out).

% -- macromolecular_stratum_modulation_occurrent(-Out): the appraisal-modulation process, stamped at the macromolecular stratum.
macromolecular_stratum_modulation_occurrent(Out) :-
    % Read this pack's own stratum id.
    macromolecular_stratum_stratum(SMacro),
    % Mint the appraisal-modulation occurrent (the downstream effect: threat gain up, reward appraisal down).
    cm_occ("appraisal_modulation", "process", SMacro.id, Out).

% -- macromolecular_stratum_modulation_realizable(-Out): the modulation disposition of the receptor cascade.
macromolecular_stratum_modulation_realizable(Out) :-
    % Read the receptor cascade bearer id.
    macromolecular_stratum_receptor_continuant(CReceptor),
    % Mint the modulation disposition it bears.
    cm_rlz(CReceptor.id, "disposition", "appraisal_modulation", Out).

% -- macromolecular_stratum_modulation_cro(-Out): the modulation CRO (receptor activation -> appraisal modulation, macromolecular-internal).
macromolecular_stratum_modulation_cro(Out) :-
    % The cause is the receptor-activation occurrent.
    macromolecular_stratum_receptor_occurrent(OReceptor),
    % The effect is the appraisal-modulation occurrent (both at the macromolecular stratum — no cross-stratal span).
    macromolecular_stratum_modulation_occurrent(OMod),
    % Mint the modulation CRO with its modality and a fast transduction window (receptor binding is quick).
    cm_cro([OReceptor.id], [OMod.id],
           [modality-"sufficient", temporal-_{minimum_delay:0, maximum_delay:60, unit:"seconds"}],
           Out).

% -- macromolecular_stratum_records(-Records): this stratum's six structure records.
macromolecular_stratum_records(Records) :-
    % Mint the stratum, the receptor bearer, and the two occurrents.
    macromolecular_stratum_stratum(SMacro),
    macromolecular_stratum_receptor_continuant(CReceptor),
    macromolecular_stratum_receptor_occurrent(OReceptor),
    macromolecular_stratum_modulation_occurrent(OMod),
    % Mint the modulation disposition and the modulation CRO.
    macromolecular_stratum_modulation_realizable(RMod),
    macromolecular_stratum_modulation_cro(CroMod),
    % Assemble the labelled record list.
    Records = [
        record(stratum_macromolecular,          stratum,                SMacro),
        record(continuant_glucocorticoid_receptor, continuant,          CReceptor),
        record(occurrent_receptor_activation,   occurrent,              OReceptor),
        record(occurrent_appraisal_modulation,  occurrent,              OMod),
        record(realizable_appraisal_modulation, realizable,             RMod),
        record(cro_appraisal_modulation,        causal_relation_object, CroMod)
    ].
