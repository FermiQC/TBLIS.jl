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

"""
    TTensor{T}(D) where T <: AbstractFloat

Wraps a Julia array `D` into a TTensor that can be added, multiplied, etc. 
"""
function TTensor{T}(D) where T <: AbstractFloat
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
        tblis_init_tensor = dlsym(tblis,:tblis_init_tensor_s)
    elseif T == Float64
        tblis_init_tensor = dlsym(tblis,:tblis_init_tensor_d)
    else
        error("Type $T is not supported by TBLIS :(")
    end
    ccall(tblis_init_tensor, Cvoid, (Ref{TTensor{T}},Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
          M, n, lens, D, strides)
    return M
end
