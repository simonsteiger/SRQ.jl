using SRQ
using Test

@testset "Composites" begin
    include("composites.jl")
end

@testset "Cutoffs" begin
    include("cutoffs.jl")
end
