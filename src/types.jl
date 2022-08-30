free(x) = nothing 

mutable struct blasfeo_dmat
    mem::Ptr{Cdouble}  # pointer to passed chunk of memory
    pA::Ptr{Cdouble}   # pointer to pm*pn array of doubles
    dA::Ptr{Cdouble}   # pointer to min(m,n) array of doubles
    m::Cint            # rows
    n::Cint            # cols
    pm::Cint           # packed number of rows
    cn::Cint           # packed number of cols
    use_dA::Cint       # flag to tell if dA can be used
    memsize::Cint      # size of needed memory
    function blasfeo_dmat()
        new(Ptr{Cdouble}(), Ptr{Cdouble}(), Ptr{Cdouble}(), 0, 0, 0, 0, 0, 0)
    end
end

mutable struct blasfeo_dvec
    mem::Ptr{Cdouble}  # pointer to passed chunk of memory
    pa::Ptr{Cdouble}   # pointer to a pm array of doubles
    m::Cint            # size
    pm::Cint           # packed size
    memsize::Cint      # size of needed memory
end

function new_aligned_memory(num_bytes::Integer, alignment::Integer)
    num_bytes += alignment
    mem = Vector{UInt8}(undef, num_bytes)
    ptr = pointer(mem)
    ptr_aligned = Ptr{UInt8}((UInt64(ptr) + alignment - 1) ÷ alignment * alignment)
    return mem, ptr_aligned
end

struct PackedMatrix 
    _memory::Vector{UInt8}  # raw (unaligned) memory buffer
    _mat::blasfeo_dmat
    function PackedMatrix(m::Integer, n::Integer; alignment::Int=64)
        # Create a raw Julia memory buffer so that the memory is managed by Julia
        m = Cint(m)
        n = Cint(n)
        memsize = memsize_dmat(m, n)
        mem,ptr = new_aligned_memory(memsize, alignment)

        # Use the aligned pointer to initialize the struct
        mat = blasfeo_dmat()
        # create_dmat(m, n, mat, ptr)
        allocate_dmat(m, n, mat)
        new(mem, mat)
    end
end

@inline getdata(mat::PackedMatrix) = mat._mat
