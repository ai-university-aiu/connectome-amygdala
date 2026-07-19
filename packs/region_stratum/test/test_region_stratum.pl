% Test suite for the region_stratum pack — appraise/condition/modulate and the committed appraisal.
% These tests confirm the committed appraisal CANNOT carry an undefined valence (once-mode accessor contract),
% that cortisol modulates the appraisal and narrows the legal valence set, and that the pure conditioning step
% moves the association monotonically toward its asymptote.
% Load the region_stratum module under test (its load also DECLARES the once-mode membership contract on commit).
:- use_module(library(region_stratum)).
% Load the cellular stratum for the sensory encoding used by appraise.
:- use_module(library(cellular_stratum)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the region_stratum pack.
:- begin_tests(region_stratum).

% APPRAISE assigns an aversive stimulus the threat valence with high salience.
test(appraise_aversive_is_threat) :-
    region_stratum_appraise(pain, 0.0, 0.0, appraisal(V, S, R)),
    assertion(V == threat),
    assertion(S > 0.8),
    assertion(R == baseline).

% APPRAISE assigns an appetitive stimulus the appetitive valence at baseline.
test(appraise_appetitive_is_appetitive_at_baseline) :-
    region_stratum_appraise(food, 0.0, 0.0, appraisal(V, _, baseline)),
    assertion(V == appetitive).

% CORTISOL MODULATION: under stress, the appetitive appraisal is suppressed — food no longer reads appetitive.
test(cortisol_suppresses_appetitive) :-
    region_stratum_appraise(food, 0.8, 0.0, appraisal(V, _, stress)),
    assertion(V \== appetitive).

% CORTISOL MODULATION: cortisol amplifies threat — a partly-conditioned cue reads as threat under stress but not at baseline.
test(cortisol_amplifies_threat) :-
    region_stratum_appraise(tone, 0.0, 0.3, appraisal(Vb, _, baseline)),
    region_stratum_appraise(tone, 0.8, 0.3, appraisal(Vs, _, stress)),
    assertion(Vb \== threat),
    assertion(Vs == threat).

% ABSTENTION: an unknown stimulus yields the explicit no_appraisal — the region never invents a tag.
test(unknown_stimulus_abstains) :-
    region_stratum_appraise(unheard_of_thing, 0.0, 0.0, A),
    assertion(A == no_appraisal).

% THE LEGAL VALENCE SET IS CONTEXT-DEPENDENT: appetitive is legal at baseline but NOT under stress.
test(legal_valence_set_narrows_under_stress) :-
    assertion(region_stratum_legal_appraisal(appraisal(appetitive, 0.5, baseline))),
    assertion(\+ region_stratum_legal_appraisal(appraisal(appetitive, 0.5, stress))),
    % Threat is legal in both regimes.
    assertion(region_stratum_legal_appraisal(appraisal(threat, 0.5, baseline))),
    assertion(region_stratum_legal_appraisal(appraisal(threat, 0.5, stress))).

% NO UNDEFINED VALENCE: a legal appraisal commits; the abstention commits.
test(commit_member_and_abstention_pass) :-
    region_stratum_commit_appraisal(appraisal(threat, 0.9, baseline), C1),
    assertion(C1 == appraisal(threat, 0.9, baseline)),
    region_stratum_commit_appraisal(no_appraisal, C2),
    assertion(C2 == no_appraisal).

% NO UNDEFINED VALENCE: an INVENTED valence tag is REFUSED by the once-mode accessor contract.
test(commit_invented_valence_refused,
     [throws(error(membership_contract_goal_violation(_, appraisal(euphoria, 0.5, baseline), _), _))]) :-
    region_stratum_commit_appraisal(appraisal(euphoria, 0.5, baseline), _C).

% NO UNDEFINED VALENCE: an out-of-range salience is REFUSED.
test(commit_out_of_range_salience_refused,
     [throws(error(membership_contract_goal_violation(_, appraisal(threat, 5.0, baseline), _), _))]) :-
    region_stratum_commit_appraisal(appraisal(threat, 5.0, baseline), _C).

% NO UNDEFINED VALENCE: a CONTEXTUALLY-illegal appraisal (appetitive under stress) is REFUSED.
test(commit_appetitive_under_stress_refused,
     [throws(error(membership_contract_goal_violation(_, appraisal(appetitive, 0.5, stress), _), _))]) :-
    region_stratum_commit_appraisal(appraisal(appetitive, 0.5, stress), _C).

% ONCE MODE: the committed appraisal is deterministic — exactly one solution.
test(commit_is_deterministic) :-
    findall(C, region_stratum_commit_appraisal(appraisal(safe, 0.3, baseline), C), Cs),
    assertion(Cs == [appraisal(safe, 0.3, baseline)]).

% CONDITION strengthens a paired cue's association monotonically toward one.
test(condition_strengthens_monotonically) :-
    region_stratum_condition(0.0, true, A1),
    region_stratum_condition(A1, true, A2),
    assertion(A1 > 0.0),
    assertion(A2 > A1),
    assertion(A2 =< 1.0).

% THE LEARNED APPRAISAL FORMS: a repeatedly paired neutral cue eventually reads as threat.
test(conditioning_forms_a_threat_appraisal) :-
    condition_n(tone, 0.0, 4, FinalAssoc),
    region_stratum_appraise(tone, 0.0, FinalAssoc, appraisal(V, _, _)),
    assertion(V == threat).

% The eleven structure records are all schema-valid, including the computational appraisal conduit.
test(records_valid) :-
    region_stratum_records(Records),
    length(Records, 11),
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])),
    memberchk(record(conduit_appraisal, conduit, K), Records),
    get_dict(transform, K, _).

% Close the test block.
:- end_tests(region_stratum).

% -- condition_n(+Stimulus, +Assoc0, +N, -AssocN): apply N paired conditioning trials (a pure driver).
condition_n(_Stimulus, Assoc, 0, Assoc) :- !.
condition_n(Stimulus, Assoc0, N, AssocN) :-
    % One paired conditioning trial.
    N > 0,
    region_stratum_condition(Assoc0, true, Assoc1),
    N1 is N - 1,
    condition_n(Stimulus, Assoc1, N1, AssocN).
