
struct tblis_matrix
    type::Int32
    conj::Int32
    attr::NTuple{4,Float32}
    data::Array{Float32,2}
    m::Int
    n::Int
    rs::Int
    cs::Int
end

function tblis_matrix(D)
    m = size(D,1)
    n = size(D,2)
    M = tblis_matrix(zero(Int32),zero(Int32),
                 Tuple([0.f0,0.f0,0.f0,0.f0]),
                 D,
                 m,n,
                 1,m)
#    tblis_init_matrix_s = dlsym(tblis,:tblis_init_matrix_s)

end


tblis_init_matrix_s = dlsym(tblis,:tblis_init_matrix_s)
tblis_matrix_mult = dlsym(tblis,:tblis_matrix_mult)
