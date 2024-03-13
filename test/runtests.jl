using SRQ
using Test

include("setup.jl")

@testset "Measures" begin
    include("measures.jl")
end

@testset "Composites" begin
    include("composites.jl")
end

@testset "Cutoffs" begin
    include("cutoffs.jl")
end
