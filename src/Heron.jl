"""
    Implement Heron's algorithm for computing square roots

    Inspired by Konrad Hinsen's discussion of the algorithm in this video
    https://www.youtube.com/watch?v=f10NpsMmbis
"""
module Heron

    import Base: +, ^, -, *, /, //, promote_rule
    export ℜ, ℜ_nn, heron

    # Alias Real as ℜ
    const ℜ = Real

    # Non-negative real type boxes a real
    struct ℜ_nn{R} <: ℜ
        x::R
        # Check non-negativity on construction
        ℜ_nn(x::R) where R <: ℜ = ℜ_nn{R}(x)

        ℜ_nn{R}(x::R) where R <: ℜ = x >= 0 ?
            new{R}(x) :
            throw(ArgumentError("x must be nonnegative"))
    end

    # Type conversion

    # Converting a ℜ_nn to ℜ_nn is just the identity
    ℜ_nn(r_nn::ℜ_nn) = r_nn

    # To convert ℜ to ℜ_nn, call the constructor
    convert(::Type{ℜ_nn}, x::ℜ) = ℜ_nn(x)

    # To convert a ℜ_nn to ℜ convert the boxed type
    (::Type{R})(r_nn::ℜ_nn) where R <: ℜ = R(r_nn.x)
    convert(::Type{R}, x::ℜ_nn) where R <: ℜ = convert(R, x.x)

    # ℜ_nn is closed over +, ^, / , //
    x::ℜ_nn + y::ℜ_nn = ℜ_nn(x.x + y.x)
    x::ℜ_nn ^ n::Int = ℜ_nn(x.x^n)
    x::ℜ_nn / y::ℜ_nn = ℜ_nn(x.x / y.x)
    x::ℜ_nn // y::ℜ_nn = ℜ_nn(x.x // y.x)

    # Subtraction of ℜ_nn is not necessarily nonnegative
    x::ℜ_nn - y::ℜ_nn = x.x - y.x

    # Convert rℜ_nn to ℜ_nn(r)
    *(r::ℜ, ::Type{ℜ_nn}) = ℜ_nn(r)

    # Unbox the the real to promote
    promote_rule(r::Type{<: ℜ}, ::Type{ℜ_nn{R}}) where R = promote_type(r, R)
    # If the boxed type and the real are the same
    # promote_rule(r::Type{R}, ::Type{ℜ_nn{R}}) where R <: Real = R

    # Impelement Heron's algorithm

    # Convert all arguments to ℜ_nn
    heron(args::ℜ...) = heron(ℜ_nn.(args)...)

    # Dispatch on abs(x-e^2) < ϵ)
    heron(x::ℜ_nn, ϵ::ℜ_nn, e::ℜ_nn = 1) =
        heron(x, ϵ, e, Val(abs(x-e^2) < ϵ))
    
    # abs(x-e^2) < ϵ
    heron(x::ℜ_nn, ϵ::ℜ_nn, e::ℜ_nn, ::Val{true}) = e

    # abs(x-e^2) >= ϵ
    heron(x::ℜ_nn, ϵ::ℜ_nn, e::ℜ_nn, ::Val{false}) =
        heron(x, ϵ, (e + (x / e))/2ℜ_nn)
    # Use Rationals when possible
    heron(
        x::ℜ_nn{<: Union{Integer,Rational}},
        ϵ::ℜ_nn,
        e::ℜ_nn{<: Union{Integer, Rational}},
        ::Val{false}
    ) = heron(x, ϵ, (e + (x // e))//2ℜ_nn)

end