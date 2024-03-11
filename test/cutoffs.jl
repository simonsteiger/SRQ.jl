@testset "DAS28 cutoffs" begin
    das28esr = DAS28ESR(4, 5, 12, 44)
    @test cut(das28esr) == "Moderate"
end