using JuMP, SCS, LinearAlgebra

# Define the two quantum states
rho1 = [0.8 0.2; 0.2 0.2]
rho2 = [0.2 0.2; 0.2 0.8]

# Define probability distribution for the states
p1 = 0.5
p2 = 1 - p1

# Initialize optimization model
model = Model(SCS.Optimizer)

# Define the optimization variable (the measurement operator) to be Hermitian + PSD 
@variable(model, P[1:2, 1:2], PSD)

# Constraint: trace of measurement operator should be 1
@constraint(model, tr(P) == 1)

# define objective function
@objective(model, Max, p1 * tr(rho1 * P) + p2 * tr(rho2 * (I - P)))


# Solve SDP
optimize!(model)

# Get optimal measurement
P_optimal = value.(P)

# Calculate the optimal success probability
optimal_success_probability = objective_value(model)

println("Optimal measurement P:")
println(P_optimal)

println("Optimal success probability: ", optimal_success_probability)
