module TBLIS

using Libdl
using LinearAlgebra

export TTensor
export mul!
export add!

global tblis = C_NULL

function init()
    if Sys.isapple() && !isfile("/usr/local/lib/libtci.0.dylib")
        loc = dirname(pathof(TBLIS))
        run(`ln -s $loc/libtci.0.dylib /usr/local/lib/libtci.0.dylib`)
    elseif Sys.islinux() && !isfile("/usr/local/lib/libtci.so.0")
        loc = dirname(pathof(TBLIS))
        run(`ln -s $loc/libtci.so /usr/local/lib/libtci.so.0`)
    end
    global tblis = dlopen(joinpath(dirname(pathof(TBLIS)),"libtblis"))
end


include("TTensor.jl")
include("Ops.jl")

end #module
