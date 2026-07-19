% Test suite for the community_stratum pack — the social source of cortisol and the cortisol skip.
% These tests confirm the cortisol skip CRO classifies as a clean skip (community 14 -> macromolecular 4,
% skips:true), that its signed provenance verifies, and that the four structure records are schema-valid.
% Load the community stratum module under test.
:- use_module(library(community_stratum)).
% Load the macromolecular stratum for the skip's low endpoint.
:- use_module(library(macromolecular_stratum)).
% Load PrologAI's schema validator and signing layer for the structure records and the signature.
:- use_module(library(schema_check)).
:- use_module(library(signing)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the community_stratum pack.
:- begin_tests(community_stratum).

% The community-and-society stratum record carries ordinal 14 (the top of the neuroendocrine ladder).
test(stratum_ordinal_is_fourteen) :-
    community_stratum_stratum(S),
    assertion(get_dict(ordinal, S, 14)).

% The cortisol skip runs from the social stressor (community, 14) to the macromolecular receptor (4).
test(skip_endpoints_are_community_and_macromolecular) :-
    community_stratum_stressor_occurrent(OStressor),
    macromolecular_stratum_receptor_occurrent(OReceptor),
    community_stratum_cortisol_skip_cro(Cro),
    % The CRO's cause is the social stressor and its effect is the receptor activation.
    get_dict(causes, Cro, [CauseId]),
    get_dict(effects, Cro, [EffectId]),
    assertion(get_dict(id, OStressor, CauseId)),
    assertion(get_dict(id, OReceptor, EffectId)).

% THE CORTISOL SKIP classifies as a clean skip (skips:true, no gap) — the re-engaged slice channel.
test(cortisol_cro_is_a_clean_skip) :-
    community_stratum_skip_check(Class, Gaps),
    assertion(Class == skipping),
    assertion(Gaps == []).

% The signed provenance over the cortisol skip CRO verifies (Ed25519).
test(signed_assertion_verifies) :-
    community_stratum_signed_assertion(Signed),
    assertion(co_verify_record(Signed, assertion)).

% The four structure records are all schema-valid.
test(records_valid) :-
    community_stratum_records(Records),
    length(Records, 4),
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(community_stratum).
