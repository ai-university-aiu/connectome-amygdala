/*  connectome-amygdala — the runner (the Wave 8 valence and salience region).

    Presents stimuli and runs the appraisal/conditioning loop, printing the narrated,
    glass-box trace. First an APPRAISAL demonstration: a spread of stimuli at baseline
    and under stress, showing the four valences, the abstention on an unknown stimulus,
    and the cortisol modulation (appetitive suppressed under stress; threat amplified).
    Then CONDITIONING episodes run as a PrologAI cyclic_actor (a background thread):
    appraise the cue, condition (or extinguish) the association, re-appraise — settling
    toward a stable learned valence, coordinated through the Lattice (stigmergy plus
    notification, zero actor-to-actor references, no busy-poll). Each episode CONVERGES
    (the association settles) or BOUNDED-STOPS (reaches its trial bound under a partial
    schedule, a legal "not fully conditioned"), and — never — hangs.

    THE SAFETY PROPERTY, NO UNDEFINED VALENCE, IS CHECKED TWICE: once by the once-mode
    membership contract that region_stratum_commit_appraisal/2 DECLARES (every committed
    appraisal names a valence legal in its regime, or the explicit no_appraisal), and
    once again here by an adversarial attempt to commit an INVENTED valence and a
    CONTEXTUALLY-illegal one (appetitive under stress), which the contract refuses. The
    run exits 0 ONLY if every episode converged or bounded-stopped (never hung), every
    committed appraisal was legal, and the out-of-set appraisals were refused.

    Usage:  swipl ... bin/run_amygdala.pl
*/

% Import PrologAI's actors pack for the cyclic_actor background thread.
:- use_module(library(cyclic_actor)).
% Import the region's Lattice substrate: open/reset/cue/narrate/trace.
:- use_module(library(neural_lattice)).
% Import the region stratum: appraise/condition/modulate, the committed appraisal, and the conditioning loop.
:- use_module(library(region_stratum)).
% Import list utilities for the episode loop.
:- use_module(library(lists)).

% -- run_amygdala/0: run the appraisal demo and the conditioning episodes, prove no undefined valence, halt.
run_amygdala :-
    % Open (or reuse) the region's single coordination nexus.
    neural_lattice_open(Nexus),
    % Wipe any facts and trace from a prior run for a clean start.
    neural_lattice_reset(Nexus),
    % Print the run banner.
    run_amygdala_banner,
    % Show the appraisal sub-module directly: the four valences, the abstention, and the cortisol modulation.
    run_amygdala_appraisal_demo(AppraisalOk),
    % Spawn the conditioning actor; it blocks on its own trial cue (no busy-poll).
    cyclic_actor(amygdala_conditioning, region_stratum:region_stratum_condition_tick(Nexus), 0),
    % The fixed episodes: acquisition (converges to threat), extinction (converges to neutral), partial (bounded-stops).
    run_amygdala_episodes(Episodes),
    % Run every episode through the conditioning loop, collecting result(Label, Outcome, Ok).
    run_amygdala_loop(Nexus, Episodes, Results),
    % Stop the conditioning actor now that the runs are complete.
    ignore(catch(cyclic_actor_stop(amygdala_conditioning), _, true)),
    % The ADVERSARIAL check: force an undefined and a contextually-illegal valence and confirm the contract refuses them.
    run_amygdala_adversarial(AdvOk),
    % Print the verdict and halt with success only if no undefined valence occurred and nothing hung.
    ( run_amygdala_verdict(Results, AppraisalOk, AdvOk) -> halt(0) ; halt(1) ).

% -- run_amygdala_banner/0: print the run header.
run_amygdala_banner :-
    % Print the region name.
    format("~n== connectome-amygdala :: the valence and salience region (Wave 8) ==~n", []),
    % Print the circuit and coordination discipline.
    format("Circuit: appraise (valence + salience) -> condition (fear learning) -> re-appraise; modulated by cortisol; via the Lattice; no busy-poll~n", []),
    % Print the sacred guarantee.
    format("GUARANTEE: every committed appraisal names a valence legal in its cortisol regime, or an explicit no-appraisal (once-mode N8/N11/N14 contract; no undefined valence).~n", []).

