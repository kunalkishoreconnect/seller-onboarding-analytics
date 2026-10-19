# Seller onboarding analytics — synthetic portfolio case

## Evidence status
All users and events are fictional. Device differences are deliberately encoded in the generator. They demonstrate analysis, NOT discovery of real seller behavior or a causal UX effect. No experiment has been run.

## Question
Where do sellers drop off between account creation and first pickup within seven days?

## SQL results
- Accounts: 3000
- Business details completed: 1895
- First shipments created: 1176
- First pickups: 898
- Signup-to-pickup conversion: 29.9%

device_type  users  details_conversion  pickup_conversion
    desktop    834            0.781775           0.393285
     mobile   2166            0.573869           0.263158

## Interpretation
Compare both absolute losses and conditional conversion rates. Mobile detail completion is lower by construction. This warrants a proposed research question, not a claim that a confusing form causes abandonment.

## Recommendation
Validate mobile onboarding friction with seller interviews and usability sessions before shipping a redesign. Then test a shorter form with clearer instructions and saved progress. Do not remove required verification.

## Proposed experiment
- Unit: seller account; persist assignment across devices.
- Population: new mobile signups, excluding staff and duplicate accounts by predefined rules.
- Allocation: 50/50; intention-to-treat analysis.
- Primary: business details completed within seven days of signup.
- Planning baseline: 58%; minimum detectable improvement: 5 percentage points, to 63%.
- Approximate fixed-horizon sample: 1500 accounts per arm, two-sided alpha 0.05, power 80%, normal approximation, before operational buffers.
- Timing: enrollment days = ceil(3000/eligible_daily_mobile_signups), minimum two full weeks, plus seven days follow-up. Traffic unknown; no guaranteed test duration.
- Guardrails: verification rejection rate, seven-day first-shipment creation, form errors. Predefine noninferiority margins with stakeholders; do not invent approved business tolerances.
- Check assignment balance, telemetry completeness, and sample-ratio mismatch before reading effects.
- Decision: ship only if primary uplift is statistically significant, practically valuable, and guardrails pass. Do not stop early on favorable p-values. Inconclusive results are not evidence of no effect.

## Limitations
No real customer validation, no observed intervention effect, simplified event process, no live carrier or verification integration. Repeat shipment measures behavior, not revenue retention.
