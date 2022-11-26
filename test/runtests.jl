using Heron
using Test

@testset "Basic usage" begin
    @test heron(2, 1//10) |> Rational === 17//12
    @test heron(2, 1//100) |> Rational === 17//12
    @test heron(2, 1//1000) |> Rational === 577//408
    @test heron(2, 0.1) |> Rational === 17//12
end