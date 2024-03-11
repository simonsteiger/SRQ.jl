module Diagnoses

export ICD10

"""
A Dict holding pairs of ICD10 codes and their corresponding disease category.

Typically used for recoding `diagnoskod_1` to a coarser categorization.
```
[haskey(ICD10, x) ? ICD10[x] : x for x in diagnoskod_1]
```
"""
ICD10 = Dict(
    "M05.3"         => "RA",
    "M05.8L"        => "RA",
    "M05.8M"        => "RA",
    "M05.8N"        => "RA",
    "M05.9"         => "RA",
    "M05.9L"        => "RA",
    "M05.9M"        => "RA",
    "M05.9N"        => "RA",
    "M06.0"         => "RA",
    "M06.0L"        => "RA",
    "M06.0M"        => "RA",
    "M06.0N"        => "RA",
    "M06.8L"        => "RA",
    "M06.8M"        => "RA",
    "M06.8N"        => "RA",
    "M06.9"         => "RA",
    # "M12.3"       => "RA", # Intentionally missing!
    "M07.0"         => "PsA",
    "M07.1"         => "PsA",
    "M07.2"         => "PsA",
    "M07.3x+L40.5"  => "PsA",
    "M09.0"         => "PsA",
    "M07.0+L40.5"   => "PsA",
    "M07.1+L40.5"   => "PsA",
    "M07.2+L40.5"   => "PsA",
    "M46.8"         => "SpA",
    "M46.9"         => "SpA",
    "M08.1"         => "SpA",
    "M31.5"         => "GCA",
    "M31.6"         => "GCA",
    "M35.3"         => "GCA",
    "M13.0"         => "Poly-/Oligoarthritis",
    "M13.8"         => "Poly-/Oligoarthritis",
    "M45.9"         => "AS",
    "M32.9"         => "SLE",
    "M08.9"         => "JIA",
    "M60.9"         => "Myositis",
    "M10.9"         => "Gout",
    )
end