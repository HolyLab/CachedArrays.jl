using CachedSeries
using Test

#construct 2d and 3d cached slice series
data4 = rand(2,2,2,2)
data5 = rand(2,2,2,2,2)
#these should generalize to N-dimensions, but will just test with 4 and 5
cs24 = CachedSliceSeries2D(data4)
cs25 = CachedSliceSeries2D(data5)

#2d caching, 4d array
#now test various getindex implementations
#(future note:there may be a way to reduce the number of implementations needed)
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

@code_warntype cs25[1:2, 1:1, 2, 1, 2]

#3D caching, 4d array
data4 = rand(2,2,2,2)
cs34 = CachedSliceSeries3D(data4)
@test all(cs34[1:2, 1:1, 2, 1] .== data4[1:2, 1:1, 2, 1])
@test all(cs34[10] .== data4[10])
@test all(cs34[CartesianIndex(10)] .== data4[CartesianIndex(10)])
@test all(cs34[1:2, 1:1, 1:2, :] .== data4[1:2, 1:1, 1:2, :])
@test all(cs34[1:2, 1:1, 1, :] .== data4[1:2, 1:1, 1, :])

cs34[1:2,1,1,1] .= -1.0
@test all(cs34[1:2,1,1,1] .== -1.0)
@test all(cs34[1:2,1,1,1] .== data4[1:2,1,1,1])

@code_warntype cs34[1:2, 1:1, 2, 1]

#3d caching, 5d array
data5 = rand(2,2,2,2,2)
cs35 = CachedSliceSeries3D(data5)
@test all(cs35[1:2, 1:1, 2, 1, 2] .== data5[1:2, 1:1, 2, 1, 2])
@test all(cs35[10] .== data5[10])
@test all(cs35[CartesianIndex(10)] .== data5[CartesianIndex(10)])
@test all(cs35[1:2, 1:1, 1:2, :, :] .== data5[1:2, 1:1, 1:2, :, :])
@test all(cs35[1:2, 1:1, 1, :, :] .== data5[1:2, 1:1, 1, :, :])

cs35[1:2,1,1,1,2] .= -1.0
@test all(cs35[1:2,1,1,1,2] .== -1.0)
@test all(cs35[1:2,1,1,1,2] .== data5[1:2,1,1,1,2])

@code_warntype cs35[1:2, 1:1, 2, 1]
#c24[dim1, dim2, dim3::Int, dim4::Int] = _getslice(A, dim1, dim2, (dim3,dim4))
#c24[dim1::Int] = 
#c24[dim1::CartesianIndex] = 
#c24[dim1, dim2, queryidxs...] =
