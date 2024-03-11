using SRQ
using Test

@testset "Composites" begin
    include("Composites.jl")
end

@testset "Cutoffs" begin
    include("Cutoffs.jl")
end
