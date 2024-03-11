module SRQ

export ICD10,
       AbstractMeasure,
       Objective,
       Subjective,
       Constant,
       value,
       AbstractComposite,
       DAS28CRP, 
       DAS28ESR, 
       AbstractDAS28,
       SDAI,
       weigh,
       evaluate,
       decompose,
       collapse,
       cut,
       cat_johan

include("diagnoses.jl")
using .Diagnoses

include("measures.jl")
using .Measures

include("composites.jl")
using .Composites

include("cutoffs.jl")
using .Cutoffs

end
