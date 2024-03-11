module Composites

export AbstractComposite,
    AbstractMeasure,
    AbstractDAS28,
    DAS28CRP,
    DAS28ESR,
    SDAI,
    weigh,
    evaluate,
    decompose,
    collapse

using ..Measures

abstract type AbstractComposite end
abstract type AbstractDAS28 <: AbstractComposite end

"""
    DAS28CRP(t28, s28, pga, inf)

Store component measures of DAS28CRP.

# Example

```julia-repl
julia> DAS28CRP(4, 5, 12, 44)
> DAS28CRP(4.0, 5.0, 12.0, 44.0)
```
"""
struct DAS28CRP <: AbstractDAS28
    t28::Subjective
    s28::Objective
    pga::Subjective
    inf::Objective
    # consider forcing all of these to be kwargs to avoid unintentional errors
    function DAS28CRP(t28, s28, pga, inf)
        foreach(jc -> Base.isbetween(0, jc, 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, pga, 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        inf >= 0 || throw(DomainError(inf, "CRP must be positive."))
        return new(Subjective(t28), Objective(s28), Subjective(pga), Objective(inf))
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
struct DAS28ESR <: AbstractDAS28
    t28::Subjective
    s28::Objective
    pga::Subjective
    inf::Objective
    # consider forcing all of these to be kwargs to avoid unintentional errors
    function DAS28ESR(t28, s28, pga, inf)
        foreach(jc -> Base.isbetween(0, jc, 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, pga, 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        inf >= 0 || throw(DomainError(inf, "ESR must be positive."))
        return new(Subjective(t28), Objective(s28), Subjective(pga), Objective(inf))
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
struct SDAI <: AbstractComposite
    t28::Subjective
    s28::Objective
    pga::Subjective
    ega::Objective
    crp::Objective
    function SDAI(t28, s28, pga, ega, crp)
        foreach(jc -> Base.isbetween(0, jc, 28) || throw(DomainError(jc, "joint counts must be between 0 and 28.")), [t28, s28])
        Base.isbetween(0, pga, 100) || throw(DomainError(pga, "VAS global must be between 0 and 100."))
        # TODO add check for ega
        crp >= 0 || throw(DomainError(crp, "CRP must be positive."))
        return new(Subjective(t28), Objective(s28), Subjective(pga), Objective(ega), Objective(crp))
    end
end

components(c::T) where {T<:AbstractComposite} = getproperty.(Ref(c), fieldnames(T))

Base.show(io::IO, z::T) where {T<:AbstractComposite} = print(io, "$T$(Pair.(fieldnames(T), components(z)))")

"Return intercept of a specific score."
intercept(c::DAS28CRP) = 0.96

"If the specified score has no intercept, return 0."
intercept(c::AbstractComposite) = 0.0


"""
    weigh(c::T, v::Symbol)

Calculate the degree to which score `s` is made up of component `v`. The weighed components of `s` sum to 1.

# Example

```julia-repl
julia> weigh(DAS28CRP(4, 5, 12, 44), :pga)
> 0.168
```
"""
function weigh(c::AbstractDAS28, v::Symbol)
    x = getproperty(c, v)
    v == :t28 ? √(x) * 0.56 :
    v == :s28 ? √(x) * 0.28 :
    v == :pga ? x * 0.014 :
    c isa DAS28CRP ? log1p(x) * 0.36 :
    log(x) * 0.7
end

"If no weight is defined, return the value of the specified property."
weigh(c::AbstractComposite, v::Symbol) = value(getproperty(c, v))


"""
    evaluate(c::T)

Calculate the value of an `AbstractComposite`.
   
> For more detail on the formulas, see the following links:
> - DAS28: https://www.4s-dawn.com/DAS28/.

# Example

```julia-repl
julia> evaluate(DAS28ESR(4, 2, 64, 44))
> 5.061
```
"""
function evaluate(c::T; digits=3) where {T<:AbstractComposite}
    value = mapreduce(x -> weigh(c, x), +, fieldnames(T))
    value += intercept(c)
    return round(value, digits=digits)
end

# Get denominator for concrete DAS28 type
_denom(c::T; digits=3) where {T<:AbstractComposite} = c isa DAS28CRP ? evaluate(c, digits=digits) - intercept(c) : evaluate(c, digits=digits)

# Summarise subcomponents of a concrete DAS28 type into subjective and objective dimensions
_dimsum(d) = d[:t28] + d[:pga], d[:s28] + d[:inf]
# TODO needs to make type inference if further Composites arrive
# This may be possible by storing the decomposition in a parametric struct?

# From a single score, create two scores where for each score one of the dimensions is at its maximum
# Assumes two dimensions currently, and only implemented for DAS28 anyway
# TODO extend support to other types – we probably cannot dispatch on AbstractComposite
_setmax(c::T) where {T<:AbstractComposite} = [28, c.s28, 100, c.inf], [c.t28, 28, c.pga, c isa DAS28CRP ? 1000 : 300]


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
function decompose(c::T; digits=3) where {T<:AbstractComposite}
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
function collapse(c::T; adjust=false, digits=3) where {T<:AbstractComposite}
    raw_s, raw_o = _dimsum(decompose(c, digits=digits))
    !adjust && return Dict(Pair.(["obj_raw", "sub_raw"], [raw_s, raw_o]))
    max_s, max_o = _dimsum.(decompose.(map(x -> T(x...), _setmax(c))))
    adj_s, adj_o = [r / m for (r, m) in zip([raw_s, raw_o], [max_s[1], max_o[2]])]
    return Dict(Pair.(["obj_adj", "sub_adj"], [adj_s, adj_o]))
end

end