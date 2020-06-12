module TBLIS

using Libdl
using LinearAlgebra
using Hwloc_jll

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
    else
        global tci = dlopen(joinpath(dirname(pathof(TBLIS)),"libtci"))
        global hwloc = dlopen(Hwloc_jll.libhwloc)
    end
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
end


include("TTensor.jl")
include("Ops.jl")

end #module
