; parameters: phosphorus, phosphate, ammonia, kjeldahl-nitrogen, chlorophyll-a, nitrogen-phosphorus-ratio, calcium-carbonate, temperature, ph, dissolved oxygen, turbidity
globals [
    min-mean-phosphorus
    max-mean-phosphorus
    min-stdev-phosphorus
    max-stdev-phosphorus

    min-mean-phosphate
    max-mean-phosphate
    min-stdev-phosphate
    max-stdev-phosphate

    min-mean-ammonia
    max-mean-ammonia
    min-stdev-ammonia
    max-stdev-ammonia

    min-mean-kjeldahl-nitrogen
    max-mean-kjeldahl-nitrogen
    min-stdev-kjeldahl-nitrogen
    max-stdev-kjeldahl-nitrogen

    min-mean-chlorophyll-a
    max-mean-chlorophyll-a
    min-stdev-chlorophyll-a
    max-stdev-chlorophyll-a

    min-mean-nitrogen-phosphorus-ratio
    max-mean-nitrogen-phosphorus-ratio
    min-stdev-nitrogen-phosphorus-ratio
    max-stdev-nitrogen-phosphorus-ratio

    min-mean-calcium-carbonate
    max-mean-calcium-carbonate
    min-stdev-calcium-carbonate
    max-stdev-calcium-carbonate

    min-mean-temperature
    max-mean-temperature
    min-stdev-temperature
    max-stdev-temperature

    min-mean-ph
    max-mean-ph
    min-stdev-ph
    max-stdev-ph

    min-mean-do         ; dissolved oxygen
    max-mean-do  
    min-stdev-do
    max-stdev-do

    min-mean-turbidity
    max-mean-turbidity
    min-stdev-turbidity
    max-stdev-turbidity

    total-npp
]
end

; Create the 5 phytoplankton species
breed [anabaena anabaena]
breed [chlorogonium chlorogonium]
breed [nitzschia nitzschia]
breed [scenedesmus scenedesmus]
breed [trachelomonas trachelomonas]

patches-own [
    ca

    ;; each patch has a value for each of these parameters
    ;; each tick, each turle gets the value of the parameter from the patch it is on,
    ;; and then uses that to calculate its growth rate and biomass
    ;; these three values are then used to calculate the 'Net Primary Production' (NPP) of the turtle
    ;; NPP essentially represents how much C02 the turtle is sequestering from the atmosphere
    phosphorus
    phosphate
    ammonia
    kjeldahl-nitrogen
    chlorophyll-a
    nitrogen-phosphorus-ratio
    calcium-carbonate
    temperature
    ph
    dissolved-oxygen
    turbidity
]
end

turtle-own [
    ;; Species_NPP = growth-rate * biomass * max depth for photosynthesis to occur
    ;; Total_NPP = Sum of Species_NPP
    ;; Growth-rate and biomass are multiplied by proportion, which is calculated by 
    ;; taking the average of the normalcdf values for each parameter, 
    ;; where the z value is calculated with respect to the patch value 
    ;; and the mean and stdev associated with the species of the turtle
    ;; Thus, variables for means and stDevs of each parameter are set to each turtle 
    ;; and assigned based off species 
    growth-rate
    biomass
    npp
    proportion
    
    mean-phosphorus
    stdev-phosphorus

    mean-phosphate
    stdev-phosphate

    mean-ammonia
    stdev-ammonia

    mean-kjeldahl-nitrogen
    stdev-kjeldahl-nitrogen

    mean-chlorophyll-a
    stdev-chlorophyll-a

    mean-nitrogen-phosphorus-ratio
    stdev-nitrogen-phosphorus-ratio

    mean-calcium-carbonate
    stdev-calcium-carbonate

    mean-temperature
    stdev-temperature

    mean-ph
    stdev-ph

    mean-do     ; dissolved oxygen
    stdev-do

    mean-turbidity
    stdev-turbidity
]
end

