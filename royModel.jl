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
    println(round(mean(w_teacher),2)," mean teaching wage (unconditional)")
    println(round(mean(w_banker),2)," mean banking wage (unconditional)")
    println("")

    is_teacher = w_teacher.>w_banker
    is_banker  = w_banker .>w_teacher

    println("Proportion teachers & bankers")
    println(round(100.*mean(is_teacher),2),"% teachers")
    println(round(100.*mean(is_banker),2),"% bankers")
    println("")

    println("Average wages conditional on choice")
    println(round(mean(w_teacher[is_teacher]),2)," mean teaching wage (observed)")
    println(round(mean(w_banker[is_banker]),2)," mean banking wage (observed)")
    println("")
return
end


# Now run with various parameter values:
N = 5000;

μ_t = 2.2;
μ_b = 2.5;

σ_t = 0.9;
σ_b = 0.9;
σ_tb = 0.6;

β_t = 0.7;
β_b = 0.7;

println("Baseline model:")
println("")
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)

# Negative correlation between skills:
σ_tb = -0.6;
println("Neg. correlation between skills:")
println("")
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)

# Increase returns to teaching ability:
β_t = 1.2*β_b;
println("Increased returns to teaching skills:")
println("")
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)

# Positive correlation between skills again:
σ_tb = 0.6;
println("Pos. correlation between skills:")
println("")
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)

# Decrease variance of teaching ability
σ_t = 0.7;
println("Decrease variance of teaching skills:")
println("")
royModel(N,μ_t,μ_b,σ_t,σ_b,σ_tb,β_t,β_b)
