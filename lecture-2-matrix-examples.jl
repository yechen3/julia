## Create the matrix
A = [
4 9 6 0 4 5 3.0
4 9 4 1 9 9 7
4 9 4 6 0 1 0
4 9 6 1 7 6 1
4 9 4 8 7 9 8
4 9 6 2 3 9 9
4 9 4 6 0 1 3
4 9 6 9 4 3 2
4 9 4 9 0 2 5
4 9 4 6 0 0 5
4 9 4 6 0 0 9
]

## Create a simple instance of our least squares problem
using Random
n = 25
Random.seed!(1) # make it repeatable
x = 10.0.*rand(n).-5.0
y = 3.0*x .- 2.0 + 2.0*randn(n)
## Make a plot
using Plots
pyplot(dpi=300, size=(600,600))
scatter(x, y, label="data")
gui()

##

## Save the picture
pyplot(size=(250,250)) # this is a 2.5-by-2.5 inch picture, suitable for a small graphic
scatter(x, y, label="data")
savefig("least-squares-example-1.pdf")


## Create the matrix A
A = [ones(n) x]
c = A \ y # solve the least squares problem

## Add the line
plot!(x, x -> c[1] + c[2]*x, label="fit")
gui()

## Try the same with the quadratic
n = 25
Random.seed!(1) # make it repeatable
x = 10.0.*rand(n).-5.0
y = -0.5*x.^2 + 3.0*x .- 2.0 + 2.0*randn(n)
scatter(x, y, label="data")
gui()

##
A = [ones(n) x x.^2]
c = A \ y # solve the least squares problem
