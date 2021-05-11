# TBLIS.jl
[![CI](https://github.com/FermiQC/TBLIS.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/FermiQC/TBLIS.jl/actions/workflows/CI.yml)

Julia wrapper for TBLIS tensor contraction library.

Currently only tensor addition and multiplication are implemented - please file an issue if you need 
other functionality from TBLIS.

## Install
```
julia>]
pkg>add TBLIS
```

## Usage
```
using TBLIS
TBLIS.init()

TT = Float32
O = 10
V = 50

_A = rand(TT,O,O,O,O)
_B = rand(TT,O,O,V,V)
_C = zeros(TT,O,O,V,V)
```
Arrays must be converted to TTensor objects. 
```
A = TBLIS.TTensor{TT}(_A)
B = TBLIS.TTensor{TT}(_B)
C = TBLIS.TTensor{TT}(_C)
```
This object only creates a pointer to the original data.
```
julia> A.data === _A
true
```
* For a general contraction, the syntax is `TBLIS.mul!(C, A, B, Aind, Bind, Cind)`
where `Aind`, `Bind`, and `Cind` are strings following Einstein's notation.

* Addition is performing following `TBLIS.add!(A, B, Aind, Bind)`. 
```
# C[i,j,a,b] += A[i,j,k,l]*B[k,l,a,b]
TBLIS.mul!(C, A, B, "ijkl", "klab", "ijab")

# B += A
TBLIS.add!(A, B, "ijkl", "ijkl")
```
