@testset "Check type hierarchy" begin
    @test DAS28 <: Composite
    @test cDAS28ESR isa DAS28
    @test cDAS28CRP isa DAS28
    @test cSDAI isa Composite
end


@testset "`decompose()` with AbstractMeasures" begin
    dDAS28ESR, dDAS28CRP, dSDAI = decompose.([cDAS28ESR, cDAS28CRP, cSDAI], digits=6)
    # Assert that unadjusted components add up to 1
    @test sum(values(dDAS28ESR)) ≈ 1 atol = 1e-5
    @test sum(values(dDAS28CRP)) ≈ 1 atol = 1e-5
    @test sum(values(dSDAI)) ≈ 1 atol = 1e-5
end

@testset "`decompose()` with Reals" begin
    dDAS28ESR = decompose(cDAS28ESR_notype, digits=6)
    @test sum(values(dDAS28ESR)) ≈ 1 atol = 1e-5
end

@testset "`collapse()` unadjusted" begin
    # Assert that collapsed dimensions add up to 1
    @test sum(values(collapse(cDAS28ESR, digits=6))) ≈ 1 atol = 1e-5
    @test sum(values(collapse(cDAS28CRP, digits=6))) ≈ 1 atol = 1e-5
    @test sum(values(collapse(cSDAI, digits=6))) ≈ 1 atol = 1e-5
end

@testset "`collapse()` adjusted" begin
    # Assert that collapse works with adjustment – not a very specific test yet
    @test collapse(cDAS28ESR, adjust=true) isa Dict
    @test collapse(cDAS28CRP, adjust=true) isa Dict
    # TODO add respective test for SDAI once objective and subjective are defined 
end