# Study workspace schemas

Create only the artifacts needed for the current request. Preserve user-written content and extend existing sections rather than recreating files.

## `PAPER_STUDY.md`

```markdown
# Paper study

## Mission
Why the learner is reading papers and what capability they want to build.

## Background
Relevant mathematics, ML concepts, implementation experience, and known gaps.

## Preferences
Session length, question formats, desired mathematical depth, and feedback style.

## Current focus
Paper, session mode, and immediate learning objective.
```

Confirm before materially changing the mission.

## `papers/<paper-id>/PAPER.md`

```markdown
# <title>

- Paper: <canonical URL or citation>
- Version: <arXiv version or publication version>
- Source read: <TeX, official HTML, or PDF>
- Source location: <cache or local path>
- Studied: <date>

## One-sentence thesis

## Problem and prior limitation

## Claimed contributions

## Mechanism

## Notation and data flow

## Claim-evidence table
| Claim | Evidence | Anchor | Status |
| --- | --- | --- | --- |

Use Stated, Derived, Inferred, or External for Status.

## Results and ablations

## Assumptions and limitations

## Reproduction hooks

## Open questions
```

Use the stable arXiv identifier without the version suffix as `<paper-id>` when practical. Do not silently merge different published versions; record which version was read.

## `learning-records/<date>-<concept>.md`

```markdown
# <concept>

- Paper: <paper id>
- Evidence date: <date>
- Status: new | developing | durable | revise

## Demonstrated understanding

## Misconceptions or gaps

## Evidence
Reference question attempts or explanations produced by the learner.

## Next retrieval
State the question type and due date without embedding the answer.
```

Record demonstrated behavior, not personality judgments or unsupported ability labels.

## `sessions/<timestamp>-<paper-id>.md`

```markdown
# Study session

- Paper: <paper id>
- Mode: map | learn | math | critique | review | reproduce
- Started: <timestamp>

## Objective

## Attempts

### Q1 — <concept>
- Prompt: <question>
- Learner response: <verbatim or faithful concise record>
- Assessment: correct | partially correct | incorrect | underspecified
- Feedback: <brief feedback>
- Source anchor: <section/equation/figure/table>
- Review due: <date or none>

## Session outcome

## Next step
```

Avoid storing private information not needed for learning. Ask before recording sensitive motivations or context.
