% Test suite for the synaptic_stratum pack — the associative fear-learning write.
% These tests confirm that pairing strengthens the association (monotone toward 1.0) and unpairing weakens it
% (monotone toward 0.0), and that the five structure records are schema-valid.
% Load the synaptic stratum module under test.
:- use_module(library(synaptic_stratum)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the synaptic_stratum pack.
:- begin_tests(synaptic_stratum).

% PAIRING strengthens the association toward 1.0 (a half-gap Rescorla-Wagner step).
test(pairing_strengthens_toward_one) :-
    synaptic_stratum_potentiate(0.0, true, A1), assertion(abs(A1 - 0.5) < 1.0e-9),
    synaptic_stratum_potentiate(A1, true, A2), assertion(abs(A2 - 0.75) < 1.0e-9),
    % The association grows but never exceeds the ceiling.
    assertion(A2 =< 1.0).

% UNPAIRING (extinction) weakens the association toward 0.0.
test(unpairing_weakens_toward_zero) :-
    synaptic_stratum_potentiate(0.8, false, A1), assertion(abs(A1 - 0.4) < 1.0e-9),
    synaptic_stratum_potentiate(A1, false, A2), assertion(abs(A2 - 0.2) < 1.0e-9),
    % The association shrinks but never falls below the floor.
    assertion(A2 >= 0.0).

% Acquisition is MONOTONE: successive paired trials never decrease the association.
test(acquisition_is_monotone) :-
    synaptic_stratum_potentiate(0.0, true, A1),
    synaptic_stratum_potentiate(A1, true, A2),
    synaptic_stratum_potentiate(A2, true, A3),
    assertion(A1 >= 0.0), assertion(A2 >= A1), assertion(A3 >= A2).

% The synaptic stratum record carries ordinal 7 (above the neurons, below the region).
test(stratum_ordinal_is_seven) :-
    synaptic_stratum_stratum(S),
    assertion(get_dict(ordinal, S, 7)).

% The five structure records are all schema-valid.
test(records_valid) :-
    synaptic_stratum_records(Records),
    length(Records, 5),
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(synaptic_stratum).
