module Composites

export Composite,
    AbstractMeasure,
    DAS28,
    DAS28CRP,
    DAS28ESR,
    SDAI,
    weigh,
    score,
    decompose,
    collapse

using ..Measures

# TODO might want to add a test dict instead of copying the code for each struct, checking if, e.g., joints are between 0 and 28
# TODO define length method for Composite would allow broadcasting

abstract type Composite end
abstract type DAS28 <: Composite end # This would be a subtype of ContinuousComposite then
abstract type CompositeStyle end
struct IsContinuous <: CompositeStyle end
struct IsBoolean <: CompositeStyle end

# Default composite is continuous
CompositeStyle(::Type) = IsContinuous()

# Some composites are Boolean
# CompositeStyle(::Type{<:BooleanRemission}) = IsBoolean()

# score() should throw an error on IsBoolean styles and reference cut()


"""
    DAS28CRP(t28, s28, pga, inf)

Store component measures of DAS28CRP.

# Example

```julia-repl
julia> DAS28CRP(4, 5, 12, 44)
> DAS28CRP(4.0, 5.0, 12.0, 44.0)
```
"""
struct DAS28CRP <: DAS28 # TODO fields are Any right now, poor for performance!
    t28
    s28
    pga
    inf
    function DAS28CRP(t28, s28, pga, inf)
        foreach(jc -> Base.isbetween(0, value(jc), 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, value(pga), 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        value(inf) >= 0 || throw(DomainError(inf, "ESR must be positive."))
        return new(t28, s28, pga, inf)
    end
end

"""
    DAS28ESR(t28, s28, pga, inf)

Store component measures of DAS28ESR.

# Example

```julia-repl
julia> DAS28ESR(4, 5, 12, 44)
> DAS28ESR(4.0, 5.0, 12.0, 44.0)
```
"""
struct DAS28ESR <: DAS28 # TODO fields are Any right now, poor for performance!
    t28
    s28
    pga
    inf
    function DAS28ESR(t28, s28, pga, inf)
        foreach(jc -> Base.isbetween(0, value(jc), 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, value(pga), 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        value(inf) >= 0 || throw(DomainError(inf, "ESR must be positive."))
        return new(t28, s28, pga, inf)
    end
end


"""
    SDAI(t28, s28, pga, ega, crp)

Store component measures of SDAI.

# Example

```julia-repl
julia> SDAI(4, 5, 12, 5, 44)
> SDAI(4.0, 5.0, 12.0, 5.0, 44.0)
```
"""
struct SDAI <: Composite # TODO fields are Any right now, poor for performance!
    t28
    s28
    pga
    ega
    crp
    function SDAI(t28, s28, pga, ega, crp)
        foreach(jc -> Base.isbetween(0, value(jc), 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, value(pga), 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        # TODO add check for ega
        value(crp) >= 0 || throw(DomainError(crp, "CRP must be positive."))
        return new(t28, s28, pga, ega, crp)
    end
end

components(c::T) where {T<:Composite} = getproperty.(Ref(c), fieldnames(T))

Base.show(io::IO, z::T) where {T<:Composite} = print(io, "$T$(Pair.(fieldnames(T), components(z)))")

"Return intercept of a specific score."
intercept(c::DAS28CRP) = 0.96

"If the specified score has no intercept, return 0."
intercept(c::Composite) = 0.0


"""
    weigh(c::T, v::Symbol)

Calculate the degree to which score `s` is made up of component `v`. The weighed components of `s` sum to 1.

# Example

```julia-repl
julia> weigh(DAS28CRP(4, 5, 12, 44), :pga)
> 0.168
```
"""
weigh(c::T, v) where {T} = weigh(CompositeStyle(T), c, v)

function weigh(::IsContinuous, c::DAS28, v::Symbol)
    x = getproperty(c, v)
    v == :t28 ? √(x) * 0.56 :
    v == :s28 ? √(x) * 0.28 :
    v == :pga ? x * 0.014 :
    c isa DAS28CRP ? log1p(x) * 0.36 :
    log(x) * 0.7
end

"If no weight is defined, return the value of the specified property."
weigh(::IsContinuous, c::Composite, v::Symbol) = value(getproperty(c, v))

"Throw an error if a boolean composite is weighed."
weigh(::IsBoolean, c::Composite, v::Symbol) = error("Boolean composites cannot be weighed.")

"""
    score(c::T)

Calculate the value of an `Composite`.
   
> For more detail on the formulas, see the following links:
> - DAS28: https://www.4s-dawn.com/DAS28/.

# Example

```julia-repl
julia> score(DAS28ESR(4, 2, 64, 44))
> 5.061
```
"""
function score(c::T; digits=3) where {T<:Composite}
    value = intercept(c) + mapreduce(x -> weigh(c, x), +, fieldnames(T))
    return round(value, digits=digits)
end

# Get denominator of Composite
_denom(c::Composite; digits=3) = score(c, digits=digits) - intercept(c)

# Summarise subcomponents of a concrete DAS28 type into subjective and objective dimensions
function _dimsum(c::Composite, d)
    nms = fieldnames(typeof(c))
    types = typeof.([getproperty(c, x) for x in nms])
    any((<:).(types, AbstractMeasure)) || throw("All fields of Composite `c` must be AbstractMeasures.")
    obj = nms[types .== ObjectiveMeasure]
    sub = nms[types .== SubjectiveMeasure]
    return sum([d[x] for x in sub]), sum([d[x] for x in obj])
end

# From a single score, create two scores where for each score one of the dimensions is at its maximum
# Assumes two dimensions currently, and only implemented for DAS28 anyway
# Do we want a collapsable and uncollapsable style? See holy trait pattern
_submax(c::DAS28) = [SubjectiveMeasure(28), c.s28, SubjectiveMeasure(100), c.inf] 
_objmax(c::DAS28CRP) = [c.t28, ObjectiveMeasure(28), c.pga, ObjectiveMeasure(1000)]
_objmax(c::DAS28ESR) = [c.t28, ObjectiveMeasure(28), c.pga, ObjectiveMeasure(300)] 
_setmax(c::Composite) = _submax(c), _objmax(c)


"""
    decompose(c::T)

Calculate the degree to which the components of Composite `c` contribute to its value. The resulting decomposition sums to 1.

# Example

```julia-repl
julia> decompose(DAS28ESR(4, 12, 44, 2))
> Dict{Symbol, Float64} with 4 entries:
  :s28 => 0.304
  :pga => 0.193
  :inf => 0.152
  :t28 => 0.351
```
"""
function decompose(c::T; digits=3) where {T<:Composite}
    decomp = weigh.(Ref(c), fieldnames(T)) ./ _denom(c, digits=digits)
    return Dict(Pair.(fieldnames(T), decomp))
end


"""
    collapse(c::T; adjusted=false, digits=3) -> (; raw_s, raw_o)

For Composites made up of several dimensions, calculate the degree to which they are made up of each dimension. The unadjusted result sums to 1, but the adjusted one does not.

- `adjust` sets each ratio in relation to its theoretical upper bound given the other dimensions component values. The default is `false`.
- `digits` controls the number of significant digits to which the result is calculated. The default is 3.

# Examples

```julia-repl
julia> c = DAS28ESR(4, 5, 12, 44)
> DAS28ESR(4.0, 5.0, 12.0, 44.0)

julia> collapse(c)
> (raw_s = 0.282, raw_o = 0.718)

julia> collapse(c; adjust=true)
> (adj_s = 0.494, adj_o = 0.887)
```
"""
function collapse(c::T; adjust=false, digits=3) where {T<:Composite}
    raw_s, raw_o = _dimsum(c, decompose(c, digits=digits))
    !adjust && return Dict(Pair.(["sub_raw", "obj_raw"], [raw_s, raw_o]))
    max_s, max_o = _dimsum.(Ref(c), decompose.(map(x -> T(x...), _setmax(c))))
    adj_s, adj_o = [r / m for (r, m) in zip([raw_s, raw_o], [max_s[1], max_o[2]])]
    return Dict(Pair.(["sub_adj", "obj_adj"], [adj_s, adj_o]))
end

end