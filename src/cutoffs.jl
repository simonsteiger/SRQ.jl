module Cutoffs

export cut,
       cat_johan

using ..Composites

# TODO use composite and add conditional evaluation if value is missing
"Convert a DAS28 score into a categorical variable."
function cut(c::T) where T<:AbstractDAS28
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

"""
This dictionary stores the cutoffs for the categories proposed by Johan in Study 1 of my PhD.

Lower are compared with ≤ "less-or-equal", moderate are inclusive of both limits, i.e. `lower ≤ x ≤ upper` and high values are ≥ "greater-or-equal".

For ESR values, add 10 for female sex and age > 60, respectively, i.e., females > 60 get +20.
"""
cat_johan = Dict(
    "t28"      =>   [1, 4],
    "s28"      =>   [1, 4],
    "pgh"      => [20, 40],
    "pain"     => [20, 40],
    "fatigue"  => [20, 40],
    "crp"      => [10, 29],
    "esr"      => [10, 39],
)

end
