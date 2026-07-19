% Test suite for the cellular_stratum pack — the amygdala projection neurons.
% These tests confirm the native sensory encoding (known stimuli, unknown ones fail so the region abstains),
% the bounded projection firing, and that the six structure records are schema-valid.
% Load the cellular stratum module under test.
:- use_module(library(cellular_stratum)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the cellular_stratum pack.
:- begin_tests(cellular_stratum).

% A known aversive stimulus encodes to high threat; an appetitive one to high reward; a neutral cue to neither.
test(encode_known_stimuli) :-
    cellular_stratum_encode(pain, feature(Tp, Rp)), assertion(Tp > 0.8), assertion(Rp =:= 0.0),
    cellular_stratum_encode(food, feature(Tf, Rf)), assertion(Tf =:= 0.0), assertion(Rf > 0.8),
    cellular_stratum_encode(tone, feature(Tt, Rt)), assertion(Tt =:= 0.0), assertion(Rt =:= 0.0).

% An UNKNOWN stimulus is not encoded (the predicate fails), so the region will abstain rather than invent an appraisal.
test(encode_unknown_fails) :-
    assertion(\+ cellular_stratum_encode(unheard_of_thing, _)).

% The projection firing clamps a drive into the [0.0, 1.0] salience range.
test(project_clamps_drive) :-
    cellular_stratum_project(-0.5, R0), assertion(R0 =:= 0.0),
    cellular_stratum_project(0.4, R1), assertion(abs(R1 - 0.4) < 1.0e-9),
    cellular_stratum_project(3.0, R2), assertion(R2 =:= 1.0).

% The cellular stratum record carries ordinal 6 (the stratum the memory region left empty; the amygdala occupies it).
test(stratum_ordinal_is_six) :-
    cellular_stratum_stratum(S),
    assertion(get_dict(ordinal, S, 6)).

% The six structure records are all schema-valid.
test(records_valid) :-
    cellular_stratum_records(Records),
    length(Records, 6),
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(cellular_stratum).
