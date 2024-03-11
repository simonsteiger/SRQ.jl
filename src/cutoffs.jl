module Cutoffs

export cut

using ..Composites

# TODO use composite and add conditional evaluation if value is missing
"""
    cut(c::AbstractDAS28)

Convert a DAS28 score into a categorical variable.

```julia-repl
julia> x = DAS28ESR(4, 5, 12, 44)
julia> cut(x)
> "Moderate"
```
"""
function cut(c::AbstractDAS28)
    value = evaluate(c)
    if c isa DAS28CRP
        value < 2.5 ? "Remission" :
        value ≤ 2.9 ? "Low"       :
        value ≤ 4.6 ? "Moderate"  :
                      "High"
    else
        value < 2.6 ? "Remission" :
        value ≤ 3.2 ? "Low"       :
        value ≤ 5.1 ? "Moderate"  :
                      "High"
    end
end

"Convert an SDAI score into a categorical variable."
function cut(c::SDAI)
    value = evaluate(c)
    value <  3.3 ? "Remission" :
    value ≤ 11.0 ? "Low"       :
    value ≤ 26.0 ? "Moderate"  :
                   "High"
    
end

end
