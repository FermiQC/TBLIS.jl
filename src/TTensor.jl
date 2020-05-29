struct tblis_tensor{T}
    type::Int32
    conj::Int32
    attr::ComplexF64
    _data::Ptr{Cvoid}
    ndim::Cuint
    _len::Ptr{Cvoid}
    _stride::Ptr{Cvoid}
end

struct TTensor{T}
    tensor::tblis_tensor{T}
    n::Cuint
    data::Array{T}
    len::Array{Int}
    stride::Array{Int}
end

function TTensor(D)
    TTensor(D,1.0)
end
function TTensor(D,s)
    TTensor{Float64}(D,s)
end
function TTensor{T}(D) where T <: AbstractFloat
    TTensor{T}(D,1.0)
end
"""
    TTensor{T}(D,s) where T <: AbstractFloat

Wraps a Julia array `D` into a TTensor that can be added, multiplied, etc, scaled by s. 
"""
function TTensor{T}(D,s) where T <: AbstractFloat
    strides = [1]
    lens = collect(size(D))
    for (i,v) in enumerate(lens[1:end-1])
        push!(strides,v*strides[i])
    end
    n::UInt32 = length(size(D))
    M = TTensor{T}(tblis_tensor{T}(zero(Int32),zero(Int32),
                                   0.0 + 0.0im,
                                   pointer(D),
                                   n,
                                   pointer(lens),
                                   pointer(strides)), n, D, lens, strides)
    if T == Float32
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_s)
    elseif T == Float64
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_d)
    else
        error("Type $T is not supported by TBLIS :(")
    end
    ccall(tblis_init_tensor_scaled, Cvoid, (Ref{TTensor{T}},T,Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
          M, s, n, lens, D, strides)
    return M
end
