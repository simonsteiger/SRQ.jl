@testset "Valid arithmetic on AbstractMeasures" begin
    @test t28 * 3 == value(t28) * 3
    @test t28 / 3 == value(t28) / 3
    @test t28 + t28 == mapreduce(value, +, [t28, t28])
    @test t28 - t28 == mapreduce(value, -, [t28, t28])
    @test log(t28) == log(value(t28))
    @test log1p(t28) == log1p(value(t28))
    @test sqrt(t28) == sqrt(value(t28))
end

@testset "Invalid arithmetic on AbstractMeasures" begin
    # Division of two AbstractMeasures is not defined
    @test try
        t28 / t28
    catch error
        error isa MethodError
    end
    # Multiplication of two AbstractMeasures is not defined
    @test try
        t28 * t28
    catch error
        error isa MethodError
    end
    # Division of Real by AbstractMeasure is not defined
    @test try
        3 / t28
    catch error
        error isa MethodError
    end
end