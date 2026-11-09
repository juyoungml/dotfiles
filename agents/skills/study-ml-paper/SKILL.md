---
name: study-ml-paper
description: Ingest and study machine-learning or deep-learning papers through source-grounded explanation, prerequisite diagnosis, active recall, MCQs, derivations, tensor-shape exercises, experiment critique, and spaced review. Use when the user provides an arXiv URL, paper source, or paper PDF and wants to understand, learn, review, quiz themselves on, compare, or prepare to reproduce the paper across one or more sessions.
---

# Study ML Paper

Turn a paper into a persistent, evidence-backed course. Read the primary source first, separate the authors' claims from your own reasoning, and make the learner retrieve and apply ideas instead of passively reading a summary.

## Choose the session mode

Infer the lightest mode that satisfies the request; ask only when the choice materially changes the work.

- **Map**: produce a fast problem-method-evidence-limitations map.
- **Learn**: diagnose prerequisites and teach one concept at a time through questions.
- **Math**: reconstruct notation, objectives, tensor shapes, and derivations.
- **Critique**: inspect claims, baselines, ablations, metrics, and threats to validity.
- **Review**: quiz prior material, prioritizing weak or overdue concepts.
- **Reproduce**: translate claims into a minimal experiment plan. Do not start costly training or mutate an external repository without explicit authorization.

Default a first encounter to **Map**, followed by a short diagnostic and **Learn**.

## Maintain the study workspace

Treat the current directory as the study workspace. Read existing study artifacts before teaching, and update rather than replace them. Initialize only the files needed for the current session using the schemas in [workspace-schema.md](references/workspace-schema.md).

Keep:

- `PAPER_STUDY.md` for the learner's mission, background, and teaching preferences.
- `papers/<paper-id>/PAPER.md` for a durable, source-grounded paper map.
- `learning-records/` for demonstrated understanding and misconceptions.
- `sessions/` for question attempts, feedback, and scheduled review.

Never treat a generated note as primary evidence. Re-open the paper when checking a claim.

## Acquire the primary source

For an arXiv URL or identifier, run:

```bash
uv run python <skill-directory>/scripts/fetch_arxiv_source.py <url-or-id>
```

Use the returned source directory and candidate entrypoints. The script validates identifiers, limits downloads, rejects unsafe archive members, and avoids overwriting an existing cache unless `--force` is explicitly passed.

Prefer original TeX because it preserves equations, labels, captions, appendices, and bibliography structure. Locate the root file, then follow relevant `\input`, `\include`, bibliography, table, and figure references. Read appendices when they contain proofs, implementation details, prompts, hyperparameters, or additional results relevant to the learner's question.

If TeX is unavailable, use the supplied PDF or official HTML. Record the fallback in `PAPER.md`. For non-arXiv papers, prefer the publisher or author-hosted primary copy. Do not bypass paywalls or access controls.

Follow the detailed traversal and analysis rules in [paper-reading.md](references/paper-reading.md).

## Build the evidence map

Before explaining deeply, identify:

1. The problem and why existing approaches are insufficient.
2. The paper's claimed contributions.
3. The minimal mechanism that makes the method different.
4. The objective, data flow, and important tensor shapes.
5. The evidence for each central claim.
6. Assumptions, limitations, and missing tests.
7. Prerequisites the learner needs for the next useful step.

Tag substantive statements in notes and lessons:

- **Stated** — explicitly claimed or reported by the paper.
- **Derived** — follows from an equation, algorithm, or reported number; show the derivation.
- **Inferred** — your interpretation or hypothesis; state uncertainty.
- **External** — supported by another source; cite it separately.

Anchor evidence to section, equation, algorithm, figure, or table numbers. Add source filenames when numbering is absent or ambiguous. Never present an abstract claim as experimentally established without checking the experiment.

## Teach through retrieval

Start with two to four diagnostic questions spanning prerequisites and the paper's central idea. Do not front-load a long lecture.

Then loop:

1. State one small learning objective.
2. Provide only the minimum explanation needed to attempt it.
3. Ask exactly one question and wait for the learner's answer.
4. Evaluate the reasoning, not just the final choice.
5. Give immediate, specific feedback.
6. Ask for a correction or transfer to a new case when useful.
7. Record demonstrated strengths, weak areas, and misconceptions.

Mix question types:

- Conceptual prediction: what changes if an assumption is removed?
- MCQ: use plausible distractors and keep choices similar in length and form.
- Shape tracing: annotate a forward pass with dimensions.
- Equation reconstruction: recover an objective or intermediate step from meaning.
- Result reading: interpret a table, figure, confidence interval, or ablation.
- Critique: identify an unsupported claim or confound.
- Design transfer: adapt the method to a new dataset or constraint.

Do not reveal an answer, hint through formatting, or eliminate choices before the learner attempts the question. If the learner is stuck, offer graduated hints rather than the solution. Require a brief justification for MCQs when understanding matters.

## Calibrate difficulty and review

Keep questions just beyond demonstrated mastery. Distinguish fluent recognition from durable recall.

- Revisit a missed concept later in the same session with a different surface form.
- Schedule successful but effortful concepts farther out.
- Interleave related ideas after each is understood separately.
- Prefer transfer and reconstruction over repeated recognition.

Use 1, 3, 7, and 14 days as default review intervals, adjusting from performance and user preference. When resuming, begin with overdue questions before new material unless the user requests otherwise.

## Give feedback precisely

Classify an answer as **correct**, **partially correct**, **incorrect**, or **uncertain because the paper is underspecified**. Include:

- what reasoning was sound;
- the first point where it diverged;
- the source anchor that resolves the issue;
- one concise correction;
- the next retrieval question.

Do not convert ambiguity in the paper into false certainty. If a result depends on omitted implementation details, say so and record the gap.

## Finish a session

Update the durable artifacts, then report:

- what the learner can now explain or do;
- remaining misconceptions or prerequisites;
- the next scheduled review items;
- the most valuable next mode or paper section.

Keep generated lessons short. The paper is the source of truth; the workspace is a map of the learner's evolving understanding.

## Attribution

This workflow adapts ideas from Matt Pocock's `teach` skill and Andrej Karpathy's `read-arxiv-paper` skill. Preserve the notices in `LICENSE` when redistributing substantial portions.
