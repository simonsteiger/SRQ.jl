# Define measures to use for tests
t28 = SubjectiveMeasure(4)
s28 = ObjectiveMeasure(5)
pga = SubjectiveMeasure(12)
ega = ObjectiveMeasure(7)
inf = ObjectiveMeasure(44)

# Define composites to use for test
cDAS28ESR, cDAS28CRP = map([DAS28ESR, DAS28CRP]) do T
    T(t28, s28, pga, inf)
end

# Define composite without AbstractMeasures
cDAS28ESR_notype = DAS28ESR(4, 5, 12, 44)

cSDAI = SDAI(t28, s28, pga, ega, inf)