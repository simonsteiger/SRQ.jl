@testset "DAS28 cutoffs" begin
    @test cut(cDAS28ESR) == "Moderate"
end

@testset "SDAI cutoffs" begin
    @test cut(cSDAI) == "High"
end