using Blasfeo
using Test

bytes = 64
alignment = 32
mem,ptr = Blasfeo.new_aligned_memory(bytes, alignment)
@test length(mem) == bytes + alignment
@test 0 <= ptr - pointer(mem) <= alignment
@test ptr + bytes < pointer(mem, length(mem))

alignment = 32 
mem,ptr = Blasfeo.new_aligned_memory(bytes, alignment)
@test ptr - pointer(mem) <= alignment
@test ptr + bytes < pointer(mem, length(mem))

# should be 8-byte aligned by default
alignment = 8 
mem,ptr = Blasfeo.new_aligned_memory(bytes, alignment)
@test ptr - pointer(mem) == 0
@test ptr + bytes < pointer(mem, length(mem))