function mul!(C::T, A::T, B::T, idx_A::String, idx_B::String, idx_C::String; nt=C_NULL) where T <: TTensor{T2} where T2 <: AbstractFloat
    tblis_tmul = dlsym(tblis,:tblis_tensor_mult)
    ccall(tblis_tmul,Cvoid,(Ptr{Nothing},Ptr{Nothing},
                            Ref{TTensor{T2}},Cstring,
                            Ref{TTensor{T2}},Cstring,
                            Ref{TTensor{T2}},Cstring),

          C_NULL,C_NULL,
          A,idx_A,
          B,idx_B,
          C,idx_C)
end

function add!(A::T, B::T, idx_A::String, idx_B::String) where T <: TTensor{T2} where T2 <: AbstractFloat
    tblis_tadd = dlsym(tblis,:tblis_tensor_add)
    ccall(tblis_tadd,Cvoid,(Ptr{Nothing},Ptr{Nothing},
                            Ref{TTensor{T2}},Cstring,
                            Ref{TTensor{T2}},Cstring),
          C_NULL,C_NULL,
          A,idx_A,
          B,idx_B)
end
