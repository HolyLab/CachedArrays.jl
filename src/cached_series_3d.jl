#Like 2D version except that lazy computation / caching is applied to the first 3 dimensions
abstract type CachedSeries3D{TO,TI,N} <: AbstractCachedSeries{TO,TI,N} end

function slow_getindex(A::CachedSeries3D, I)
    sl = A[:,:,:, I[4:end]...]
    return sl[I[1],I[2],I[3]]
end

getindex(A::CachedSeries3D, dim1::Int, otherdims...) = slow_getindex(A, (dim1, otherdims...))
getindex(A::CachedSeries3D, dim1, dim2::Int, otherdims...) = slow_getindex(A, (dim1, dim2, otherdims...))
getindex(A::CachedSeries3D, dim1, dim2, dim3::Int, otherdims...) = slow_getindex(A, (dim1, dim2, dim3, otherdims...))
getindex(A::CachedSeries3D, dim1::Int, dim2::Int, dim3, otherdims...) = slow_getindex(A, (dim1, dim2, dim3, otherdims...))
getindex(A::CachedSeries3D, dim1::Int, dim2, dim3::Int, otherdims...) = slow_getindex(A, (dim1, dim2, dim3, otherdims...))
getindex(A::CachedSeries3D, dim1, dim2::Int, dim3::Int, otherdims...) = slow_getindex(A, (dim1, dim2, dim3, otherdims...))
getindex(A::CachedSeries3D, dim1::Int, dim2::Int, dim3::Int, otherdims...) = slow_getindex(A, (dim1, dim2, dim3, otherdims...))

getindex(A::CachedSeries3D, dim1::Union{UnitRange, Colon}, dim2::Union{UnitRange,Colon}, dim3::Union{UnitRange, Colon}, dim4::Int) = _getslice(A, dim1, dim2, dim3, (dim4,))

function _getslice(A::CachedSeries3D, dim1::Union{UnitRange, Colon}, dim2::Union{UnitRange,Colon}, dim3::Union{UnitRange,Colon}, queryidxs::NTuple{N,Int}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2,dim3)
end

#returns multiple slices.  This is memory-inefficient (allocates 2x as much as a mutating version would)
function getindex(A::CachedSeries3D, dim1::Union{UnitRange,Colon}, dim2::Union{UnitRange,Colon}, dim3::Union{UnitRange,Colon}, queryidxs)
    outsz = _idx_shape(A, (dim1, dim2, dim3, queryidxs...))
    output = zeros(T, outsz...)
    _getindex!(output, A, dim1, dim2, dim3, queryidxs)
end

function _getindex!(prealloc::AbstractArray{TO}, A::CachedSeries3D{TO,TI}, idxs1, idxs2, idxs3, queryidxs::NTuple{N}) where {TO,TI,N}
    itr = enumerate(Base.product(queryidxs))
    itrsz = size(itr)
    for (ipre, ia) in itr
        prealloc[:, :, :, ind2sub(itersz, ipre)...] = A[idxs1,idxs2,idxs3,ia...]
    end
    return prealloc
end