% -- run_amygdala_appraisal_demo(-Ok): appraise a spread of stimuli, committing each through the contract.
run_amygdala_appraisal_demo(Ok) :-
    % Announce the appraisal demonstration.
    format("~n-- appraisal: the four valences, the abstention, and the cortisol modulation --~n", []),
    % A spread of (stimulus, cortisol, learned-association) probes covering every valence and the abstention.
    Probes = [
        probe(pain,  0.0, 0.0, "aversive at rest -> threat"),
        probe(food,  0.0, 0.0, "appetitive at rest -> appetitive"),
        probe(food,  0.8, 0.0, "appetitive under stress -> reward suppressed (not appetitive)"),
        probe(tone,  0.0, 0.0, "neutral cue, no learning -> neutral"),
        probe(tone,  0.0, 0.3, "part-conditioned cue at rest -> safe (wary)"),
        probe(tone,  0.8, 0.3, "part-conditioned cue under stress -> threat (cortisol amplifies)"),
        probe(unheard_of_thing, 0.0, 0.0, "unknown stimulus -> no-appraisal (abstain)")
    ],
    % Appraise-and-commit each probe, collecting whether the commit was legal.
    foldl(run_amygdala_probe, Probes, ok, Ok0),
    % Report the appraisal-demo outcome.
    ( Ok0 == ok
    ->  format("   APPRAISAL: every committed appraisal was legal in its regime (or an explicit no-appraisal).~n", []), Ok = true
    ;   format("   APPRAISAL: an appraisal escaped the valence set -- FAIL~n", []), Ok = false ).

% -- run_amygdala_probe(+Probe, +Acc, -Acc1): appraise-and-commit one probe and print the committed appraisal.
run_amygdala_probe(probe(Stimulus, Cortisol, Assoc, Note), Acc, Acc1) :-
    % Appraise-and-commit through the once-mode contract (any undefined valence would throw).
    ( catch(region_stratum_appraise_committed(Stimulus, Cortisol, Assoc, Committed),
            error(membership_contract_goal_violation(_, Bad, _), _),
            ( Committed = escaped(Bad), fail ))
    ->  % Print the committed appraisal alongside the explanatory note.
        format("   ~w (cortisol ~w, assoc ~w) -> ~w~n", [Stimulus, Cortisol, Assoc, Committed]),
        format("        ~w~n", [Note]),
        Acc1 = Acc
    ;   % A commit that threw means the appraise sub-module produced an illegal appraisal — a real fault.
        format("   ~w (cortisol ~w, assoc ~w) -> ESCAPED/illegal~n", [Stimulus, Cortisol, Assoc]),
        Acc1 = fail ).

% -- run_amygdala_episodes(-Episodes): the fixed conditioning episodes (Label, Stimulus, Cortisol, Schedule, StartAssoc, expected outcome kind).
run_amygdala_episodes([
    % Acquisition: a neutral tone paired with the aversive outcome acquires a threat association — converges to threat.
    episode(acquire,   tone, 0.0, paired,   0.0, converged),
    % Extinction: a conditioned tone presented unpaired loses its association — converges back to neutral.
    episode(extinguish, tone, 0.0, unpaired, 0.9, converged),
    % Partial reinforcement: an alternating schedule never settles — a bounded-stop, not a hang.
    episode(partial,   tone, 0.0, partial,  0.0, bounded_stop)
]).

% -- run_amygdala_loop(+Nexus, +Episodes, -Results): run each episode, collect result(Label, Outcome, Ok).
run_amygdala_loop(_Nexus, [], []).
run_amygdala_loop(Nexus, [episode(Label, Stimulus, Cortisol, Schedule, Start, Expect)|T], [result(Label, Outcome, Ok)|RT]) :-
    % Announce the episode.
    format("~n-- episode ~w: cue=~w cortisol=~w schedule=~w start-association=~w (expect ~w) --~n", [Label, Stimulus, Cortisol, Schedule, Start, Expect]),
    % Seed the conditioning loop with the cue, cortisol, starting association, schedule, and the counters.
    Seed = _{ stimulus:Stimulus, cortisol:Cortisol, assoc:Start, schedule:Schedule, iter:0, last_change:1.0, token:0 },
    % Run the reentrant conditioning loop; a bounded await means a hang FAILS rather than blocks forever.
    ( region_stratum_run_conditioning(Nexus, Seed, Result)
    % The loop returned a converged or bounded-stop outcome.
    ->  Outcome = Result,
        run_amygdala_outcome_ok(Outcome, Ok),
        format("   OUTCOME: ~w    clean(converged-or-bounded-stop)=~w~n", [Outcome, Ok])
    % The loop did not return within its bound — a HANG, which fails the gate.
    ;   Outcome = hung, Ok = false,
        format("   OUTCOME: HUNG (conditioning loop did not settle within its bound) -- FAIL~n", []) ),
    % Continue with the next episode.
    run_amygdala_loop(Nexus, T, RT).

