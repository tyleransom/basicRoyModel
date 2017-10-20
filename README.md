# basicRoyModel
Canonical Roy Model simulation in Julia


Let's look at a simple version of the Roy Model where agents can choose to be teachers or bankers.

Skill is distributed log-normally, so the log of skill has a joint normal distribution:

So our vector of log ability \begin{array}{c}
\ln\left(A_{i,teacher}\right)\\
\ln\left(A_{i,banker}\right)
\end{array} 

is distributed normal with mean 
\begin{array}{c}
\mu_{teacher}\\
\mu_{banker}
\end{array}

and covariance

\begin{array}{cc}
\sigma_{t}^{2} & \sigma_{t,b}\\
\sigma_{t,b} & \sigma_{b}^{2}
\end{array}

Meanwhile, individuals have utility for earnings, which depends on how that ability is rewarded in the economy

$$w_{i,teacher} = \beta_{t}A_{i,teacher}\\
  w_{i,banker}  = \beta_{b}A_{i,banker}$$
  
We want to see how selection operates differently within each sector; we want to calculate, e.g.

$$ E[A_{i,teacher}\,|\,chose\,to\,be\,a\,teacher]$$

We'll see how different it looks under different assumptions about the distributional parameters and returns to skill.


```julia
using Distributions

srand(1234);


function royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
    # Define skill distribution
    skill_dist = MvNormal([μ_t,μ_b], cat(1,cat(2,σ_t,σ_tb),cat(2,σ_tb,σ_b)))

    # Draw population
    AbilityMat = rand(skill_dist,N);

    teacher_abil = AbilityMat[1,:];
    banker_abil = AbilityMat[2,:];

    w_teacher = β_t*exp.(teacher_abil);
    w_banker = β_b*exp.(banker_abil);

    println("Average wages")
    println(round(mean(w_teacher),2))
    println(round(mean(w_banker),2))
    println("")

    is_teacher = w_teacher.>w_banker
    is_banker  = w_banker .>w_teacher

    println("Proportion teachers & bankers")
    println(round(100.*mean(is_teacher),2),"%")
    println(round(100.*mean(is_banker),2),"%")
    println("")

    println("Average wages conditional on choice")
    println(round(mean(w_teacher[is_teacher]),2))
    println(round(mean(w_banker[is_banker]),2))
    println("")
return
end
```




    royModel (generic function with 1 method)



### Run with baseline parameter values


```julia
N = 5000;

μ_t = 2.2;
μ_b = 2.5;

σ_t = 0.5;
σ_b = 0.9;
σ_tb = 0.6;

β_t = 0.7;
β_b = 0.7;

royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
```

    Average wages
    8.03
    13.36
    
    Proportion teachers & bankers
    25.0%
    75.0%
    
    Average wages conditional on choice
    6.04
    16.2
    


### Make ability negatively correlated


```julia
σ_tb = -0.6;
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
```

    Average wages
    8.03
    13.45
    
    Proportion teachers & bankers
    41.36%
    58.64%
    
    Average wages conditional on choice
    13.17
    20.01
    


### Increase returns to teaching ability


```julia
β_t = 1.2*β_b;
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
```

    Average wages
    9.98
    13.06
    
    Proportion teachers & bankers
    48.46%
    51.54%
    
    Average wages conditional on choice
    15.27
    21.21
    


### Make ability positively correlated again


```julia
σ_tb = 0.6;
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
```

    Average wages
    9.85
    13.45
    
    Proportion teachers & bankers
    39.72%
    60.28%
    
    Average wages conditional on choice
    7.81
    18.38
    
