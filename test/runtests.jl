using Heron
using Test

@testset "Heron.jl Basic usage" begin
    @test heron(2, 1//10) |> Rational === 17//12
    @test heron(2, 1//100) |> Rational === 17//12
    @test heron(2, 1//1000) |> Rational === 577//408
    @test heron(2, 0.1) |> Rational === 17//12
    @test heron(3, 0.001) |> Rational === 97//56
    @test heron(4, 0.001) == ℜ_nn{Rational{Int64}}(21523361//10761680)
    @test heron(2., 0.1) ≈ 1.4166666666666665
    @test heron(2., 0.001) ≈ 1.4142156862745097
    @test heron(2., 0.001, 1.) ≈ 1.4142156862745097
end

# From http://khinsen.net/leibniz-examples/examples/heron.html
@testset "khinsen.net's tests" begin
    # Rationals
    @test heron(2, 1//2)^2 - 2 === 1//4
    @test heron(2, 1//10)^2 - 2 === 1//144
    @test heron(2, 1//100)^2 - 2 === 1//144
    @test heron(2, 1//200)^2 - 2 === 1//166464

    # Floating point
    @test heron(2., 0.5)^2 - 2 === 0.25
    @test heron(2., 0.5) - √2 ≈ 0.08578643762690485
    @test abs(heron(2., 0.1)^2 - 2) < 0.1
    @test heron(2.0, 0.1) - √(2.0) == 0.002453104293571373
    @test abs(heron(2.0, 0.01)^2 - 2.0) < 0.01
    @test heron(2.0, 0.001) - √(2.0) ≈ 2.123901414519125e-06
end