% -- run_amygdala_outcome_ok(+Outcome, -Ok): a converged or bounded-stop outcome is clean; a hang is not.
run_amygdala_outcome_ok(converged(_, _, _), true) :- !.
run_amygdala_outcome_ok(bounded_stop(_, _, _), true) :- !.
run_amygdala_outcome_ok(_, false).

% -- run_amygdala_adversarial(-Ok): force an undefined and a contextually-illegal valence; confirm the once-mode contract refuses both.
run_amygdala_adversarial(Ok) :-
    % Announce the adversarial check.
    format("~n-- adversarial: force an undefined valence and a contextually-illegal one past the commit --~n", []),
    % Attempt 1: an INVENTED valence tag (euphoria) — the contract MUST throw (refuse).
    ( catch(region_stratum_commit_appraisal(appraisal(euphoria, 0.5, baseline), Bad1),
            error(membership_contract_goal_violation(_, _, _), _), fail)
    ->  format("   ESCAPED: commit returned ~w for an invented valence -- FAIL~n", [Bad1]), Ok1 = false
    ;   format("   REFUSED: the once-mode contract refused the invented valence 'euphoria' (no undefined valence).~n", []), Ok1 = true ),
    % Attempt 2: a CONTEXTUALLY-illegal appraisal (appetitive under stress) — the contract MUST throw (refuse).
    ( catch(region_stratum_commit_appraisal(appraisal(appetitive, 0.5, stress), Bad2),
            error(membership_contract_goal_violation(_, _, _), _), fail)
    ->  format("   ESCAPED: commit returned ~w for appetitive-under-stress -- FAIL~n", [Bad2]), Ok2 = false
    ;   format("   REFUSED: the once-mode contract refused 'appetitive under stress' (the legal set narrows with cortisol).~n", []), Ok2 = true ),
    % Both refusals must hold.
    ( Ok1 == true, Ok2 == true -> Ok = true ; Ok = false ).

% -- run_amygdala_verdict(+Results, +AppraisalOk, +AdvOk): print the verdict; succeed iff the region behaved safely.
run_amygdala_verdict(Results, AppraisalOk, AdvOk) :-
    % Count the episodes and the ones with a clean (converged or bounded-stop) outcome.
    length(Results, Total),
    include(run_amygdala_result_ok, Results, Clean),
    length(Clean, CleanCount),
    % Read the total number of conditioning hops recorded.
    neural_lattice_trace(Hops),
    length(Hops, HopCount),
    % Print the verdict block.
    format("~n-- no-undefined-valence verdict --~n", []),
    format("  episodes                 : ~w~n", [Total]),
    format("  clean (converged/bounded): ~w of ~w~n", [CleanCount, Total]),
    format("  appraisal demo legal     : ~w~n", [AppraisalOk]),
    format("  out-of-set appraisals    : ~w (invented and contextually-illegal both refused)~n", [AdvOk]),
    format("  conditioning hops        : ~w (all via the Lattice; the loop re-posted its own cue)~n", [HopCount]),
    format("  actor-to-actor refs      : 0 (the loop reenters through the Lattice; verified by bin/check_no_coupling.sh)~n", []),
    format("  busy-poll                : none (lattice_await blocks on a queue; woken by lattice_notify)~n", []),
    % The verdict holds only if every episode was clean, every appraisal was legal, and the illegal appraisals were refused.
    ( CleanCount =:= Total, AppraisalOk == true, AdvOk == true
    ->  format("  VERDICT                  : pass (no appraisal ever left the valence set; the conditioning loop converged or bounded-stopped)~n~n", []),
        true
    ;   format("  VERDICT                  : FAIL (an undefined valence, an illegal appraisal, or a hang occurred)~n~n", []),
        fail ).

% -- run_amygdala_result_ok(+Result): true when an episode's outcome was clean.
run_amygdala_result_ok(result(_, _, true)).

% Run the region as soon as the file is loaded (the shell script sets the library path).
:- initialization(run_amygdala).
