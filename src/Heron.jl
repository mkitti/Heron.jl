"""
    Implement Heron's algorithm for computing square roots

    Inspired by Konrad Hinsen's discussion of the algorithm in this video
    https://www.youtube.com/watch?v=f10NpsMmbis
"""
module Heron

    import Base: +, ^, -, *, /, //, promote_rule
    export ℜ, ℜ⁰⁺, heron
    export NonNegativeReal

    # Alias Real as ℜ
    const ℜ = Real

    # Non-negative real type boxes a real
    # \re[tab] = ℜ 
    # \^0[tab] = ⁰
    # \^+[tab] = ⁺
    struct ℜ⁰⁺{R} <: ℜ
        x::R
        # Check non-negativity on construction
        ℜ⁰⁺(x::R) where R <: ℜ = ℜ⁰⁺{R}(x)

        ℜ⁰⁺{R}(x::R) where R <: ℜ = x >= 0 ?
            new{R}(x) :
            throw(ArgumentError("x must be nonnegative"))
    end

    const NonNegativeReal = ℜ⁰⁺

    # Type conversion

    # Converting a ℜ⁰⁺ to ℜ⁰⁺ is just the identity
    ℜ⁰⁺(r⁰⁺::ℜ⁰⁺) = r⁰⁺

    # To convert ℜ to ℜ⁰⁺, call the constructor
    convert(::Type{ℜ⁰⁺}, x::ℜ) = ℜ⁰⁺(x)

    # To convert a ℜ⁰⁺ to ℜ convert the boxed type
    (::Type{R})(r⁰⁺::ℜ⁰⁺) where R <: ℜ = R(r⁰⁺.x)
    convert(::Type{R}, x::ℜ⁰⁺) where R <: ℜ = convert(R, x.x)

    # ℜ⁰⁺ is closed over +, ^, / , //
    x::ℜ⁰⁺ + y::ℜ⁰⁺ = ℜ⁰⁺(x.x + y.x)
    x::ℜ⁰⁺ ^ n::Int = ℜ⁰⁺(x.x^n)
    x::ℜ⁰⁺ / y::ℜ⁰⁺ = ℜ⁰⁺(x.x / y.x)
    x::ℜ⁰⁺ // y::ℜ⁰⁺ = ℜ⁰⁺(x.x // y.x)

    # Subtraction of ℜ⁰⁺ is not necessarily nonnegative
    x::ℜ⁰⁺ - y::ℜ⁰⁺ = x.x - y.x

    # Convert rℜ⁰⁺ to ℜ⁰⁺(r)
    *(r::ℜ, ::Type{ℜ⁰⁺}) = ℜ⁰⁺(r)

    # Unbox the the real to promote
    promote_rule(r::Type{<: ℜ}, ::Type{ℜ⁰⁺{R}}) where R = promote_type(r, R)
    # If the boxed type and the real are the same
    # promote_rule(r::Type{R}, ::Type{ℜ⁰⁺{R}}) where R <: Real = R

    # Implement Heron's algorithm

    # Convert all arguments to ℜ⁰⁺
    heron(args::ℜ...) = heron(ℜ⁰⁺.(args)...)

    # Dispatch on abs(x-e^2) < ϵ)
    heron(x::ℜ⁰⁺, ϵ::ℜ⁰⁺, e::ℜ⁰⁺ = 1) =
        heron(x, ϵ, e, Val(abs(x-e^2) < ϵ))
    
    # abs(x-e^2) < ϵ
    heron(x::ℜ⁰⁺, ϵ::ℜ⁰⁺, e::ℜ⁰⁺, ::Val{true}) = e

    # abs(x-e^2) >= ϵ
    heron(x::ℜ⁰⁺, ϵ::ℜ⁰⁺, e::ℜ⁰⁺, ::Val{false}) =
        heron(x, ϵ, (e + (x / e))/2ℜ⁰⁺)
    # Use Rationals when possible
    heron(
        x::ℜ⁰⁺{<: Union{Integer,Rational}},
        ϵ::ℜ⁰⁺,
        e::ℜ⁰⁺{<: Union{Integer, Rational}},
        ::Val{false}
    ) = heron(x, ϵ, (e + (x // e))//2ℜ⁰⁺)

end