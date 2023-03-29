struct tblis_tensor{T}
    type::Int32
    conj::Int32
    attr::ComplexF64
    _data::Ptr{Cvoid}
    ndim::Cuint
    _len::Ptr{Cvoid}
    _stride::Ptr{Cvoid}
end

mutable struct TTensor{T}
    tensor::tblis_tensor{T}
    n::Cuint
    data::Array{T}
    len::Array{Int}
    stride::Array{Int}
end

"""
    TTensor(D::Array{T}, scale) where T <: AbstractFloat

Wraps a Julia array `D` scaled with `scale` into a TTensor that can be interfaced by TBLIS.
"""
function TTensor(D::Array{T}, scale=one(T)) where T <: BlasFloat
    stride_vec = collect(strides(D))
    size_vec = collect(size(D))
    n::UInt32 = length(size(D))
    scale = T(scale)
    M = TTensor{T}(tblis_tensor{T}(zero(Int32), zero(Int32),
                                   0.0 + 0.0im,
                                   pointer(D),
                                   n,
                                   pointer(size_vec),
                                   pointer(stride_vec)), n, D, size_vec, stride_vec)
    if T == Float32
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_s)
        ccall(tblis_init_tensor_scaled, Cvoid, (Ref{TTensor{T}},Cfloat,Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
             M, scale, n, size_vec, D, stride_vec)
    elseif T == Float64
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_d)
        ccall(tblis_init_tensor_scaled, Cvoid, (Ref{TTensor{T}},Cdouble,Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
             M, scale, n, size_vec, D, stride_vec)
    elseif T == ComplexF32
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_c)
        ccall(tblis_init_tensor_scaled, Cvoid, (Ref{TTensor{T}},ComplexF32,Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
             M, scale, n, size_vec, D, stride_vec)
    elseif T == ComplexF64
        tblis_init_tensor_scaled = dlsym(tblis,:tblis_init_tensor_scaled_z)
        ccall(tblis_init_tensor_scaled, Cvoid, (Ref{TTensor{T}},ComplexF64,Cuint,Ptr{Int},Ptr{T}, Ptr{Int}),
             M, scale, n, size_vec, D, stride_vec)
    else
        error("Type $T is not supported by TBLIS :(")
    end
    return M
end
