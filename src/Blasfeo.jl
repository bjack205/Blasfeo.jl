module Blasfeo

const libblasfeo = joinpath(@__DIR__, "..", "deps", "blasfeo", "build", "libblasfeo.so")
include("types.jl")
include("memory.jl")
include("aux.jl")
include("blasfeo_api.jl")

end # module
