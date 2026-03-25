---
title: "INSPECT-SR"
date: 2025-09-05
draft: false
summary: "A guide to using the INSPECT-SR tool for assessing the trustworthiness of randomised controlled trials included in systematic reviews."
tags: ["systematic-reviews", "trustworthiness", "RCTs", "INSPECT-SR"]
categories: ["means", "standard-deviations", "sample-sizes", "p-values", "effect-sizes"]
authors: ["jack-wilkinson", "ian-hussey"]
---

## INSPECT-SR: INveStigating ProblEmatic Clinical Trials in Systematic Reviews

INSPECT-SR ([Wilkinson et al., 2025](https://doi.org/10.1101/2025.09.03.25334905)) is Cochrane's Trustworthiness Assessment tool for randomised controlled trials (RCTs) in systematic reviews. It was designed for health RCTs but has utility in other fields too.

INSPECT-SR does not assess internal or external validity (which are covered by Risk of Bias tools and GRADE), nor does it cover conflicts of interest. 

INSPECT-SR contains 21 checks across four domains to help judge whether a study's data and findings can be trusted sufficiently to include it in a research synthesis (or indeed cite it in other contexts).

This guide includes guidance for the application of some of the component checks and the use of the tools and methods that implement them. In particular, the quantiative forensic meta-science methods included in INSPECT-SR's Domain 4 (see below). This guidance is based on INSPECT-SR's official guidance document (see osf [LINK TO BE ADDED]). 

### Citation

Wilkinson JD, Heal C, Flemyng E, Antoniou GA, Aburrow T, Alfirevic Z, et al. INSPECT-SR: a tool for assessing trustworthiness of randomised controlled trials. medRxiv 2025.09.03.25334905; doi: [10.1101/2025.09.03.25334905](https://doi.org/10.1101/2025.09.03.25334905)

## Overview of the four domains

| Domain | Focus |
|--------|-------|
| **Domain 1** | Inspecting post-publication notices |
| **Domain 2** | Inspecting conduct, governance and transparency |
| **Domain 3** | Inspecting text and figures |
| **Domain 4** | Inspecting results in the study |

For each domain, the reviewer records a judgement of **"no concerns"**, **"some concerns"**, or **"serious concerns"**. These domain-level judgements inform an overall study-level judgement using the same scale.

## How to use INSPECT-SR in a systematic review

- Apply INSPECT-SR **before** Risk of Bias assessment. Trials judged as "serious concerns" should not be included, making Risk of Bias assessment unnecessary for those trials.
- Two reviewers should apply INSPECT-SR independently, then compare and agree on judgements.
- Teams benefit from complementary expertise (clinical/content knowledge and statistical skills).
- The assessment can be terminated early: if "serious concerns" are reached at any point, the remaining checks need not be completed.
- Trials rated "some concerns" should be included but subjected to sensitivity analysis.
- Report INSPECT-SR assessments in the systematic review (e.g., in characteristics of included/excluded studies).

## Domain 1: Inspecting post-publication notices

### 1.1. Does the study have an associated retraction?

Check the journal website and the [Retraction Watch database](http://retractiondatabase.org/) for retractions. Use DOI for searching where possible. A "yes" typically warrants "serious concerns" for the domain and overall.

### 1.2. Does the study have an associated expression of concern or other relevant post-publication notice?

Check the journal website, Retraction Watch database, and also post-publication comments (letters to editor, [PubPeer](https://www.pubpeer.com/)). The [PubPeer browser plugin](https://www.pubpeer.com/static/extensions) automatically flags studies with comments. Consider the content carefully — not all critiques relate to trustworthiness.

There is also the ['Concerning'](https://dbrech.irit.fr/pls/apex/f?p=9999:34::::::) and ['Annulled'](https://dbrech.irit.fr/pls/apex/f?p=9999:33::::::) detectors.

### 1.3. Do other studies by the research team highlight causes for concern?

Search the first, corresponding, and last author on the [Retraction Watch database](http://retractiondatabase.org/). A track record of integrity problems may introduce doubts about the index study.

## Domain 2: Inspecting conduct, governance and transparency

### 2.1. Are there concerns relating to ethical approval?

Check for ethical approval details: reference number, approving body, and date. Where an approval number is available, search online to verify it hasn't been taken from an unrelated study. Incomplete details in older studies may not indicate problems.

### 2.2. Are there concerns relating to the timing or absence of study registration?

Absent or retrospective registration makes it difficult to determine whether reported methods and results reflect planned work. Consider the timing relative to recruitment. Registration expectations vary by era and jurisdiction.

### 2.3. Are there important inconsistencies between the publication and the registration documents?

Check for unexplained discrepancies in sample size, interventions, study dates, or eligibility criteria between the publication and the **first version** of the registration. Disagreements with post-trial-start registration amendments are particularly concerning. If there is no registration, answer "Not applicable."

### 2.4. Is the recruitment of participants implausible?

Consider whether the reported cohort size could plausibly be recruited in the reported timeframe, given the study setting, condition prevalence, and available resources. Domain knowledge is required.

### 2.5. Are there concerns about the plausibility of conducting the study using the reported methods and resources?

Consider whether the protocol could realistically be implemented given the study setting, staffing, and funding.

## Domain 3: Inspecting text and figures

### 3.1. Are there concerns relating to duplicated content, such as text or tables, or text that is incompatible with the study?

Look for plagiarised text (using plagiarism software if available), "tortured phrases" (e.g., "counterfeit consciousness" for "artificial intelligence"), or text that doesn't match the study context (e.g., describing a different population or intervention).

- [Tortured Phrases detector](https://dbrech.irit.fr/pls/apex/f?p=9999:24)

### 3.2. Is there evidence of manipulation or duplication of figures?

Examine figures for signs of manipulation or duplication (e.g., identical plots across panels of different outcomes, manually added error bars, or shifted curves).

Image forensics methods are beyond the scope of this website, but tools include the following:

- ImageTwin [URL]
- Proofig [URL]
- Imagetrakr [URL]
- Forensically [URL]
- FotoForensics [URL]
- Ghiro [URL]

## Domain 4: Inspecting results in the study

### 4.1. Are there any unexplained discrepancies between reported data and participant eligibility criteria?

Check whether reported participant characteristics are compatible with the eligibility criteria.

### 4.2. Are numbers of participants allocated to each group implausible given the allocation method?

Check whether group sizes are consistent with the stated randomisation method. For example, blocked randomisation with a fixed block size of 4 cannot produce imbalances exceeding 2.

### 4.3. Are any baseline data implausible?

Consider clinical/biological and numerical plausibility of baseline characteristics. Look for unusual patterns such as excess even/odd numbers, multiples of 5, or implausibly identical values across groups.

There are also quantiative methods for the assessment of whether groups are systematically too simliar or too different assuming random assignment:

- Barnett’s Baseline [Web app](https://aushsi.shinyapps.io/baseline/) and associated R package 
- Carlisle’s method [URL for implementations?]
- Bolland’s reappraised R package [URL needed]

Seperately, there are quantiative methods to assess whether reported a) reported p values and b) effect sizes for between-groups differences for continuous or categorical data can be reproduced from reported summary statistics (i.e., M/SD/N or counts)

- recalc [Web app](https://errors.shinyapps.io/recalc_independent_t_test/)
- Bolland’s p value recalculator Web app [URL needed]

### 4.4. Are there any discrepancies between results reported in figures, tables, and text?

Check for contradictions where the same results appear in multiple places (figures, tables, main text, abstract).

### 4.5. Are the numbers of participants lost to follow-up implausible?

Consider whether attrition rates are plausible given the context, condition, follow-up duration, and study protocol.

### 4.6. Are there any unexplained inconsistencies in the numbers of participants?

Check for inconsistencies in participant numbers across different parts of the manuscript, including the CONSORT diagram.

The consistency of sample sizes (Ns), means (M), and Standard Deviations between whole samples and subgroups:

- ANCHOR (Assessing Numerical Consistency between wHOle sample and subgRoups) [Web app](https://errors.shinyapps.io/ANCHOR/)

### 4.7. Are any outcome data, including estimated treatment effects, implausible?

Consider the plausibility of outcome values and treatment effects. Compare to other studies in the meta-analysis if available. Duplication of treatment effects between trials from the same team is particularly concerning.

As noted in 4.3, there are quantiative methods to assess whether reported SMD effect sizes for between-groups differences can be reproduced from reported summary statistics (i.e., M/SD/N).

- recalc [Web app](https://errors.shinyapps.io/recalc_independent_t_test/)

There are also methods to assess the risk that reported SDs are in fact Standard Errors. Note that confusion of SE and SD is extremely common and polutes the results of meta analyses (REF).

- [placeholder - tool in development]

### 4.8. Are the means and variances of integer data impossible?

For variables that can only take integer values, check whether reported means and standard deviations are mathematically possible for the given sample size using the [GRIM](/methods/grim/) and [GRIMMER](/methods/grimmer/) methods.

**Tools for this check:**

- [scrutiny](/tools/scrutiny/) — R package implementing GRIM and GRIMMER tests, with a convenient interface for checking multiple values at once
- [Nick Brown's GRIM calculator](http://nickbrown.fr/GRIM) — online GRIM checker
- [PrePubMed GRIMMER](http://www.prepubmed.org/grimmer/) — online GRIMMER checker
- Note to self: should the above link to GRIM generally, and then the GRIM etc pages debate the merits of different implmentations?

### 4.9. Are there errors in statistical results?

Check whether reported p-values are consistent with the reported summary data. For t-tests, verify using the group means, SDs, and sample sizes. For categorical data analysed by chi-squared test, attempt to reproduce the p-value from reported frequencies.

**Tools for this check:**

- [recalc](/tools/recalc/) — R package for recalculating p values and effect sizes from means, SDs, and sample sizes
- [GraphPad t-test calculator](https://www.graphpad.com/quickcalcs/ttest1/?format=sd) — online t-test calculator
- [OpenEpi](https://www.openepi.com/Menu/OE_Menu.htm) — open source epidemiologic statistics

Be cautious: p-values from continuous variables will not generally be exactly reproducible from rounded summary data. Consider consistency rather than exact reproduction.

### 4.10. Are any other contradictions implied by the data?

Look for other anomalies such as subgroup counts/means conflicting with overall results, means falling outside reported ranges, or logically impossible outcome combinations.

### 4.11. Are there inconsistencies in descriptions of methods and results across publications describing the study?

Check for major unexplained discrepancies between publications associated with the study (e.g., conference abstract vs. main results paper), including conflicting results, group sizes, or methods.

## Making judgements

- The tool does **not** use a prescriptive algorithm. Domain-level judgements do not follow mechanically from individual check responses.
- A "yes" to a single check may be sufficient for "serious concerns" if the problem is severe enough, but should not automatically trigger that judgement.
- The overall study-level judgement should typically be at least as severe as the most severe domain-level judgement.
- "Some concerns" across multiple domains may cumulatively warrant "serious concerns" overall.
- A judgement of "serious concerns" should only be used when it is clear, beyond reasonable doubt, that there are serious concerns.
- Record explanatory text for each check response and for domain/study-level judgements.

## Resources

- [INSPECT-SR on OSF](https://osf.io/b74wj/files/osfstorage) — latest versions of the guidance document
- [Feedback survey](https://www.qualtrics.manchester.ac.uk/jfe/form/SV_eOPavZZHDZ0fvN4) — provide anonymous feedback on your experience with the tool
- [Retraction Watch database](http://retractiondatabase.org/) — search for retractions and post-publication notices
- [PubPeer](https://www.pubpeer.com/) — post-publication peer review comments
- [Cochrane implementation guidance](https://www.cochranelibrary.com/cdsr/editorial-policies/problematic-studies-implementation-guidance#7-1) — templates for reporting trustworthiness concerns to journals
