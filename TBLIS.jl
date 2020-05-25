using Libdl

global tblis = C_NULL


function init()
    global tblis = dlopen("libtblis.so")
end

#ccall(tblis_init_matrix_s,Cvoid,(Ptr{tblis_matrix}, Cptrdiff_t, Cptrdiff_t, Ptr{Float32}, Cptrdiff_t, Cptrdiff_t),Ref(_A),10000,10000,_A.data,1,10000);

#ccall(tblis_matrix_mult,Cvoid,(Ptr{Nothing},Ptr{Nothing},Ptr{tblis_matrix},Ptr{tblis_matrix},Ptr{tblis_matrix}),C_NULL,C_NULL,Ref(_A),Ref(_B),Ref(_C));