setup [
    ca

    ;; set all parameters with values from dataset
    set min-mean-phosphorus 116.0
    set max-mean-phosphorus 271.0
    set min-stdev-phosphorus 5.9982
    set max-stdev-phosphorus 31.0858

    set min-mean-phosphate 41
    set max-mean-phosphate 147
    set min-stdev-phosphate 2.7153
    set max-stdev-phosphate 16.8621

    set min-mean-ammonia 108
    set max-mean-ammonia 128
    set min-stdev-ammonia 12.3884
    set max-stdev-ammonia 8.4770

    set min-mean-kjeldahl-nitrogen 975
    set max-mean-kjeldahl-nitrogen 1592
    set min-stdev-kjeldahl-nitrogen 50.4160
    set max-stdev-kjeldahl-nitrogen 182.6149

    set min-mean-chlorophyll-a 26.7
    set max-mean-chlorophyll-a 54.6
    set min-stdev-chlorophyll-a 1.3806
    set max-stdev-chlorophyll-a 6.2630

    set min-mean-nitrogen-phosphorus-ratio 9.7
    set max-mean-nitrogen-phosphorus-ratio 12.8
    set min-stdev-nitrogen-phosphorus-ratio 1.1127
    set max-stdev-nitrogen-phosphorus-ratio 0.6619

    set min-mean-calcium-carbonate 68
    set max-mean-calcium-carbonate 87
    set min-stdev-calcium-carbonate 3.6040
    set max-stdev-calcium-carbonate 9.9796

    set min-mean-temperature 21.6
    set max-mean-temperature 23.4
    set min-stdev-temperature 1.1169
    set max-stdev-temperature 1.2402

    set min-mean-ph 7.7
    set max-mean-ph 8.1
    set min-stdev-ph 0.5099
    set max-stdev-ph 0.9291

    set min-mean-do 7.4        ; dissolved oxygen
    set max-mean-do 7.8
    set min-stdev-do 0.3922
    set max-stdev-do 0.4033

    set min-mean-turbidity 62
    set max-mean-turbidity 75
    set min-stdev-turbidity 7.1119
    set max-stdev-turbidity 3.9750

    ask patches [
        ;; for each parameter, we want to generate a random number within 3 standard deviations of the mean (following the 68-95-99.7 rule)
        ;; (https://ccl.northwestern.edu/netlogo/bind/primitive/random-float.html)
        ;; If you want to generate a random number between a custom range, you can use the following format: minnumber + (random-float (maxnumber - minnumber)). 
        ;; For example, if we wanted to generate a random floating point number between 4 and 7, we would write the following code: 4 + random-float 3.
        ;; for parameter p:
        ;; minnumber = min-mean-p - 3(min-stdev-p) 
        ;; maxnumber = max-mean-p + 3(max-stdev-p)
        set phosphorus (min-mean-phosphorus - 3 * min-stdev-phosphorus) +  (random-float (max-mean-phosphorus + 3 * max-stdev-phosphorus - (min-mean-phosphorus - 3 * min-stdev-phosphorus))) 
        set phosphate (min-mean-phosphate - 3 * min-stdev-phosphate) +  (random-float (max-mean-phosphate + 3 * max-stdev-phosphate - (min-mean-phosphate - 3 * min-stdev-phosphate)))
        set ammonia (min-mean-ammonia - 3 * min-stdev-ammonia) +  (random-float (max-mean-ammonia + 3 * max-stdev-ammonia - (min-mean-ammonia - 3 * min-stdev-ammonia)))
        set kjeldahl-nitrogen (min-mean-kjeldahl-nitrogen - 3 * min-stdev-kjeldahl-nitrogen) +  (random-float (max-mean-kjeldahl-nitrogen + 3 * max-stdev-kjeldahl-nitrogen - (min-mean-kjeldahl-nitrogen - 3 * min-stdev-kjeldahl-nitrogen)))
        set chlorophyll-a (min-mean-chlorophyll-a - 3 * min-stdev-chlorophyll-a) +  (random-float (max-mean-chlorophyll-a + 3 * max-stdev-chlorophyll-a - (min-mean-chlorophyll-a - 3 * min-stdev-chlorophyll-a)))
        set nitrogen-phosphorus-ratio (min-mean-nitrogen-phosphorus-ratio - 3 * min-stdev-nitrogen-phosphorus-ratio) +  (random-float (max-mean-nitrogen-phosphorus-ratio + 3 * max-stdev-nitrogen-phosphorus-ratio - (min-mean-nitrogen-phosphorus-ratio - 3 * min-stdev-nitrogen-phosphorus-ratio)))
        set calcium-carbonate (min-mean-calcium-carbonate - 3 * min-stdev-calcium-carbonate) +  (random-float (max-mean-calcium-carbonate + 3 * max-stdev-calcium-carbonate - (min-mean-calcium-carbonate - 3 * min-stdev-calcium-carbonate)))
        set temperature (min-mean-temperature - 3 * min-stdev-temperature) +  (random-float (max-mean-temperature + 3 * max-stdev-temperature - (min-mean-temperature - 3 * min-stdev-temperature)))
        set ph (min-mean-ph - 3 * min-stdev-ph) +  (random-float (max-mean-ph + 3 * max-stdev-ph - (min-mean-ph - 3 * min-stdev-ph)))
        set dissolved-oxygen (min-mean-do - 3 * min-stdev-do) +  (random-float (max-mean-do + 3 * max-stdev-do - (min-mean-do - 3 * min-stdev-do)))
        set turbidity (min-mean-turbidity - 3 * min-stdev-turbidity) +  (random-float (max-mean-turbidity + 3 * max-stdev-turbidity - (min-mean-turbidity - 3 * min-stdev-turbidity)))
    ]

    ;; create 5 turtles of each species
    ;; each species' local variables are set to the values from the dataset
    create-anabaena 5 [
        set growth-rate 2
        set biomass 2
        set mean-phosphorus 127
        set stdev-phosphorus 6.7310
        set mean-phosphate 58
        set stdev-phosphate 3.0740
        set mean-ammonia 119
        set stdev-ammonia 6.3070
        set mean-kjeldahl-nitrogen 1138
        set stdev-kjeldahl-nitrogen 60.3139
        set mean-chlorophyll-a 28.5
        set stdev-chlorophyll-a 1.5105
        set mean-nitrogen-phosphorus-ratio 9.8
        set stdev-nitrogen-phosphorus-ratio 0.5194
        set mean-calcium-carbonate 68
        set stdev-calcium-carbonate 3.6040
        set mean-temperature 23.4
        set stdev-temperature 1.2402
        set mean-ph 7.8
        set stdev-ph 0.4134
        set mean-do 7.4        
        set stdev-do 0.3922
        set mean-turbidity 75
        set stdev-turbidity 3.9750
    ]

    create-chlorogonium 5 [
        set growth-rate 2
        set biomass 2
        set mean-phosphorus 271
        set stdev-phosphorus 31.0858
        set mean-phosphate 147
        set stdev-phosphate 16.8621
        set mean-ammonia 108
        set stdev-ammonia 12.3884
        set mean-kjeldahl-nitrogen 1592
        set stdev-kjeldahl-nitrogen 182.6149
        set mean-chlorophyll-a 54.6
        set stdev-chlorophyll-a 6.2630
        set mean-nitrogen-phosphorus-ratio 9.7
        set stdev-nitrogen-phosphorus-ratio 1.1127
        set mean-calcium-carbonate 87
        set stdev-calcium-carbonate 9.9796
        set mean-temperature 23
        set stdev-temperature 2.6383
        set mean-ph 8.1
        set stdev-ph 0.9291
        set mean-do 7.5
        set stdev-do 0.8603
        set mean-turbidity 32
        set stdev-turbidity 3.6707
    ]

    create-nitzschia 5 [
        set growth-rate 2
        set biomass 2
        set mean-phosphorus 116
        set stdev-phosphorus 5.9982
        set mean-phosphate 47
        set stdev-phosphate 2.4303
        set mean-ammonia 113
        set stdev-ammonia 5.8431
        set mean-kjeldahl-nitrogen 975
        set stdev-kjeldahl-nitrogen 50.4160
        set mean-chlorophyll-a 26.7
        set stdev-chlorophyll-a 1.3806
        set mean-nitrogen-phosphorus-ratio 12.8
        set stdev-nitrogen-phosphorus-ratio 0.6619
        set mean-calcium-carbonate 71
        set stdev-calcium-carbonate 3.6713
        set mean-temperature 21.6
        set stdev-temperature 1.1169
        set mean-ph 7.8
        set stdev-ph 0.4033
        set mean-do 7.8
        set stdev-do 0.4033
        set mean-turbidity 41
        set stdev-turbidity 2.1201
    ]

    create-scenedesmus 5 [
        set growth-rate 2
        set biomass 2
        set mean-phosphorus 135
        set stdev-phosphorus 5.7408
        set mean-phosphate 63
        set stdev-phosphate 2.6790
        set mean-ammonia 116
        set stdev-ammonia 4.9328
        set mean-kjeldahl-nitrogen 1125
        set stdev-kjeldahl-nitrogen 47.8399
        set mean-chlorophyll-a 29.6
        set stdev-chlorophyll-a 1.2587
        set mean-nitrogen-phosphorus-ratio 11.1
        set stdev-nitrogen-phosphorus-ratio 0.4720
        set mean-calcium-carbonate 73
        set stdev-calcium-carbonate 3.1043
        set mean-temperature 22.3
        set stdev-temperature 0.9483
        set mean-ph 7.8
        set stdev-ph 0.3317
        set mean-do 7.6
        set stdev-do 0.3232
        set mean-turbidity 72
        set stdev-turbidity 3.0618
    ]

    create-trachelomonas 5 [
        set growth-rate 2
        set biomass 2
        set mean-phosphorus 118
        set stdev-phosphorus 7.8147
        set mean-phosphate 41
        set stdev-phosphate 2.7153
        set mean-ammonia 128
        set stdev-ammonia 8.4770
        set mean-kjeldahl-nitrogen 1006
        set stdev-kjeldahl-nitrogen 66.6240
        set mean-chlorophyll-a 26.7
        set stdev-chlorophyll-a 1.7683
        set mean-nitrogen-phosphorus-ratio 12.5
        set stdev-nitrogen-phosphorus-ratio 0.8278
        set mean-calcium-carbonate 79
        set stdev-calcium-carbonate 5.2319
        set mean-temperature 21.7
        set stdev-temperature 1.4371
        set mean-ph 7.7
        set stdev-ph 0.5099
        set mean-do 7.4
        set stdev-do 0.4901
        set mean-turbidity 64
        set stdev-turbidity 4.2385
    ]
]
end

go [
    ask turtles [
        ;; each tick:
        ;; for each parameter:
        ;; 1. get the value of the parameter from the patch the turtle is on
        ;; 2. calculate the z-score of the turtle's value (z = (x - mean) / stdev)
        ;;      - x is the value from the patch
        ;;      - mean and stdev are from the turtle's local variables
        ;; 3. calculate the proportion of the turtle's value relative to the mean (proportion = normalcdf(|z|, inf, 0, 1))
        ;; 4. calculate the turtle's growth rate (growth-rate = growth-rate * proportion)
        ;; 5. calculate the turtle's biomass (biomass = biomass * proportion)
        ;; 6. calculate the turtle's NPP (npp = growth-rate * biomass * max-depth (max depth comes from a slider)
    ]
    
    tick
    if ticks >= 1000 [stop]
]
end