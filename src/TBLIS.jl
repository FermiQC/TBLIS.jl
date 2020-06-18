module TBLIS

using Libdl
using LinearAlgebra
using Hwloc_jll
using tblis_jll

export TTensor
export mul!
export add!

global tblis = C_NULL
global tci = C_NULL
global hwloc = C_NULL

function __init__()
    if Sys.isapple()
        path = joinpath(dirname(pathof(TBLIS)),"libtci.0.dylib")
        opath = "/usr/local/lib/libtci.0.dylib"
        if !isfile(opath)
            run(`ln -s $path $opath`)
        end
        global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
    else
        global tci = dlopen(joinpath(dirname(pathof(TBLIS)),"libtci"))
        global hwloc = dlopen(Hwloc_jll.libhwloc)
        global tblis = dlopen(tblis_jll.tblis)
    end
end


include("TTensor.jl")
include("Ops.jl")

end #module
