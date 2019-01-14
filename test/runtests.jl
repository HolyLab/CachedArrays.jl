using CachedSeries
using Test

#construct 2d and 3d cached slice series
#these should generalize to N-dimensions, but will just test with 4 and 5
data4 = rand(2,3,2,2)
data5 = rand(2,3,2,2,2)
cs24 = CachedArray(data4, 2)
cs25 = CachedArray(data5, 2)

@test parent(cs24) == data4
@test parent(cs25) == data5

@test cached_axes(cs24) == axes(cs24)[1:2]
@test cached_axes(cs25) == axes(cs25)[1:2]

@test noncached_axes(cs24) == axes(cs24)[3:end]
@test noncached_axes(cs25) == axes(cs25)[3:end]

#2d caching, 4d array
#now test various getindex implementations
#(probably overkill to test all of these because this package only has one custom getindex method)

@test all(cs24[1:2, 1:1, 2, 1] .== data4[1:2, 1:1, 2, 1])
@test all(cs24[10] .== data4[10])
@test all(cs24[CartesianIndex(10)] .== data4[CartesianIndex(10)])
@test all(cs24[1:2, 1:1, 1:2, :] .== data4[1:2, 1:1, 1:2, :])
@test all(cs24[1:2, 1:1, 1, :] .== data4[1:2, 1:1, 1, :])

cs24[1:2,1,1,1] .= -1.0
@test all(cs24[1:2,1,1,1] .== -1.0)
@test all(cs24[1:2,1,1,1] .== data4[1:2,1,1,1])

#2d caching, 5d array
@test all(cs25[1:2, 1:1, 2, 1, 2] .== data5[1:2, 1:1, 2, 1, 2])
@test all(cs25[10] .== data5[10])
@test all(cs25[CartesianIndex(10)] .== data5[CartesianIndex(10)])
@test all(cs25[1:2, 1:1, 1:2, :, :] .== data5[1:2, 1:1, 1:2, :, :])
@test all(cs25[1:2, 1:1, 1, :, :] .== data5[1:2, 1:1, 1, :, :])

cs25[1:2,1,1,1,2] .= -1.0
@test all(cs25[1:2,1,1,1,2] .== -1.0)
@test all(cs25[1:2,1,1,1,2] .== data5[1:2,1,1,1,2])

#@code_warntype cs25[1:2, 1:1, 2, 1, 2]




#3D caching, 4d array
data4 = rand(2,3,2,2)
cs34 = CachedArray(data4, 3)
@test all(cs34[1:2, 1:1, 2, 1] .== data4[1:2, 1:1, 2, 1])
@test all(cs34[10] .== data4[10])
@test all(cs34[CartesianIndex(10)] .== data4[CartesianIndex(10)])
@test all(cs34[1:2, 1:1, 1:2, :] .== data4[1:2, 1:1, 1:2, :])
@test all(cs34[1:2, 1:1, 1, :] .== data4[1:2, 1:1, 1, :])

cs34[1:2,1,1,1] .= -1.0
@test all(cs34[1:2,1,1,1] .== -1.0)
@test all(cs34[1:2,1,1,1] .== data4[1:2,1,1,1])


#3d caching, 5d array
data5 = rand(2,3,2,2,2)
cs35 = CachedArray(data5, 3)
@test all(cs35[1:2, 1:1, 2, 1, 2] .== data5[1:2, 1:1, 2, 1, 2])
@test all(cs35[10] .== data5[10])
@test all(cs35[CartesianIndex(10)] .== data5[CartesianIndex(10)])
@test all(cs35[1:2, 1:1, 1:2, :, :] .== data5[1:2, 1:1, 1:2, :, :])
@test all(cs35[1:2, 1:1, 1, :, :] .== data5[1:2, 1:1, 1, :, :])

cs35[1:2,1,1,1,2] .= -1.0
@test all(cs35[1:2,1,1,1,2] .== -1.0)
@test all(cs35[1:2,1,1,1,2] .== data5[1:2,1,1,1,2])

#@code_warntype cs35[1:2, 1:1, 2, 1]
