[![Build Status](https://travis-ci.com/FermiQC/TBLIS.jl.svg?branch=master)](https://travis-ci.com/FermiQC/TBLIS.jl)
# TBLIS.jl
Julia wrapper for TBLIS tensor contraction library.

> [!] Work in progress
> Tested on Julia nightly builds and latest stable release (1.4.2) 

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

A = rand(TT,O,O,O,O)
B = rand(TT,O,O,V,V)
C = zeros(TT,O,O,V,V)
```
Arrays must be converted to TTensor objects. 
```
A = TBLIS.TTensor{TT}(A)
B = TBLIS.TTensor{TT}(B)
C = TBLIS.TTensor{TT}(C)
```
This object only creates a pointer to the original data.
```
julia> _A.data === A
true
```
* For a general contraction the syntax is `TBLIS.mul!(C, A, B, Aind, Bind, Cind)`
where `Aind`, `Bind`, and `Cind` are strings following Einstein's notation.

* Addition is performing follwing `TBLIS.add!(A, B, Aind, Bind)`. 
```
# C[i,j,a,b] = A[i,j,k,l]*B[k,l,a,b]
TBLIS.mul!(C, A, B, "ijkl", "klab", "ijab")
# B += A
TBLIS.add!(A, B, "ijkl", "ijkl")
```
