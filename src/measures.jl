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

# An AbstractMeasure can be divided by a Number, but not vice versa
x::AbstractMeasure / y = value(x) / y

# An AbstractMeasure can be multiplied by a Number
x::AbstractMeasure * y = value(x) * y
# Multiplication of AbstractMeasures is commutative
x * y::AbstractMeasure = y * x

# Methods for log and sqrt
log(x::AbstractMeasure) = log(value(x))
log1p(x::AbstractMeasure) = log1p(value(x))
sqrt(x::AbstractMeasure) = sqrt(value(x))

end