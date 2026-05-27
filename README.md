# Leveraging Probabilistic Programming in Causal Inference for Precision Medicine

Master's thesis, Ghent University, Faculty of Bioscience Engineering, 2023-2024.

> **Core question:** Can probabilistic programming languages (PPLs) answer causal "what if" questions from observational data more accurately than established alternatives, and can this be applied to a real medical problem?

---

## Overview

Standard statistical methods often fail to distinguish correlation from causation in observational data. This project frames causal inference within Pearl's structural causal model (SCM) framework, encodes causal structure as DAGs, and compares four methods on a controlled benchmark before applying the best approach to a real-world medical question.

**Two case studies:**

1. **Toy benchmark**: Synthetic ice cream sales data with a known ground truth. Temperature drives both ice cream sales and electricity usage, creating a spurious correlation. Used to benchmark all four methods with verifiable answers.
2. **Vitamin D & Depression**: NHANES 2015-2016 public health data. Does raising serum vitamin D levels causally reduce depressive symptoms? A Bayesian PPL model adjusted for five confounders (age, gender, BMI, smoking, economic status) runs counterfactual queries on n = 1,628 participants.

---

## Methods

All methods are framed around Pearl's causal hierarchy: **association → intervention → counterfactual**.

| Method | Implementation | Intervention | Counterfactual |
|---|---|---|---|
| Do-calculus (linear regression) | Python (sklearn, statsmodels) | Yes | Yes |
| Propensity Score Matching (PSM) | Python (sklearn `LogisticRegression` + `NearestNeighbors`) | Yes | No |
| Causal Forests | Python (econml `CausalForestDML`) | Yes | Yes |
| **Probabilistic Programming (PPL)** | **Julia (Turing.jl)** | **Yes** | **Yes** |

The PPL model encodes all causal relationships as a joint probabilistic model. Continuous variables are sampled with HMC; discrete variables with Particle Gibbs (PG). The full sampler is a Gibbs composition: `Gibbs(HMC(...), PG(...))`. Model coefficients are initialized via MAP estimation using `Optim.jl` before running MCMC.

---

## Key Results

### Toy Example: Electricity Usage vs Ice Cream Sales (true ATE = 0)

**Intervention:** "What happens to ice cream sales if electricity usage increases by 20 kW/day?"

| Model | ATE | 95% CI |
|---|---|---|
| Do-Calculus | -0.08 | [-0.70, 0.52] |
| PSM | 1.11 | [-111.90, 122.05] |
| Causal Forests | 0.10 | [-0.57, 0.78] |
| **Probabilistic Programming** | **0.08** | **[-3.48, 3.27]** |

All methods correctly identify no causal effect (CI contains 0). PSM produces an extremely wide CI, consistent with known instabilities on generated data where treatment groups are clearly separated.

**Counterfactual:** "How many units would have sold if temperature was 30°C every day?" (true AME = 30)

| Model | AME | 95% CI |
|---|---|---|
| Do-Calculus | 29.57 | [26.99, 32.16] |
| Causal Forests | 28.75 | [26.08, 30.40] |
| **Probabilistic Programming** | **30.03** | **[29.20, 30.71]** |

**Predictive RMSE (models that support full prediction):**

| Model | Intervention | Counterfactual |
|---|---|---|
| Do-Calculus | 37.89 | 37.92 |
| **Probabilistic Programming** | **19.38** | **19.45** |

The PPL model achieves roughly **2× lower RMSE** than do-calculus. By explicitly modelling noise in every variable, it handles the inherent randomness of the data generation process more faithfully than linear regression.

### Real-World: Does Vitamin D Deficiency Cause Depression?

**Data:** NHANES 2015–2016, n = 1,628. Exposure: serum 25-OHD2+D3 (`LBXVIDMS`, nmol/L). Outcome: depressive symptoms (`DPQ020`, binarised). Confounders: age, gender, BMI, smoking, economic status.

Two counterfactual questions (motivated by Wang et al. 2024):

- *"Would depressed patients with VitD in the lowest 20% (< 41.3 nmol/L) improve if raised to the 80th percentile (84.5 nmol/L)?"*
  ATE = -0.22 (95% CI = [-0.80, 0.36]): inconclusive

- *"Would depressed patients with VitD between the 80th-90th percentile improve if raised to the 95th percentile (108 nmol/L)?"*
  ATE = -0.21 (95% CI = [-0.59, 0.16]): inconclusive

Both CIs contain 0. This is either a true null effect or a consequence of the limited depression proxy (single questionnaire item vs. validated instruments like BDI/DSM-V) and potential unmeasured confounders.

---

## Repository Structure

