module TBLIS

using Libdl
using LinearAlgebra

export TTensor
export mul!
export add!

global tblis = C_NULL
global tci = C_NULL

function init()
    global tci = dlopen(joinpath(dirname(pathof(TBLIS)),"libtci"))
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
end


include("TTensor.jl")
include("Ops.jl")

end #module
