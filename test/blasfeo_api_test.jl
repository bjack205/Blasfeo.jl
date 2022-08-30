using Blasfeo
using Test

# Allocate matrices
m,n,p = Cint(12),Cint(10),Cint(6)
A_ = Blasfeo.PackedMatrix(m,n)
B_ = Blasfeo.PackedMatrix(n,p)
C_ = Blasfeo.PackedMatrix(m,p)

# Get the raw blasfeo structs
sA = Blasfeo.getdata(A_)
sB = Blasfeo.getdata(B_)
sC = Blasfeo.getdata(C_)

# Copy data
A = randn(m,n)
B = randn(n,p)
C = zeros(m,p)

Blasfeo.pack_dmat(m, n, A, sA, 0, 0) 
Blasfeo.pack_dmat(n, p, B, sB, 0, 0) 
Blasfeo.pack_dmat(m, p, C, sC, 0, 0) 

# Matrix multiplication
alpha = 2.1
beta = 0.0
Blasfeo.dgemm_nn(m, p, n, alpha, sA, 0, 0, sB, 0, 0, beta, sC, 0, 0, sC, 0, 0)
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
@test C ≈ alpha * A * B

beta = 1.1
Blasfeo.dgemm_nn(m, p, n, alpha, sA, 0, 0, sB, 0, 0, beta, sC, 0, 0, sC, 0, 0)
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
C0 = alpha * A * B
@test C ≈ beta * C0 + alpha * A * B

# Transpose multiplication
Bt_ = Blasfeo.PackedMatrix(p,n)
sBt = Blasfeo.getdata(Bt_)
Blasfeo.pack_tran_dmat(n, p, B, sBt, 0, 0) 
Bt = zeros(p,n) 
Blasfeo.unpack_dmat(p, n, sBt, 0, 0, Bt)
@test Bt ≈ B'

beta = 0.0
Blasfeo.dgemm_nt(m, p, n, alpha, sA, 0, 0, sBt, 0, 0, beta, sC, 0, 0, sC, 0, 0)
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
@test C ≈ alpha * A * Bt'

At_ = Blasfeo.PackedMatrix(n,m)
sAt = Blasfeo.getdata(At_)
Blasfeo.pack_tran_dmat(m, n, A, sAt, 0, 0) 
At = Matrix(A')

Blasfeo.dgemm_tn(m, p, n, alpha, sAt, 0, 0, sB, 0, 0, beta, sC, 0, 0, sC, 0, 0)
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
@test C ≈ alpha * A * B

Blasfeo.dgemm_tt(m, p, n, alpha, sAt, 0, 0, sBt, 0, 0, beta, sC, 0, 0, sC, 0, 0)
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
@test C ≈ alpha * A * B


## Benchmarks
using StaticArrays
using Octavian
using BenchmarkTools
using LinearAlgebra
As = SMatrix{Int(m),Int(n)}(A)
Bs = SMatrix{Int(n),Int(p)}(B)
Ats = SMatrix{Int(n),Int(m)}(At)
Bts = SMatrix{Int(p),Int(n)}(Bt)

@btime Blasfeo.dgemm_nn($m, $p, $n, $alpha, $sA, 0, 0, $sB, 0, 0, $beta, $sC, 0, 0, $sC, 0, 0)
@btime mul!($C, $A, $B, $alpha, $beta)
@btime matmul!($C, $A, $B, $alpha, $beta)
@btime $alpha * $As*$Bs

@btime Blasfeo.dgemm_tt($m, $p, $n, $alpha, $sAt, 0, 0, $sBt, 0, 0, $beta, $sC, 0, 0, $sC, 0, 0)
@btime mul!($C, $At', $Bt', $alpha, $beta)
@btime matmul!($C, $At', $Bt', $alpha, $beta)
@btime $alpha * $Ats'*$Bts'