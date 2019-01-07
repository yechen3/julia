## Lecture 4, sparse matrix operations.

#= We are going to look at the Candyland matrix!

See some analysis online:
* <http://www.lscheffer.com/CandyLand.htm>
* <http://datagenetics.com/blog/december12011/index.html>

We are studying a slightly different set of rules
with respect to the sticky states. In one set
of rules (on those pages), a sticky state just holds
your character determinstically for one step. In our
set of rules, a sticky state holds you until you draw
a specific color. So if you see some differences,
that is why.
=#

## We have build the Markov transition matrix for you!
using DelimitedFiles
using SparseArrays
data = readdlm("candyland-matrix.csv",',')
TI = Int.(data[:,1])
TJ = Int.(data[:,2])
TV = data[:,3]
T = sparse(TI,TJ, TV, 140,140)
coords = readdlm("candyland-coords.csv",',')
x = coords[:,1]
y = coords[:,2]
cells = Int.(readdlm("candyland-cells.csv",','))
start,dest = cells[1:2]
##
sum(T,dims=1)
##
findall(vec(sum(T,dims=1)) .< 0.9)
## Let's see how Julia stores thigns
typeof(T)
## What can we do with T?
fieldnames(typeof(T))
(:m, :n, :colptr, :rowval, :nzval)
##
T.colptr
##
T.nzval
##
T.rowval
## Why sparse matrices?
# The first reason is memory!
print(varinfo(r"T"))
A = Array(T)
print(varinfo(r"A")) # so it takes about 10% of the memory!
## The second reason is speed as you'll see on the homework.

## The downside is that some operations need a lot more care.

## Let's write our own matvec given the raw arrays
function mymatvec(TI,TJ,TV,x,m)
  y = zeros(m)
  for nzi in 1:length(TI)
    i = TI[nzi]
    j = TJ[nzi]
    v = TV[nzi]
    y[i] += v*x[j]
  end
  # A fancy way
  #for (i,j,v) in zip(TI,TJ,TV)
  #  y[i] += v*x[j]
  # end
  return y
end
x = randn(140)
mymatvec(TI,TJ,TV,x,140) == T*x
##
y = mymatvec(TI,TJ,TV,x,140)
z = T*x

##
## Let's see how Julia stores thigns
typeof(T)
## What can we do with T?
fieldnames(typeof(T))
##
T.colptr
##
T.nzval
##
T.rowval
##
function cscmatvec(colptr,rowval,nzval,x,m)
  y = zeros(m)
  for j=1:length(colptr)-1 # for each column ...
    for nzi=colptr[j]:colptr[j+1]-1 # for each entry in the column
      i = rowval[nzi]
      v = nzval[nzi]
      y[i] += v*x[j]
    end
  end
  return y
end
cscmatvec(T.colptr,T.rowval,T.nzval,x,140) == T*x

## Note that getting a random column in T is fast
# Note, run this a few times, the first time
# in Julia tends to be unreliable.
@time T[:,(rand(1:size(T,2)))]
## But getting a random row in T is slow
@time T[rand(1:size(T,1)),:]

## Okay, maybe we need a bigger matrix
S = sprandn(100000,100000,10/100000)
##Note that getting a random column in S is fast
@time S[:,rand(1:size(T,2))]
## But getting a random row in S is slow
@time S[rand(1:size(T,1)),:]
## Also note that there is NO way we could possibly store S with dense
length(S)*8/1e9 # it would take 80GB of memory, which is 10x my Mac.
## And we can go bigger
S = sprandn(10000000,10000000,10/10000000)
##Note that getting a random column in S is fast
@time S[:,rand(1:size(T,2))]
## But getting a random row in S is slow
@time S[rand(1:size(T,1)),:]
