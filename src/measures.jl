module Measures

export AbstractMeasure, Subjective, Objective, Constant, value

abstract type AbstractMeasure end

struct Subjective <: AbstractMeasure
    value::Real
end

struct Objective <: AbstractMeasure
    value::Real
end

struct Constant <: AbstractMeasure
    value::Real
end

import Base: +, -, *, /, sqrt, log, log1p

value(x::AbstractMeasure) = x.value

# Basic arithmetic for two AbstractMeasures
x::AbstractMeasure + y::AbstractMeasure = value(x) + value(y)
x::AbstractMeasure - y::AbstractMeasure = value(x) - value(y)
x::AbstractMeasure / y = value(x) / y
x::AbstractMeasure * y = value(x) * y
x * y::AbstractMeasure = x * value(y)

# Only AbstractMeasures can be added or subtracted
# They can only be multiplied or divided by Reals

# Methods for log and sqrt
log(x::AbstractMeasure) = log(value(x))
log1p(x::AbstractMeasure) = log1p(value(x))
sqrt(x::AbstractMeasure) = sqrt(value(x))

end