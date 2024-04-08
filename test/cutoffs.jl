@testset "DAS28 cutoffs" begin
    @test cut(cDAS28ESR) == "Moderate"
    @test cut(5.4, DAS28CRP) == "High"
    @test cut(2.5, DAS28ESR) == "Remission"
end

@testset "SDAI cutoffs" begin
    @test cut(cSDAI) == "High"
end