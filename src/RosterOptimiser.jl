module RosterOptimiser

greet() = print("Hello World!")

using JuMP, GLPK

function main()
    # Define the number of employees and shifts
    n_employees = 5
    n_shifts = 3

    # Define the cost matrix
    # Each row in the matrix represents an employee, and each column represents a shift.
    cost = [1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1]
    println("Here")
    println(cost)

    # Define the model
    model = Model(GLPK.Optimizer)

    # Define the decision variables
    @variable(model, x[1:n_employees, 1:n_shifts], Bin)

    # Define the objective function
    @objective(model, Min, sum(cost[i, j] * x[i, j] for i in 1:n_employees for j in 1:n_shifts))

    # Define the constraints
    # Number of shifts each employee works
    for i in 1:n_employees
        @constraint(model, sum(x[i, j] for j in 1:n_shifts) == 1)
    end

    # Number of employees per shift
    for j in 1:n_shifts
        @constraint(model, sum(x[i, j] for i in 1:n_employees) >= 1)
    end

    # Solve the model
    optimize!(model)
    status = JuMP.termination_status(model)
    println(status)

    # Print the results
    println("Optimal solution:")
    for i in 1:n_employees
        for j in 1:n_shifts
            if value(x[i, j]) > 0.5
                println("Employee $i works shift $j")
            end
        end
    end
    println(x)
end

end # module RosterOptimiser
