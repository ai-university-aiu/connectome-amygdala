/*  connectome-amygdala — community_stratum (ordinal 14 -> pack layer 5): THE SOCIAL SOURCE OF CORTISOL.

    THE HIGH END OF THE CORTISOL SKIP, at the community-and-society stratum
    (Causalontology ordinal 14). A social or contextual stressor — the top of the
    neuroendocrine ladder — raises circulating cortisol, which descends to the
    glucocorticoid receptor cascade at the macromolecular stratum (ordinal 4),
    SKIPPING every stratum between. This is the layer-skipping cortisol channel the
    Wave 2 slice first minted, RE-ENGAGED, not re-invented: the same shape (community
    14 -> macromolecular 4, skips:true), minted fresh for this region.

    Under the Wave 3 verdict this is one pack per stratum on the outside, one
    construct per module inside. This pack is PURE — it has NO runtime tick and never
    coordinates on the Lattice. Its ONE job is STRUCTURE: it mints the social-stressor
    occurrent (the skip's high endpoint), the cortisol skipping causal_relation_object
    (its low endpoint is the macromolecular receptor-activation occurrent, imported
    DOWNWARD), and a signed provenance assertion over the skip.

    THE SKIP IS A LEGAL DOWNWARD EDGE. It jumps community (14) to macromolecular (4)
    without modeling the endocrine pathway between (the hypothalamic-pituitary-adrenal
    axis), so it carries skips:true honestly — the absence of a modeled mechanism is a
    finding, not a gap (the Wave 2 slice's discipline) — and classifies as a clean
    skip. Its pack layer(5) matches ordinal 14 as the coarsest stratum; it imports the
    macromolecular stratum (Layer 1) DOWNWARD for the skip's low endpoint, and never
    imports the region — so it adds no upward edge. The layer rule and the N6 binding
    both pass.
*/

% Declare the module: the social-stressor occurrent, the cortisol skip CRO, the skip check, and the structure accessors.
:- module(community_stratum, [
    % community_stratum_stressor_occurrent/1: the social-stressor occurrent (the cortisol skip's HIGH endpoint).
    community_stratum_stressor_occurrent/1,
    % community_stratum_cortisol_skip_cro/1: the cortisol skipping CRO (community 14 -> macromolecular 4, skips:true).
    community_stratum_cortisol_skip_cro/1,
    % community_stratum_skip_check/2: the skip classification of the cortisol CRO.
    community_stratum_skip_check/2,
    % community_stratum_signed_assertion/1: the Ed25519-signed provenance over the cortisol skip CRO.
    community_stratum_signed_assertion/1,
    % community_stratum_stratum/1: the community-and-society stratum record (ordinal 14).
    community_stratum_stratum/1,
    % community_stratum_records/1: the labelled list of this stratum's four structure records.
    community_stratum_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).
% Import the macromolecular cortisol cascade (Layer 1) for the skip's low endpoint — a DOWNWARD edge (14 -> 4).
:- use_module(library(macromolecular_stratum)).
% Import PrologAI's Causalontology engine (external) for the skip classification.
:- use_module(library(causal_core)).
% Import list utilities.
:- use_module(library(lists)).

% ---------------------------------------------------------------------------
% The structure records (co-located with the pack, the verdict's stratum-primary stance).
% ---------------------------------------------------------------------------

% -- community_stratum_stratum(-Out): the community-and-society stratum record (ordinal 14).
community_stratum_stratum(Out) :-
    % Mint the community-and-society stratum with the anatomy's fields (the shared neuroendocrine ladder).
    cm_stratum("community_and_society", "neuroendocrine", 14, "community", ["sociology"], Out).

% -- community_stratum_stressor_occurrent(-Out): the social-stressor process, at the community stratum.
% This is the HIGH ENDPOINT of the cross-stratal cortisol skip: a social/contextual stressor that raises cortisol.
community_stratum_stressor_occurrent(Out) :-
    % Read this pack's own stratum id.
    community_stratum_stratum(SCommunity),
    % Mint the social-stressor occurrent (the top of the neuroendocrine ladder — the source of the stress signal).
    cm_occ("social_stressor", "process", SCommunity.id, Out).

% -- community_stratum_cortisol_skip_cro(-Out): the cortisol skip CRO (social stressor -> receptor activation, skips:true).
community_stratum_cortisol_skip_cro(Out) :-
    % The cause is this pack's own social-stressor occurrent (community, ordinal 14).
    community_stratum_stressor_occurrent(OStressor),
    % The effect is the macromolecular receptor-activation occurrent (macromolecular, ordinal 4) — a downward reference.
    macromolecular_stratum_receptor_occurrent(OReceptor),
    % Mint the CRO flagged skips:true — cortisol jumps community 14 -> macromolecular 4 without modeling the HPA-axis pathway.
    cm_cro([OStressor.id], [OReceptor.id], [skips-true], Out).

% -- community_stratum_signed_assertion(-Signed): an Ed25519-signed provenance over the cortisol skip CRO.
community_stratum_signed_assertion(Signed) :-
    % Read the cortisol skip CRO's content-addressed id.
    community_stratum_cortisol_skip_cro(CroSkip),
    % Mint and sign the provenance assertion over that id.
    cm_signed_assertion_over(CroSkip.id, Signed).

% -- community_stratum_skip_check(-Class, -Gaps): classify the cortisol skip CRO and read its skip-gaps.
community_stratum_skip_check(Class, Gaps) :-
    % Mint the cortisol skip CRO and its two endpoint occurrents.
    community_stratum_cortisol_skip_cro(CroSkip),
    community_stratum_stressor_occurrent(OStressor),
    macromolecular_stratum_receptor_occurrent(OReceptor),
    % Mint the two strata the CRO spans (this pack's community, and the imported macromolecular).
    community_stratum_stratum(SCommunity),
    macromolecular_stratum_stratum(SMacro),
    % Build the occurrent and stratum maps the classifier needs.
    cm_map_of([OStressor, OReceptor], OccMap),
    cm_map_of([SCommunity, SMacro], StratumMap),
    % Classify the cross-stratal relation (expected: skipping).
    causal_core_classify(CroSkip, OccMap, StratumMap, Class),
    % Read the skip-gaps (expected: none — skips:true makes the absent HPA-axis mechanism a positive finding).
    causal_core_skip_gaps(CroSkip, Class, Gaps).

% -- community_stratum_records(-Records): this stratum's four structure records.
community_stratum_records(Records) :-
    % Mint the stratum, the social-stressor occurrent, the cortisol skip CRO, and the signed assertion.
    community_stratum_stratum(SCommunity),
    community_stratum_stressor_occurrent(OStressor),
    community_stratum_cortisol_skip_cro(CroSkip),
    community_stratum_signed_assertion(Signed),
    % Assemble the labelled record list.
    Records = [
        record(stratum_community,          stratum,                SCommunity),
        record(occurrent_social_stressor,  occurrent,              OStressor),
        record(cro_cortisol_skip,          causal_relation_object, CroSkip),
        record(assertion_cortisol_provenance, assertion,           Signed)
    ].
