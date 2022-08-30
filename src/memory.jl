"""
    Create a new 
"""
function allocate_dmat(m::Cint, n::Cint, sA::blasfeo_dmat)
    ccall((:blasfeo_allocate_dmat, libblasfeo), 
        Cvoid,
        (Cint, Cint, Ref{blasfeo_dmat},),
        m, n, sA 
    )
    sA
end

function free_dmat(sA::blasfeo_dmat)
    ccall((:blasfeo_free_dmat, libblasfeo),
        Cvoid,
        (Ref{blasfeo_dmat},),
        sA 
    )
end

function memsize_dmat(m::Cint, n::Cint)
    ccall((:blasfeo_memsize_dmat, libblasfeo),
        Cint,
        (Cint, Cint),
        m, n
    )
end

function create_dmat(m::Cint, n::Cint, sA::blasfeo_dmat, memory::Ptr{UInt8})
    ccall((:blasfeo_create_dmat, libblasfeo),
        Cvoid,
        (Cint, Cint, Ref{blasfeo_dmat}, Ptr{Cvoid}),
        m, n, Ref(sA), memory
    )
end


