% Test suite for the macromolecular_stratum pack — the cortisol (glucocorticoid) receptor cascade.
% These tests confirm the native cortisol transduction (regime, threat gain, reward suppression) and that
% the six structure records are schema-valid, including the receptor-activation occurrent (the cortisol skip's low end).
% Load the macromolecular stratum module under test.
:- use_module(library(macromolecular_stratum)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the macromolecular_stratum pack.
:- begin_tests(macromolecular_stratum).

% The regime classifier reads a low cortisol as baseline and a high cortisol as stress.
test(cortisol_regime_threshold) :-
    macromolecular_stratum_cortisol_regime(0.2, R0), assertion(R0 == baseline),
    macromolecular_stratum_cortisol_regime(0.8, R1), assertion(R1 == stress),
    % The threshold itself (0.5) is the stress regime.
    macromolecular_stratum_cortisol_regime(0.5, R2), assertion(R2 == stress).

% The threat gain rises with cortisol (1.0 at rest, higher under stress).
test(threat_gain_rises_with_cortisol) :-
    macromolecular_stratum_threat_gain(0.0, G0), assertion(abs(G0 - 1.0) < 1.0e-9),
    macromolecular_stratum_threat_gain(1.0, G1), assertion(abs(G1 - 2.0) < 1.0e-9),
    % A higher cortisol yields a strictly larger gain.
    macromolecular_stratum_threat_gain(0.3, GA),
    macromolecular_stratum_threat_gain(0.7, GB),
    assertion(GB > GA).

% Reward appraisal is intact at baseline and fully suppressed under stress.
test(reward_suppression_by_regime) :-
    macromolecular_stratum_reward_suppression(baseline, F0), assertion(abs(F0 - 1.0) < 1.0e-9),
    macromolecular_stratum_reward_suppression(stress, F1), assertion(abs(F1 - 0.0) < 1.0e-9).

% The macromolecular stratum record carries ordinal 4 (the finest stratum the region touches).
test(stratum_ordinal_is_four) :-
    macromolecular_stratum_stratum(S),
    assertion(get_dict(ordinal, S, 4)).

% The receptor-activation occurrent (the cortisol skip's low endpoint) is a well-formed occurrent at this stratum.
test(receptor_occurrent_is_at_this_stratum) :-
    macromolecular_stratum_receptor_occurrent(O),
    macromolecular_stratum_stratum(S),
    assertion(get_dict(stratum, O, SId)),
    assertion(get_dict(id, S, SId)).

% The six structure records are all schema-valid.
test(records_valid) :-
    macromolecular_stratum_records(Records),
    length(Records, 6),
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(macromolecular_stratum).
