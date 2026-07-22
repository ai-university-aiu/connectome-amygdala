/*  connectome-amygdala — cellular_stratum (ordinal 6 -> pack layer 2): THE PROJECTION NEURONS.

    THE CELLS THAT SENSE THE STIMULUS AND CARRY THE APPRAISAL, at the cellular
    stratum (Causalontology ordinal 6). This is the stratum the Wave 6 memory region
    DELIBERATELY LEFT EMPTY — the amygdala occupies it, as the cerebellum did, a
    useful contrast: appraisal is genuinely a cell-level story (the lateral-amygdala
    input neurons and the central-nucleus output neurons). Under the Wave 3 verdict's
    rule (one pack per stratum on the OUTSIDE, one construct per module on the INSIDE)
    this pack IS the cellular stratum. Its constructs are the SENSORY ENCODING —
    the innate, unconditioned read-out of a stimulus into a threat/reward feature —
    and the PROJECTION firing that carries a bounded salience downstream. That is
    DYNAMICS, kept native (deterministic read-outs, never a causal_relation_object) —
    two thin sub-modules, cellular_stratum_encode/2 and cellular_stratum_project/2.

    Its STRUCTURE is grounded in Causalontology 3.0.0: the cellular stratum record,
    the lateral-amygdala input neuron, the basolateral projection neuron, and the
    central-nucleus output neuron continuants, the sensory-encoding occurrent, and
    the encoding disposition of the input neuron.

    THE PACK IS PURE — no runtime tick, no Lattice coordination. Encoding is a
    downward mechanism the region's appraisal invokes. It imports the minting
    vocabulary (0) and nothing upward; its layer(2) matches ordinal 6, above the
    macromolecular cascade (ordinal 4) and below the synapse (ordinal 7).
*/

% Declare the module: the native sensory encoding and projection, the encoding occurrent, and the structure accessors.
:- module(cellular_stratum, [
    % cellular_stratum_encode/2: the native read-out — the innate threat/reward feature of a known stimulus.
    cellular_stratum_encode/2,
    % cellular_stratum_project/2: the native projection firing — a drive clamped to a bounded salience rate.
    cellular_stratum_project/2,
    % cellular_stratum_encoding_occurrent/1: the sensory-encoding occurrent (the region's stimulus-input endpoint).
    cellular_stratum_encoding_occurrent/1,
    % cellular_stratum_stratum/1: the cellular stratum record.
    cellular_stratum_stratum/1,
    % cellular_stratum_records/1: the labelled list of this stratum's six structure records.
    cellular_stratum_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).

% ---------------------------------------------------------------------------
% The native dynamics (kept native per the grounding rule — read-outs, not CROs).
% ---------------------------------------------------------------------------

% -- cellular_stratum_encode(+Stimulus, -Feature): the innate threat/reward feature of a known stimulus.
% The sensory neurons carry a stimulus's UNCONDITIONED value: feature(Threat, Reward), each in [0.0, 1.0]. An
% aversive stimulus (pain) has high threat; an appetitive one (food) high reward; a neutral cue (tone) has neither.
% An UNKNOWN stimulus is not encoded (this predicate fails), so the region abstains — it never invents an appraisal.
cellular_stratum_encode(pain,  feature(0.9,  0.0)).
cellular_stratum_encode(shock, feature(0.95, 0.0)).
cellular_stratum_encode(snake, feature(0.8,  0.0)).
cellular_stratum_encode(food,  feature(0.0,  0.9)).
cellular_stratum_encode(tone,  feature(0.0,  0.0)).
cellular_stratum_encode(light, feature(0.0,  0.0)).

% -- cellular_stratum_project(+Drive, -Rate): the projection-neuron firing rate for an appraisal drive.
% The central-nucleus output neuron converts an appraisal drive into a bounded firing rate — the salience the
% region commits. A negative drive fires at zero; a drive above one saturates at one; between, it is the drive.
cellular_stratum_project(Drive, Rate) :-
    % The drive must be a number.
    number(Drive),
    % Clamp the drive into the [0.0, 1.0] firing range (the salience the appraisal carries).
    ( Drive < 0.0 -> Rate = 0.0
    ; Drive > 1.0 -> Rate = 1.0
    ; Rate = Drive ).

% ---------------------------------------------------------------------------
% The structure records (co-located with the pack, the verdict's stratum-primary stance).
% ---------------------------------------------------------------------------

% -- cellular_stratum_stratum(-Out): the cellular stratum record (ordinal 6).
cellular_stratum_stratum(Out) :-
    % Mint the cellular stratum with the anatomy's fields (the shared neuroendocrine ladder).
    cm_stratum("cellular", "neuroendocrine", 6, "cell", ["cellular_neuroscience"], Out).

% -- cellular_stratum_input_continuant(-Out): the lateral-amygdala input neuron bearer (the sensory encoder).
cellular_stratum_input_continuant(Out) :-
    % Mint the lateral-amygdala input neuron continuant (receives sensory input, holds the conditioned association).
    cm_cnt("lateral_amygdala_input_neuron", "object", Out).

% -- cellular_stratum_projection_continuant(-Out): the basolateral projection neuron bearer (carries the appraisal).
cellular_stratum_projection_continuant(Out) :-
    % Mint the basolateral projection neuron continuant (relays the appraisal within the amygdala).
    cm_cnt("basolateral_projection_neuron", "object", Out).

% -- cellular_stratum_output_continuant(-Out): the central-nucleus output neuron bearer (the salience firing).
cellular_stratum_output_continuant(Out) :-
    % Mint the central-nucleus output neuron continuant (the amygdala's output — drives the salience response).
    cm_cnt("central_nucleus_output_neuron", "object", Out).

% -- cellular_stratum_encoding_occurrent(-Out): the sensory-encoding event, stamped at the cellular stratum.
cellular_stratum_encoding_occurrent(Out) :-
    % Read this pack's own stratum id.
    cellular_stratum_stratum(SCell),
    % Mint the sensory-encoding occurrent (the read-out of a stimulus into its innate feature).
    cm_occ("sensory_encoding", "process", SCell.id, Out).

% -- cellular_stratum_encoding_realizable(-Out): the encoding disposition of the input neuron.
cellular_stratum_encoding_realizable(Out) :-
    % Read the input neuron bearer id.
    cellular_stratum_input_continuant(CInput),
    % Mint the encoding disposition it bears.
    cm_rlz(CInput.id, "disposition", "sensory_encoding", Out).

% -- cellular_stratum_records(-Records): this stratum's six structure records.
cellular_stratum_records(Records) :-
    % Mint the stratum, the three neuron bearers, the encoding occurrent, and the encoding disposition.
    cellular_stratum_stratum(SCell),
    cellular_stratum_input_continuant(CInput),
    cellular_stratum_projection_continuant(CProject),
    cellular_stratum_output_continuant(COutput),
    cellular_stratum_encoding_occurrent(OEncode),
    cellular_stratum_encoding_realizable(REncode),
    % Assemble the labelled record list.
    Records = [
        record(stratum_cellular,               stratum,     SCell),
        record(continuant_lateral_input_neuron, continuant,  CInput),
        record(continuant_basolateral_projection_neuron, continuant, CProject),
        record(continuant_central_output_neuron, continuant, COutput),
        record(occurrent_sensory_encoding,     occurrent,   OEncode),
        record(realizable_sensory_encoding,    realizable,  REncode)
    ].
