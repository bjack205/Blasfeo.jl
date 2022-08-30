using Blasfeo
using Test

# Allocate matrices
m,n,p = Cint(5),Cint(4),Cint(6)
A = Blasfeo.PackedMatrix(m,n)
B = Blasfeo.PackedMatrix(n,p)
C = Blasfeo.PackedMatrix(m,p)

# Get the raw blasfeo structs
sA = Blasfeo.getdata(A)
sB = Blasfeo.getdata(B)
sC = Blasfeo.getdata(C)

# Test setting / getting elements
Blasfeo.dgein1(10.1, sA, 0, 1)
Blasfeo.dgein1(11.2, sB, 1, 0)
Blasfeo.dgein1(12.3, sC, 2, 3)
@test Blasfeo.dgeex1(sA, 0, 1) == 10.1 
@test Blasfeo.dgeex1(sB, 1, 0) == 11.2 
@test Blasfeo.dgeex1(sC, 2, 3) == 12.3 

# Initialize A to ones, B to twos, and C to zeros
Blasfeo.dgese(m, n, 1.0, sA, 0, 0)
Blasfeo.dgese(n, p, 2.0, sB, 0, 0)
Blasfeo.dgese(m, p, 0.0, sC, 0, 0)

@test Blasfeo.dgeex1(sA, 0, 0) == 1.0
@test Blasfeo.dgeex1(sB, 0, 0) == 2.0
@test Blasfeo.dgeex1(sC, 0, 0) == 0.0

@test Blasfeo.dgeex1(sA, 0, 1) == 1.0
@test Blasfeo.dgeex1(sB, 1, 0) == 2.0 
@test Blasfeo.dgeex1(sC, 2, 3) == 0.0 

# Unpack the full matrix
A = zeros(m,n)
B = zeros(n,p)
C = zeros(m,p)

Blasfeo.unpack_dmat(m, n, sA, 0, 0, A) 
Blasfeo.unpack_dmat(n, p, sB, 0, 0, B) 
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 
@test A == ones(m, n)
@test B == fill(2.0, n, p)
@test C == zeros(m, p)

# Pack the full matrix
A2 = randn(m,n)
B2 = randn(n,p)
C2 = randn(m,p)

Blasfeo.pack_dmat(m, n, A2, sA, 0, 0) 
Blasfeo.pack_dmat(n, p, B2, sB, 0, 0) 
Blasfeo.pack_dmat(m, p, C2, sC, 0, 0) 

# Unpack again and compare
Blasfeo.unpack_dmat(m, n, sA, 0, 0, A) 
Blasfeo.unpack_dmat(n, p, sB, 0, 0, B) 
Blasfeo.unpack_dmat(m, p, sC, 0, 0, C) 

@test A == A2
@test B == B2
@test C == C2

