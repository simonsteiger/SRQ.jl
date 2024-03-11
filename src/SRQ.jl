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

include("Diagnoses.jl")
using .Diagnoses

include("Measures.jl")
using .Measures

include("Composites.jl")
using .Composites

include("Cutoffs.jl")
using .Cutoffs

end
