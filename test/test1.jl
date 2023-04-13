using TBLIS
using Test
#TBLIS.init()

const O = 2
const V = 2

@testset "$eltype" for eltype in (Float32, Float64, ComplexF32, ComplexF64)
  A = rand(eltype,O,O,O,O)
  B = rand(eltype,O,O,V,V)
  C = zeros(eltype,O,O,V,V)
  tijab = TBLIS.TTensor(A,1.0)
  WmBeJ = TBLIS.TTensor(B,1.0)
  T2 = TBLIS.TTensor(C,1.0)

  #@tensor C[i,j,a,b] = A[i,j,k,l]*B[k,l,a,b]
  for i=1:O,j=1:O,a=1:V,b=1:V
      for k=1:O,l=1:O
          C[i,j,a,b] += A[i,j,k,l]*B[k,l,a,b]
      end
  end
  _C = deepcopy(C)
  C .= 0
  TBLIS.mul!(T2,tijab,WmBeJ,"ijkl","klab","ijab")
  @test isapprox(_C, C, rtol=eps(real(eltype))^(2/3))

  _B = deepcopy(B) + deepcopy(C)
  TBLIS.add!(WmBeJ,T2,"ijab","ijab")

  @test T2.data ≈ C
  @test isapprox(_B,C,rtol=eps(real(eltype))^(2/3))
end

@testset "Test changing the number of TBLIS threads" begin
  tblis_num_threads = TBLIS.get_num_threads()

  TBLIS.set_num_threads(4)
  @test TBLIS.get_num_threads() == 4

  TBLIS.set_num_threads(1)
  @test TBLIS.get_num_threads() == 1

  # Set the number of TBLIS threads back to the original value
  TBLIS.set_num_threads(tblis_num_threads)
  @test TBLIS.get_num_threads() == tblis_num_threads
end
