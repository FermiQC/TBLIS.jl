[![Build Status](https://travis-ci.com/mdav2/TBLIS.jl.svg?branch=master)](https://travis-ci.com/mdav2/TBLIS.jl)
# TBLIS.jl
Julia wrapper for TBLIS tensor contraction library.

> [!] Work in progress
> Tested on Julia nightly builds and latest stable release (1.4.2) 

Currently only tensor addition and multiplication are implemented - please file an issue if you need 
other functionality from TBLIS.

## Install
```
julia>]
pkg>add https://github.com/mdav2/TBLIS.jl.git
```

## Usage
```
using TBLIS
TBLIS.init()

O = 5
V = 20
TT = Float32

A = rand(TT,O,O,O,O)
B = rand(TT,O,O,V,V)
C = zeros(TT,O,O,V,V)
tijab = TBLIS.TTensor{TT}(A)
WmBeJ = TBLIS.TTensor{TT}(B)
T2 = TBLIS.TTensor{TT}(C)

TBLIS.mul!(T2,tijab,WmBeJ,"ijkl","klab","ijab")
TBLIS.add!(T2,WmBeJ,"ijkl","ijkl")
```
