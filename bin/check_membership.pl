/*  connectome-amygdala — the dedicated NO-UNDEFINED-VALENCE check.

    The valence and salience region's first and non-negotiable gate. It adversarially
    TRIES to commit an appraisal whose valence is OUTSIDE the legal set — an invented
    affective tag, an out-of-range salience, and a CONTEXTUALLY-illegal appraisal
    (appetitive under stress, which the legal set excludes) — across a battery of
    candidate appraisals, and confirms it cannot. It also runs the real
    appraise-then-commit pipeline over a wide sweep of stimuli, cortisol levels, and
    learned associations and confirms every committed appraisal the region would
    actually produce is legal.

    Every commit is classified as one of: member(A) (safe — a legal appraisal),
    no_appraisal (safe — the abstention), refused (safe — the once-mode membership
    contract threw), or ESCAPED(A) (an out-of-set appraisal committed WITHOUT a throw —
    the one dangerous outcome the guarantee forbids). Because
    region_stratum_commit_appraisal/2 DECLARES PrologAI's membership contract in the
    accessor form (a context-dependent, uncountable legal-appraisal test goal, never
    materialised) and in once mode, the refusal is the contract's, not a hand-rolled
    guard's. Exit 0 iff NO attempt ever escaped.
*/

% Import the region: the guarded commit (declares the once-mode contract), the legal-appraisal test, and appraise.
:- use_module(library(region_stratum)).
% Import list utilities for the adversarial battery.
:- use_module(library(lists)).

% -- try_commit(+Proposed, -Outcome): classify one guarded commit against the legal valence set.
try_commit(Proposed, Outcome) :-
    % Run the guarded commit, catching the membership-contract violation as the SAFE 'refused'.
    catch(
        ( region_stratum_commit_appraisal(Proposed, A),
          % A commit that succeeded is safe only if it is the abstention or a legal appraisal.
          ( A == no_appraisal
          ->  Outcome = no_appraisal
          ; region_stratum_legal_appraisal(A)
          ->  Outcome = member(A)
          % A succeeded commit of an out-of-set appraisal is the DANGER the guarantee forbids.
          ;   Outcome = escaped(A) ) ),
        % The contract throwing on an out-of-set appraisal is the SAFE outcome.
        error(membership_contract_goal_violation(_, _, _), _),
        Outcome = refused ).

% -- membership_battery(-Outcomes): every adversarial and normal commit to inspect.
membership_battery(Outcomes) :-
    % A sweep of candidate appraisals: legal ones, the abstention, invented tags, out-of-range salience, and contextually-illegal ones.
    Candidates = [
        % Legal appraisals across both regimes.
        appraisal(threat, 0.9, baseline), appraisal(safe, 0.3, baseline),
        appraisal(appetitive, 0.8, baseline), appraisal(neutral, 0.0, baseline),
        appraisal(threat, 0.7, stress), appraisal(safe, 0.4, stress), appraisal(neutral, 0.1, stress),
        % The abstention.
        no_appraisal,
        % INVENTED valence tags (undefined affective tags) — must be refused.
        appraisal(euphoria, 0.5, baseline), appraisal(terror_supreme, 0.5, baseline),
        appraisal(xyzzy, 0.5, stress), appraisal(rage, 0.5, baseline),
        % OUT-OF-RANGE salience — must be refused.
        appraisal(threat, 5.0, baseline), appraisal(threat, -0.1, baseline),
        % CONTEXTUALLY-illegal: appetitive is not a legal valence under stress — must be refused.
        appraisal(appetitive, 0.5, stress), appraisal(appetitive, 0.9, stress),
        % Malformed regime — must be refused.
        appraisal(threat, 0.5, euphoric_regime)
    ],
    % DIRECT battery: try to commit each candidate.
    findall(O, (member(C, Candidates), try_commit(C, O)), DirectOutcomes),
    % PIPELINE battery: over a wide sweep of stimuli, cortisol levels, and associations, run the real appraise then commit, and confirm no escape.
    findall(O,
            ( member(Stim, [pain, shock, snake, food, tone, light, unheard_of_thing]),
              member(Cortisol, [0.0, 0.3, 0.5, 0.8, 1.0]),
              member(Assoc, [0.0, 0.25, 0.5, 0.75, 1.0]),
              region_stratum_appraise(Stim, Cortisol, Assoc, Proposed),
              try_commit(Proposed, O) ),
            PipelineOutcomes),
    % Assemble every outcome for inspection.
    append([DirectOutcomes, PipelineOutcomes], Outcomes).

% -- check_membership_main/0: run the battery, report, and halt with the gate verdict.
check_membership_main :-
    % Print the banner.
    format("~n== connectome-amygdala :: no-undefined-valence check ==~n~n", []),
    % Run the whole adversarial battery.
    membership_battery(Outcomes),
    % Count the outcomes and the dangerous escapes.
    length(Outcomes, Total),
    include([escaped(_)]>>true, Outcomes, Escapes),
    length(Escapes, EscapeCount),
    % Count how many out-of-set appraisals were safely refused (the contract threw) for reassurance.
    include(==(refused), Outcomes, Refused),
    length(Refused, RefusedCount),
    % Report the tallies.
    format("  attempts inspected          : ~w~n", [Total]),
    format("  out-of-set refused (safe)   : ~w~n", [RefusedCount]),
    format("  ESCAPES (undefined valence) : ~w~n", [EscapeCount]),
    % The gate holds iff not a single attempt committed an appraisal outside the legal set.
    ( EscapeCount =:= 0
    ->  format("~nNO-UNDEFINED-VALENCE: PASS -- across ~w attempts, no commit ever left the legal valence set.~n~n", [Total]),
        halt(0)
    ;   format("~nNO-UNDEFINED-VALENCE: FAIL -- ~w commit(s) escaped the legal set: ~w~n~n", [EscapeCount, Escapes]),
        halt(1) ).

% Run the no-undefined-valence check as soon as the file is loaded.
:- initialization(check_membership_main).