```
scripts/
├── data_gen/               # Synthetic ice cream dataset generation (Julia)
├── dag_figures/            # DAG construction and visualisation (R, dagitty/ggdag)
├── plotting/               # Result plots (R Markdown)
├── prob_programming/       # Turing.jl PPL models for the ice cream example:
│   ├── ice_cream_ppl_simple.ipynb          # Association query
│   ├── ice_cream_ppl_intervention.ipynb    # Intervention query
│   ├── ice_cream_ppl_causal_inference.ipynb
│   ├── ice_cream_ppl_counterfactual.ipynb  # Counterfactual query
│   └── ics_model_optimization.ipynb        # MAP initialisation via Optim.jl
├── ics_alternatives/       # Alternative causal inference methods (Python):
│   ├── alt_causal_inf_linreg.ipynb         # Linear regression baseline
│   ├── alt_causal_inf_multivariate.ipynb   # Do-calculus via multivariate regression
│   ├── alt_causal_inf_prop_score_intervention.ipynb  # PSM
│   ├── alt_causal_inf_causalforest_intervention.ipynb
│   └── alt_causal_inf_causalforest_counterfactual.ipynb
└── real_life_data/         # NHANES vitamin D analysis:
    ├── vitd_nhanes.ipynb               # Data merging and cleaning (Python)
    ├── vit_d_data_exploration.ipynb    # Exploratory analysis (Julia)
    ├── vitamind_ppl_model.ipynb        # PPL model structure (Julia)
    ├── vitamin_d_interevention.ipynb   # Counterfactual inference, main result (Julia)
    ├── vitd_optimized.ipynb            # Optimised MAP model (Julia)
    ├── causal_forests_vitd.ipynb       # Causal forests on NHANES (Python)
    └── measures.py / measures.jl       # NHANES column name constants

results/vitd/               # Saved MAP optimisation outputs
src/                        # Julia package entry point (DrWatson)
```

---

## Data

### Ice cream (synthetic)

Generate by running `scripts/data_gen/ice_cream_data.ipynb`. Output: `data/ice_cream_sales.csv`.

Variables: `Temperature`, `Is_Weekend`, `Hours_Open`, `Electricity_Usage`, `Ice_Cream_Sales`.

### NHANES 2015–2016 (public)

Download the following `.XPT` files from the [NHANES 2015–2016 cycle](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?BeginYear=2015) and place them in `data/vitd/nhanes/`:

| File | Contents |
|---|---|
| `VID_I.XPT` | Serum vitamin D (`LBXVIDMS`) |
| `DEMO_I.XPT` | Age, gender, poverty index (`RIDAGEYR`, `RIAGENDR`, `INDFMMPI`) |
| `BMX_I.XPT` | BMI (`BMXBMI`) |
| `SMQ_I.XPT` | Smoking status (`SMQ040`) |
| `DPQ_I.XPT` | Depression questionnaire (`DPQ020`) |
| `ALQ_I.XPT` | Alcohol use (loaded; excluded from final model) |
| `PAQ_I.XPT` | Physical activity (loaded; excluded due to bidirectional relationship with depression) |

Then run `scripts/real_life_data/vitd_nhanes.ipynb` to merge, filter, and export `data/vitd/nhanes.csv`.

---

## Reproduction

### Julia (PPL models)

Requires Julia 1.8.1.

```julia
using Pkg
Pkg.add("DrWatson")
Pkg.activate("path/to/this/project")
Pkg.instantiate()
```

Key packages: `Turing`, `Optim`, `Distributions`, `DataFrames`, `CSV`, `MCMCChains`, `StatsPlots`, `StatsFuns`, `GLM`, `DrWatson`.

### Python (alternative methods + data prep)

```bash
pip install pandas pyreadstat scikit-learn econml statsmodels matplotlib numpy
```

### R (DAGs + plots)

```r
install.packages(c("dagitty", "ggdag", "ggplot2", "rmarkdown"))
```

---

## Tech Stack

| Language | Role | Key Libraries |
|---|---|---|
| Julia 1.8.1 | PPL models, data exploration | Turing.jl, Optim.jl, DrWatson.jl |
| Python | Data prep, alternative methods | pandas, pyreadstat, scikit-learn, econml |
| R | DAG visualisation, result plots | dagitty, ggdag, ggplot2, R Markdown |

---

## Citation

Karaaslan, H.B. (2024). *Leveraging Probabilistic Programming in Causal Inference for Precision Medicine*. Master's thesis, Ghent University, Faculty of Bioscience Engineering. Supervisors: Prof. dr. ir. Wim Van Criekinge, Prof. dr. ir. Michiel Stock, ir. Steff Taelman.
