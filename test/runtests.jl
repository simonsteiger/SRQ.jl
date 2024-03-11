using SRQ
using Test

@testset "Test Composites module" begin
    include("composites.jl")
end

@testset "Test Cutoffs module" begin
    include("cutoffs.jl")
end
