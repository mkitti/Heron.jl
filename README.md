# Heron.jl

This is an implementation of [Heron's method of computing square roots](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method) in the [Julia Programming Language](https://www.julialang.org).

This is primarily meant to see how such a method could be modeled in Julia while also playing with Julia's Unicode features.

## Heron's Method

Suppose that we have a non-negative real value, $ x $ and we want to find the non-negative real value, $ \sqrt{x} $. We can start with an estimate for $ \sqrt{x} $, $ e_n $.
The error, $ \epsilon $, is defined as $ \epsilon = \sqrt{x} - e_n $. Therefore, $ (e_n + \epsilon )^2 = x $.

We see that that $ \epsilon^2 + 2e_n\epsilon = x - e_n^2 $. Since $ \epsilon $ should become asymptotically smaller than $ e_n $, we can make the following approximation.

$$ \epsilon = \frac{x-e_n^2}{\epsilon + 2e_n} \approx  \frac{x-e_n^2}{2e_n} = \frac{x}{2e_n} - \frac{e_n}{2} $$

We can then update our estimate, but compensating by the approximation for the error.

$$ e_{n+1} = e_n + \epsilon = \frac{x}{2e_n} + \frac{e_n}{2} $$

## Implementation

1. I first create a type, `ℜ⁰⁺`, aliased as `NonNegativeReal` that represents real values greater than or equal to 0. The constructor enforces the non-negative condition.
2. I overload a few operations, $ +, - , ^ $ for `ℜ⁰⁺` and use Julia's type conversion and promotion system so that we can easily do arithmetic on the new type.
3. The entry method, `heron(x, ϵ, e = 1)` takes arguments for 1) the value whose square root is to be found, 2) the acceptable error to stop the iteration, and 3) optionally, a starting estimate, defaulting to `1`.
4. The `heron` method then dispatches on whether the iteration stop condition, `abs(x - e^2) < ϵ`, is met. If met, then just return `e`. Otherwise, update the estimate as described above.
5. The method is meant to accept arguments  of type `ℜ⁰⁺`, but will try to convert any provided arguments to the type.
6. When possible, `Rational` is used to express the estimated square root as a fraction.

## Inspiration

This was inspired by Konrad Hinsen's discussion of the topic for digital scientific notation [Leibniz](https://khinsen.net/leibniz-examples/):
https://khinsen.net/leibniz-examples/examples/heron.html

A video of Konran Hinsen discussing Leibniz and Heron's algorithm can be found here in a discussion of Glamorous Toolkit, a multi-language notebook:
https://www.youtube.com/watch?v=f10NpsMmbis

The objective here is not to implement Leibniz or a Leibniz processor in Julia. Rather the purpose is to demonstrate how Julia can be used to express the rules in a syntax that looks reminscent of Leibniz through the use of Unicode symbols, type conversion and promotion, operating overloading, and multiple dispatch.

Based on this, perhaps Julia would be an interesting language to read Leibniz since Julia expressions can be made to look similar to Leibniz.

## License

This code is licensed under a MIT license.