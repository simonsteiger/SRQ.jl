module Measures

export AbstractMeasure, SubjectiveMeasure, ObjectiveMeasure, Constant, value

abstract type AbstractMeasure end

struct SubjectiveMeasure <: AbstractMeasure
    value::Real
end

struct ObjectiveMeasure <: AbstractMeasure
    value::Real
end

struct Constant <: AbstractMeasure
    value::Real
end

import Base: +, -, *, /, sqrt, log, log1p

value(x::AbstractMeasure) = x.value
value(x) = x

# Addition of two AbstractMeasures is adding their values
x::AbstractMeasure + y::AbstractMeasure = value(x) + value(y)

# Difference of two AbstractMeasures is subtracting their values
x::AbstractMeasure - y::AbstractMeasure = value(x) - value(y)

# An AbstractMeasure can be divided by a Real, but not vice versa
x::AbstractMeasure / y::Real = value(x) / y

# An AbstractMeasure can be multiplied by a Real
x::AbstractMeasure * y::Real = value(x) * y
# Multiplication of AbstractMeasures is commutative
x::Real * y::AbstractMeasure = y * x

# Methods for log and sqrt
log(x::AbstractMeasure) = log(value(x))
log1p(x::AbstractMeasure) = log1p(value(x))
sqrt(x::AbstractMeasure) = sqrt(value(x))

end