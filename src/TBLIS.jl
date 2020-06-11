module TBLIS

using Libdl
using LinearAlgebra

export TTensor
export mul!
export add!

global tblis = C_NULL
global tci = C_NULL

function init()
    if Sys.isapple()
        path = joinpath(dirname(pathof(TBLIS)),"libtci.0.dylib")
        opath = "/usr/local/lib/libtci.0.dylib"
        if !isfile(opath)
            run(`ln -s $path $opath`)
        end
    else
        global tci = dlopen(joinpath(dirname(pathof(TBLIS)),"libtci"))
    end
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
end


include("TTensor.jl")
include("Ops.jl")

end #module
