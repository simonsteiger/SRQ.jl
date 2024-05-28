@testset "DAS28 cutoffs" begin
    @test cutoff(cDAS28ESR) == "Moderate"
    @test cutoff(5.4, DAS28CRP) == "High"
    @test cutoff(2.5, DAS28ESR) == "Remission"
end

@testset "SDAI cutoffs" begin
    @test cutoff(cSDAI) == "High"
end