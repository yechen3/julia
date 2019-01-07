##
using LinearAlgebra
#A = Matrix(1.0I,11,11) - diag(0.)
A = collect(SymTridiagonal(ones(11), -0.5*ones(10)))
##
A[1,2] = 0
A[end,end-1] = 0
b = [0;ones(9);0]
##
x = A\b


## Do a Monte Carlo simulation
function simlength()
  S = 0
  len = 0
  while S != -4 && S != 6
    len += 1
    S += rand(-1:2:1)
  end
  return len
end
##
function myfun()
  N = 10^6
  totallen = 0
  for i=1:N
    totallen = totallen + simlength()
  end
  return totallen / N
end
myfun()
##
# run simlength 10^6 times
N = 10^8
expectedlen = mapreduce(x -> simlength(), +, 1:N)/N

## Convert A as a sparse matrix.
using SparseArrays
B = sparse(A)

## Create A as a sparse matrix.
# we list all the non-zero entries in A.
function build_A()
  nz = 9*3 + 2
  I = zeros(Int, nz)
  J = zeros(Int, nz)
  V = zeros(nz)
  # the arrays I,J,V satisfy:
  # A[I[i],J[i]] = V[i]
  index = 1
  I[index] = 1
  J[index] = 1
  V[index] = 1.0
  index += 1
  for i=1:9
    I[index] = i+1
    J[index] = i
    V[index] = -0.5
    index += 1

    I[index] = i+1
    J[index] = i+1
    V[index] = 1.0
    index += 1

    I[index] = i+1
    J[index] = i+2
    V[index] = -0.5
    index += 1
  end

  I[index] = 11
  J[index] = 11
  V[index] = 1.0
  index += 1

  return sparse(I,J,V,11,11)
end
C = build_A()
