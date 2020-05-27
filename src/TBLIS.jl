module TBLIS

using Libdl
using LinearAlgebra

global tblis = C_NULL

function init()
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis.so"))
end

include("TTensor.jl")
include("Ops.jl")

end #module
