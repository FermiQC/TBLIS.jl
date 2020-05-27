using TBLIS
using Test
TBLIS.init()

O = 2
V = 2
TT = Float64

A = rand(TT,O,O,O,O)
B = rand(TT,O,O,V,V)
C = zeros(TT,O,O,V,V)
tijab = TBLIS.TTensor{TT}(A)
WmBeJ = TBLIS.TTensor{TT}(B)
T2 = TBLIS.TTensor{TT}(C)

#@tensor C[i,j,a,b] = A[i,j,k,l]*B[k,l,a,b]
for i=1:O,j=1:O,a=1:V,b=1:V
    for k=1:O,l=1:O
        C[i,j,a,b] += A[i,j,k,l]*B[k,l,a,b]
    end
end
_C = deepcopy(C)
C .= 0
TBLIS.mul!(T2,tijab,WmBeJ,"ijkl","klab","ijab")
@test isapprox(_C,C,rtol=1E-10)

_B = deepcopy(B) + deepcopy(C)
TBLIS.add!(WmBeJ,T2,"ijab","ijab")

@test T2.data ≈ C
@test isapprox(_B,C,rtol=1E-10)
