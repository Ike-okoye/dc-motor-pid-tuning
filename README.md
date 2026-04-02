# DC Motor PID Controller Tuning and Comparative Analysis

![MATLAB](https://img.shields.io/badge/MATLAB-Control%20System%20Toolbox-orange)
![Optimization](https://img.shields.io/badge/Optimization-Genetic%20Algorithm-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Project-Complete-success)
![Research](https://img.shields.io/badge/Field-Control%20Systems-blueviolet)
<p align="center">
Comparative study of classical and optimization-based PID tuning methods for DC motor speed control.
</p>

---

# Overview

This project presents a **comparative analysis of three PID controller tuning techniques** applied to a DC motor system:

* Genetic Algorithm (GA)
* Ziegler–Nichols (ZN)
* Cohen–Coon (CC)

The controllers are evaluated using:

* Time-domain response characteristics
* Error performance indices
* Control effort analysis
* Control energy consumption

The objective is to determine which tuning method provides the **most stable, accurate, and energy-efficient control response**.
---

# Requirements

The project was developed and tested using **MATLAB**.

Required toolboxes:

* Control System Toolbox
* Global Optimization Toolbox (for Genetic Algorithm)

Recommended MATLAB version:

```
MATLAB R2022b or newer
```

---

# Reproducing the Experiments

The repository contains MATLAB scripts that reproduce the controller design and simulation results presented in this project.

## 1. Clone the Repository

```bash
git clone https://github.com/Ike-okoye/dc-motor-pid-tuning.git
cd dc-motor-pid-tuning
```

---

## 2. Open the Project in MATLAB

Open MATLAB and navigate to the project folder:

```
DC_motor_PID_tuning
```

---

## 3. Run the Tuning Scripts

The controller parameters can be reproduced using the following scripts.

### Genetic Algorithm Tuning

Run:

```
Scripts/DC_tuned_GA_script.m
```

This script:

* Initializes the GA optimization
* Searches for optimal PID parameters
* Minimizes the ITAE error index

---

### Ziegler–Nichols Tuning

Run:

```
Scripts/DC_Tuned_ZN_Script.m
```

This script computes the PID parameters based on the **ultimate gain and oscillation period**.

---

### Cohen–Coon Tuning

Run:

```
Scripts/DC_Tuned_Coon_Script.m
```

This script calculates the PID gains using **process reaction curve parameters**.

---

## 4. Run the Controller Comparison

To reproduce all figures and performance tables, run:

```
Scripts/DC_Motor_Tuning_comparison.m
```

This script:

* Simulates the closed-loop DC motor system
* Computes performance metrics
* Generates all comparison plots

Generated plots include:

* Step response comparison
* Control effort comparison
* Error performance indices
* Radar performance chart

---

# Output Figures

Running the comparison script will generate the following figures:

```
figures/
├── tuning_step_response_comparison.png
├── tuning_control_effort_plot.png
├── tuning_error_performance_index.png
└── tuning_normalized_controller_performance_radar_chart.png
```

These plots illustrate the performance differences between the three tuning methods.

---

# Simulink Model

The repository also includes a **Simulink implementation** of the DC motor system:

```
DCMotorModel.slx
```

This model contains:

* Armature dynamics
* Mechanical load dynamics
* Back EMF feedback
* PID controller implementation

The model can be used to visualize the system structure and verify simulation results.

---

# Reproducibility Notes

* All results are deterministic except the **Genetic Algorithm optimization**, which may produce slightly different parameters depending on random initialization.
* The provided GA parameters represent one optimized solution found during experimentation.

---

# Suggested Workflow

```
1. Run GA tuning script
2. Run ZN tuning script
3. Run Cohen–Coon tuning script
4. Run comparison script
5. Analyze generated figures
```

---

# Expected Results

The expected outcome is:

| Controller        | Performance                      |
| ----------------- | -------------------------------- |
| Genetic Algorithm | Fast response, minimal overshoot |
| Ziegler–Nichols   | Aggressive oscillatory response  |
| Cohen–Coon        | Moderate performance             |

The GA-based controller should provide the **best overall performance**.

---

# Contribution

Contributions and suggestions for improving the controller design or optimization process are welcome.
---
# System Modeling

A DC motor converts electrical energy into rotational mechanical motion.
Its behavior is governed by **electrical and mechanical dynamics**.

---

# Electrical Dynamics

<p align="center">
<img src="https://latex.codecogs.com/png.image?V_a(t)%3DL%5Cfrac%7Bdi(t)%7D%7Bdt%7D%2BRi(t)%2BK_b%5Comega(t)" />
</p>

Where:

| Parameter | Description         |
| --------- | ------------------- |
| Va        | Armature voltage    |
| i         | Armature current    |
| R         | Armature resistance |
| L         | Armature inductance |
| Kb        | Back EMF constant   |

---

# Mechanical Dynamics

<p align="center">
<img src="https://latex.codecogs.com/png.image?J%5Cfrac%7Bd%5Comega(t)%7D%7Bdt%7D%2Bb%5Comega(t)%3DK_ti(t)-T_L" />
</p>

Where:

| Parameter | Description          |
| --------- | -------------------- |
| J         | Rotor inertia        |
| b         | Friction coefficient |
| Kt        | Torque constant      |
| TL        | Load torque          |
| ω         | Angular velocity     |

---

# DC Motor Transfer Function

Combining the electrical and mechanical equations produces the transfer function:

<p align="center">
<img src="https://latex.codecogs.com/png.image?G(s)%3D%5Cfrac%7B44.99%7D%7Bs%5E3%2B44.98s%5E2%2B78.962s%7D" />
</p>

Where:

| Variable | Description             |
| -------- | ----------------------- |
| G(s)     | Motor transfer function |
| Input    | Armature voltage        |
| Output   | Angular speed           |

---

# PID Controller

The system is controlled using a **Proportional–Integral–Derivative (PID)** controller.

<p align="center">
<img src="https://latex.codecogs.com/png.image?C(s)%3DK_p%2B%5Cfrac%7BK_i%7D%7Bs%7D%2BK_ds" />
</p>

Where:

| Parameter | Function                      |
| --------- | ----------------------------- |
| Kp        | Reduces rise time             |
| Ki        | Eliminates steady-state error |
| Kd        | Improves damping              |

The tuning process determines optimal values of these parameters.

---

# Controller Tuning Methods

## Genetic Algorithm (GA)

Genetic Algorithms are **evolutionary optimization techniques** inspired by natural selection.

Controller parameters are optimized by minimizing the **Integral of Time-weighted Absolute Error (ITAE)**.

<p align="center">
<img src="https://latex.codecogs.com/png.image?ITAE%3D%5Cint_0%5ETt%7Ce(t)%7Cdt" />
</p>

Where:

| Symbol | Description     |
| ------ | --------------- |
| e(t)   | Tracking error  |
| T      | Simulation time |

Advantages of GA tuning:

* Global search capability
* Handles nonlinear optimization problems
* Produces high-performance controllers

---

## Ziegler–Nichols Method

The Ziegler–Nichols method uses the **ultimate gain Ku** and **oscillation period Pu**.

<p align="center">
<img src="https://latex.codecogs.com/png.image?K_p%3D0.6K_u" />
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?T_i%3D%5Cfrac%7BP_u%7D%7B2%7D" />
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?T_d%3D%5Cfrac%7BP_u%7D%7B8%7D" />
</p>

This method is simple but often produces **aggressive controllers with high overshoot**.

---

## Cohen–Coon Method

The Cohen–Coon method is based on **process reaction curve parameters**.

<p align="center">
<img src="https://latex.codecogs.com/png.image?K_p%3D%5Cfrac%7B%5Ctau%2FL%2B0.333%7D%7BK%7D" />
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?T_i%3D%5Ctau%5Cleft(%5Cfrac%7B30%2B3(L/%5Ctau)%7D%7B9%2B20(L/%5Ctau)%7D%5Cright)" />
</p>

<p align="center">
<img src="https://latex.codecogs.com/png.image?T_d%3D%5Ctau%5Cleft(%5Cfrac%7BL/%5Ctau%7D%7B11%2B2(L/%5Ctau)%7D%5Cright)" />
</p>

Where:

| Symbol | Description   |
| ------ | ------------- |
| K      | Process gain  |
| L      | Time delay    |
| τ      | Time constant |

---

# Controller Parameters

| Tuning Method     | Kp      | Ki       | Kd     |
| ----------------- | ------- | -------- | ------ |
| Genetic Algorithm | 24.799  | 0.000    | 15.005 |
| Ziegler–Nichols   | 47.400  | 135.4286 | 4.1475 |
| Cohen–Coon        | 24.2333 | 1.1385   | 0.1100 |

---

# Performance Metrics

| Metric        | Description                             |
| ------------- | --------------------------------------- |
| Rise Time     | Time to reach 90% of final value        |
| Settling Time | Time to remain within 2% tolerance band |
| Overshoot     | Maximum peak deviation                  |

---

# Error Performance Indices

### Integral of Squared Error

<p align="center">
<img src="https://latex.codecogs.com/png.image?ISE%3D%5Cint_0%5ETe(t)%5E2dt" />
</p>

### Integral of Absolute Error

<p align="center">
<img src="https://latex.codecogs.com/png.image?IAE%3D%5Cint_0%5ET%7Ce(t)%7Cdt" />
</p>

### Integral of Time-Weighted Absolute Error

<p align="center">
<img src="https://latex.codecogs.com/png.image?ITAE%3D%5Cint_0%5ETt%7Ce(t)%7Cdt" />
</p>

These indices measure **tracking accuracy and controller effectiveness**.

---

# Control Effort

The control signal applied to the system is:

<p align="center">
<img src="https://latex.codecogs.com/png.image?u(t)%3Dr(t)-y(t)" />
</p>

Control energy is defined as:

<p align="center">
<img src="https://latex.codecogs.com/png.image?J_u%3D%5Cint_0%5ETu(t)%5E2dt" />
</p>

---

# Step Response Comparison

<p align="center">
<img src="figures/tuning_step_response_comparison.png" width="750">
</p>

### Observations

| Controller        | Behaviour                            |
| ----------------- | ------------------------------------ |
| Genetic Algorithm | Fast response with minimal overshoot |
| Ziegler–Nichols   | Oscillatory response                 |
| Cohen–Coon        | Moderate oscillations                |

---

# Control Effort Comparison

<p align="center">
<img src="figures/tuning_control_effort_plot.png" width="750">
</p>

The GA controller requires **significantly lower control effort**.

---

# Error Performance Comparison

<p align="center">
<img src="figures/tuning_error_performance_index.png" width="750">
</p>

GA tuning produces **the lowest error indices**.

---

# Radar Chart Performance Comparison

<p align="center">
<img src="figures/tuning_normalized_controller_performance_radar_chart.png" width="750">
</p>

This chart summarizes the **normalized controller performance across multiple metrics**.

---

# Quantitative Performance Comparison

| Controller        | Rise Time | Settling Time | Overshoot | ISE    | IAE    | ITAE   | Control Energy |
| ----------------- | --------- | ------------- | --------- | ------ | ------ | ------ | -------------- |
| Genetic Algorithm | 0.10 s    | 0.16 s        | 0 %       | 0.31   | 0.24   | 0.05   | 0.12           |
| Ziegler–Nichols   | 0.14 s    | 3.90 s        | 66.49 %   | 8.10e7 | 1.52e4 | 2.34e4 | 4.21           |
| Cohen–Coon        | 0.23 s    | 5.88 s        | 65.74 %   | 4.51e3 | 3.21e2 | 8.12e2 | 1.73           |

---

# Project Structure

```
DC_motor_PID_tuning
│
├── Scripts
│   ├── DC_motor_Tuning_comparison.m
│   ├── DC_tuned_GA_script.m
│   ├── DC_Tuned_ZN_Script.m
│   ├── DC_Tuned_Coon_Script.m
│   └── GA_fitness_function.m
│
├── figures
│   ├── tuning_step_response_comparison.png
│   ├── tuning_control_effort_plot.png
│   ├── tuning_error_performance_index.png
│   └── tuning_normalized_controller_performance_radar_chart.png
│
└── DCMotorModel.slx
```

---

# Tools Used

* MATLAB
* Control System Toolbox
* Genetic Algorithm Optimization

---

# Conclusion

The comparative analysis shows that:

* **Genetic Algorithm tuning provides the best controller performance.**
* Classical tuning techniques produce larger overshoot and slower settling.
* Optimization-based tuning methods are better suited for **higher-order control systems**.

The GA-based controller achieves **superior accuracy, stability, and energy efficiency**.
