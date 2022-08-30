for t1 in ("n", "t"), t2 in ("n", "t")
    base = "dgemm_"
    methodname = base * t1 * t2
    libmethodname = "blasfeo_" * methodname
    @eval function $(Symbol(methodname))(m::Integer, n::Integer, k::Integer, alpha::Cdouble, 
            sA::blasfeo_dmat, ai::Integer, aj::Integer, 
            sB::blasfeo_dmat, bi::Integer, bj::Integer, beta::Cdouble,
            sC::blasfeo_dmat, ci::Integer, cj::Integer, 
            sD::blasfeo_dmat, di::Integer, dj::Integer, 
        )
        ccall(($libmethodname, libblasfeo),
            Cvoid,
            (Cint, Cint, Cint, Cdouble, 
                Ref{blasfeo_dmat}, Cint, Cint,
                Ref{blasfeo_dmat}, Cint, Cint, Cdouble,
                Ref{blasfeo_dmat}, Cint, Cint,
                Ref{blasfeo_dmat}, Cint, Cint,
            ),
            m, n, k, alpha, sA, ai, aj, sB, bi, bj, beta, sC, ci, cj, sD, di, dj
        )
    end
end

"""
D ← beta * C + alpha * A * B
"""
function dgemm_nn(m::Integer, n::Integer, k::Integer, alpha::Cdouble, 
        sA::blasfeo_dmat, ai::Integer, aj::Integer, 
        sB::blasfeo_dmat, bi::Integer, bj::Integer, beta::Cdouble,
        sC::blasfeo_dmat, ci::Integer, cj::Integer, 
        sD::blasfeo_dmat, di::Integer, dj::Integer, 
    )
    ccall((:blasfeo_dgemm_nn, libblasfeo),
        Cvoid,
        (Cint, Cint, Cint, Cdouble, 
            Ref{blasfeo_dmat}, Cint, Cint,
            Ref{blasfeo_dmat}, Cint, Cint, Cdouble,
            Ref{blasfeo_dmat}, Cint, Cint,
            Ref{blasfeo_dmat}, Cint, Cint,
        ),
        m, n, k, alpha, sA, ai, aj, sB, bi, bj, beta, sC, ci, cj, sD, di, dj
    )
end

"""
D ← beta * C + alpha * A * B'
"""
function dgemm_nt(m::Integer, n::Integer, k::Integer, alpha::Cdouble, 
        sA::blasfeo_dmat, ai::Integer, aj::Integer, 
        sB::blasfeo_dmat, bi::Integer, bj::Integer, beta::Cdouble,
        sC::blasfeo_dmat, ci::Integer, cj::Integer, 
        sD::blasfeo_dmat, di::Integer, dj::Integer, 
    )
    ccall((:blasfeo_dgemm_nt, libblasfeo),
        Cvoid,
        (Cint, Cint, Cint, Cdouble, 
            Ref{blasfeo_dmat}, Cint, Cint,
            Ref{blasfeo_dmat}, Cint, Cint, Cdouble,
            Ref{blasfeo_dmat}, Cint, Cint,
            Ref{blasfeo_dmat}, Cint, Cint,
        ),
        m, n, k, alpha, sA, ai, aj, sB, bi, bj, beta, sC, ci, cj, sD, di, dj
    )
end