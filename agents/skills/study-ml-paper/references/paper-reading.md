# Source-grounded ML paper reading

## Source traversal

1. Identify the root TeX file by `\documentclass`, then inspect its `\input` and `\include` graph.
2. Read the abstract, introduction, method, experiments, limitations, and conclusion.
3. Read captions with their figures and tables; captions often contain evaluation conditions omitted from prose.
4. Inspect appendices for proofs, architecture details, hyperparameters, prompts, dataset filtering, and extra ablations.
5. Inspect bibliography entries only to resolve what prior work the authors contrast with; do not infer the cited paper's result from a citation sentence alone.
6. Record missing or conflicting source components instead of guessing.

Ignore generated LaTeX build files and style packages unless a custom macro affects mathematical meaning. Resolve important macros before explaining equations.

## Paper map rubric

### Problem

- What decision, prediction, generation, or estimation task is addressed?
- What setting, dataset, or distribution is assumed?
- Which limitation of prior work is demonstrated rather than merely asserted?

### Method

- What is genuinely new: objective, architecture, data, optimization, inference, or evaluation?
- What are the inputs, outputs, learned parameters, and non-learned state?
- Trace one example through the method with tensor shapes.
- Translate every important loss term into plain language and expected gradient pressure.

### Evidence

- Map each central claim to the exact experiment that tests it.
- Check baseline strength, tuning budget, data equivalence, compute equivalence, and metric definitions.
- Separate main results from ablations and qualitative examples.
- Note variance, uncertainty, number of runs, and statistical testing when reported.
- Compute simple deltas or ratios when helpful, labeling them **Derived**.

### Limitations

- Identify assumptions about data availability, compute, labels, deployment, or evaluation.
- Look for missing baselines, missing ablations, leakage risks, cherry-picked examples, and benchmark saturation.
- Distinguish author-acknowledged limitations from your own **Inferred** concerns.

### Reproduction bridge

- Name the smallest claim that can be tested.
- Identify required code, checkpoint, data, hardware, metric, and random seeds.
- Record ambiguities before proposing fixes.
- Prefer a documented inference or evaluation run before training.
- Never claim reproduction from code execution alone; compare the protocol and result to the paper.

## Evidence language

Use calibrated verbs:

- “The authors claim…” for prose claims.
- “Table 2 reports…” for measurements.
- “Equation 4 implies…” for a derivation you can show.
- “A plausible interpretation is…” for inference.
- “The paper does not specify…” for missing detail.

Avoid “proves,” “solves,” “understands,” or “state of the art” unless the paper's evidence and comparison scope justify the term.

## Teaching checkpoints

A learner understands the paper more deeply when they can:

1. State the problem without using the method's branded terminology.
2. Reconstruct the central mechanism from constraints.
3. Trace dimensions and explain the objective's gradient incentives.
4. Predict an ablation before reading its result.
5. Match each claim to evidence and identify what remains untested.
6. Propose a minimal reproduction or falsification test.

Use these as outcomes, not as a rigid checklist for every session.
