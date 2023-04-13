function mul!(C::T, A::T, B::T, idx_A::String, idx_B::String, idx_C::String; nt=C_NULL) where {T<:TTensor{T2}} where {T2<:BlasFloat}
    tblis_tmul = dlsym(tblis, :tblis_tensor_mult)
    ccall(tblis_tmul, Cvoid, (Ptr{Nothing}, Ptr{Nothing},
            Ref{TTensor{T2}}, Cstring,
            Ref{TTensor{T2}}, Cstring,
            Ref{TTensor{T2}}, Cstring), C_NULL, C_NULL,
        A, idx_A,
        B, idx_B,
        C, idx_C)
end

function add!(A::T, B::T, idx_A::String, idx_B::String) where {T<:TTensor{T2}} where {T2<:BlasFloat}
    tblis_tadd = dlsym(tblis, :tblis_tensor_add)
    ccall(tblis_tadd, Cvoid, (Ptr{Nothing}, Ptr{Nothing},
            Ref{TTensor{T2}}, Cstring,
            Ref{TTensor{T2}}, Cstring),
        C_NULL, C_NULL,
        A, idx_A,
        B, idx_B)
end

function Base.conj!(t::TTensor{T}) where {T}
    t.tensor = tblis_tensor{T}(t.tensor.type, t.tensor.conj == zero(Int32) ? one(Int32) : zero(Int32),
        t.tensor.attr, t.tensor._data, t.tensor.ndim, t.tensor._len, t.tensor._stride)
    return t
end