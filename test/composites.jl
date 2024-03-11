cESR, cCRP = map([DAS28ESR, DAS28CRP]) do T
    T(4, 5, 12, 44)
end
cSDAI = SDAI(4, 5, 12, 5, 44)

@testset "Check type hierarchy" begin
    @test AbstractDAS28 <: AbstractComposite
    @test cESR isa AbstractDAS28
    @test cCRP isa AbstractDAS28
    @test cSDAI isa AbstractComposite
end


@testset "Decompose AbstractScore" begin
    dESR, dCRP, dSDAI = decompose.([cESR, cCRP, cSDAI], digits=6)
    # Assert that unadjusted components add up to 1
    @test sum(values(dESR)) ≈ 1 atol = 1e-5
    @test sum(values(dCRP)) ≈ 1 atol = 1e-5
    @test sum(values(dSDAI)) ≈ 1 atol = 1e-5
end

@testset "Collapse AbstractScore" begin
    # Assert that collapsed dimensions add up to 1
    @test sum(values(collapse(cESR, digits=6))) ≈ 1 atol = 1e-5
    @test sum(values(collapse(cCRP, digits=6))) ≈ 1 atol = 1e-5
    # TODO add respective test for SDAI once objective and subjective are defined 
end