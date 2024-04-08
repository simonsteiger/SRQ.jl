module Cutoffs

export cut

using ..Composites

# TODO document the cutoffs in some exported object (dict?)
"Helper function containing the cutoffs for DAS28CRP"
function _cutdas28crp(v::Real)
    v < 2.5 ? "Remission" :
    v ≤ 2.9 ? "Low" :
    v ≤ 4.6 ? "Moderate" : "High"
end

"Helper function containing the cutoffs for DAS28ESR"
function _cutdas28esr(v::Real)
    v < 2.6 ? "Remission" :
    v ≤ 3.2 ? "Low" :
    v ≤ 5.1 ? "Moderate" : "High"
end

# TODO use composite and add conditional evaluation if value is missing
"""
    cut(c::AbstractDAS28)

Convert the score of a DAS28 composite `c` into a categorical variable.

```julia-repl
julia> x = DAS28ESR(4, 5, 12, 44)
julia> cut(x)
> "Moderate"
```

    cut(v::Real, T::AbstractDAS28)

Convert a DAS28 score `v` into a categorical variable according to the cutoffs for type `T`.

```julia-repl
julia> cut(5.4, DAS28CRP)
> "High"
```
"""
cut(c::AbstractDAS28) = c isa DAS28CRP ? _cutdas28crp(score(c)) : _cutdas28esr(score(c))
cut(v::Real, ::Type{T}) where {T<:AbstractDAS28} = T == DAS28CRP ? _cutdas28crp(v) : _cutdas28esr(v)
# TODO this dispatch could probably be much more general
# It should first work on any AbstractComposite and then fork into AbstractDAS28
# But we need an infrastructure that also elegantly handles, e.g., SDAI dispatch and is easily extensible beyond that
# It could be nice to solve this with a function that takes a dict _cutwithdict and uses the dict dependent on which type was passed?

"""
    cut(c::SDAI)

Convert an SDAI score into a categorical variable.

```julia-repl
julia> x = SDAI(4, 5, 12, 4, 23)
julia> cut(x)
> "High"
```
"""
function cut(c::SDAI)
    value = score(c)
    value < 3.3 ? "Remission" :
    value ≤ 11.0 ? "Low" :
    value ≤ 26.0 ? "Moderate" :
    "High"
end

end
