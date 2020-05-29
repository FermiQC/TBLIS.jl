module TBLIS

using Libdl
using LinearAlgebra

export TTensor
export mul!
export add!

global tblis = C_NULL

function init()
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
end


include("TTensor.jl")
include("Ops.jl")

end #module
