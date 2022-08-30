## Get / set elements
"""
    set A[ai,aj] ← a
"""
function dgein1(a::Cdouble, sA::blasfeo_dmat, ai::Integer, aj::Integer)
    ccall((:blasfeo_dgein1, libblasfeo),
        Cvoid,
        (Cdouble, Ref{blasfeo_dmat}, Cint, Cint),
        a, Ref(sA), ai, aj
    )
end


"""
    get A[ai,aj]
"""
function dgeex1(sA::blasfeo_dmat, ai::Integer, aj::Integer)
    ccall((:blasfeo_dgeex1, libblasfeo),
        Cdouble,
        (Ref{blasfeo_dmat}, Cint, Cint),
        Ref(sA), ai, aj
    )
end


## Packing
"""
    Convert column-major to strided matrix
"""
function pack_dmat(m::Integer, n::Integer, A::AbstractMatrix{Cdouble}, 
        sB::blasfeo_dmat, bi::Integer, bj::Integer)
    lda = stride(A,2)
    ccall((:blasfeo_pack_dmat, libblasfeo),
        Cvoid,
        (Cint, Cint, Ref{Cdouble}, Cint, Ref{blasfeo_dmat}, Cint, Cint),
        m, n, A, lda, Ref(sB), bi, bj 
    )
    sB
end

"""
    Pack transposed column-major matrix into strided matrix
    `A` is size `(m,n)`
    `B` is size `(n,m)`
"""
function pack_tran_dmat(m::Integer, n::Integer, A::AbstractMatrix{Cdouble}, 
        sB::blasfeo_dmat, bi::Integer, bj::Integer)
    size(A) == (m,n) || throw(DimensionMismatch("A should of size ($m,$n), got $(size(A))."))
    sB.m == n || throw(DimensionMismatch())
    sB.n == m || throw(DimensionMismatch())
    lda = stride(A,2)
    ccall((:blasfeo_pack_tran_dmat, libblasfeo),
        Cvoid,
        (Cint, Cint, Ref{Cdouble}, Cint, Ref{blasfeo_dmat}, Cint, Cint),
        m, n, A, lda, Ref(sB), bi, bj 
    )
    sB
end

"""
    Convert strided matrix to column-major
"""
function unpack_dmat(m::Integer, n::Integer, sA::blasfeo_dmat, 
        ai::Integer, aj::Integer, B::AbstractMatrix{Float64})
    ldb = stride(B,2)
    ccall((:blasfeo_unpack_dmat, libblasfeo),
        Cvoid,
        (Cint, Cint, Ref{blasfeo_dmat}, Cint, Cint, Ref{Cdouble}, Cint),
        m, n, Ref(sA), ai, aj, B, ldb
    )
    B
end

## Other
"""
    Set all elements to alpha
"""
function dgese(m::Integer, n::Integer, alpha::Cdouble, sA::blasfeo_dmat, ai::Integer, aj::Integer)
    ccall((:blasfeo_dgese, libblasfeo),
        Cvoid,
        (Cint, Cint, Cdouble, Ref{blasfeo_dmat}, Cint, Cint),
        m, n, alpha, Ref(sA), ai, aj
    )
end