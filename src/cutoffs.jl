module Cutoffs

export cutoff

using ..Composites

# TODO document the cutoffs in some exported object (dict?)
"Helper function containing the cutoffs for DAS28CRP"
function _cut(::Type{DAS28CRP}, v::Real)
    v < 2.4 ? "Remission" :
    v ≤ 2.9 ? "Low" :
    v ≤ 4.6 ? "Moderate" : "High"
end

"Helper function containing the cutoffs for DAS28ESR"
function _cut(::Type{DAS28ESR}, v::Real)
    v < 2.6 ? "Remission" :
    v ≤ 3.2 ? "Low" :
    v ≤ 5.1 ? "Moderate" : "High"
end

"Helper function containing the cutoffs for SDAI"
function _cut(::Type{SDAI}, v::Real)
    v < 3.3 ? "Remission" :
    v ≤ 11.0 ? "Low" :
    v ≤ 26.0 ? "Moderate" :
    "High"
end

# TODO use composite and add conditional evaluation if value is missing
"""
    cutoff(c::Composite)

Convert the score of a composite `c` into a categorical variable.

```julia-repl
julia> x = DAS28ESR(4, 5, 12, 44)
julia> cutoff(x)
> "Moderate"
```

    cutoff(v::Real, T::DAS28)

Convert a DAS28 score `v` into a categorical variable according to the cutoffs for type `T`.

```julia-repl
julia> cutoff(5.4, DAS28CRP)
> "High"
```
"""
cutoff(c::Composite) = _cut(typeof(c), score(c))
cutoff(v::Real, ::Type{T}) where {T<:Composite} = _cut(T, v)
# TODO this dispatch could probably be much more general
# It should first work on any Composite and then fork into DAS28
# But we need an infrastructure that also elegantly handles, e.g., SDAI dispatch and is easily extensible beyond that
# It could be nice to solve this with a function that takes a dict _cutwithdict and uses the dict dependent on which type was passed?

end
