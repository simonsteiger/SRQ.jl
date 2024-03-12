module SRQ

export ICD10,
       AbstractMeasure,
       ObjectiveMeasure,
       SubjectiveMeasure,
       Constant,
       AbstractComposite,
       AbstractDAS28,
       DAS28CRP, 
       DAS28ESR,
       SDAI,
       value,
       weigh,
       score,
       decompose,
       collapse,
       cut

include("diagnoses.jl")
using .Diagnoses

include("measures.jl")
using .Measures

include("composites.jl")
using .Composites

include("cutoffs.jl")
using .Cutoffs

end
