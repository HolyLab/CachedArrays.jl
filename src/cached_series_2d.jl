abstract type CachedSeries2D{TO,TI,N} <: AbstractCachedSeries{TO,TI,N} end

function slow_getindex(A::CachedSeries2D, I)
    sl = A[:,:,I[3:end]...]
    return sl[I[1],I[2]]
end

getindex(A::CachedSeries2D, dim1::Int, otherdims...) = slow_getindex(A, (dim1, otherdims...))
getindex(A::CachedSeries2D, dim1, dim2::Int, otherdims...) = slow_getindex(A, (dim1, dim2, otherdims...))
getindex(A::CachedSeries2D, dim1::Int, dim2::Int, otherdims...) = slow_getindex(A, (dim1, dim2, otherdims...))

getindex(A::CachedSeries2D, dim1::Union{UnitRange, Colon}, dim2::Union{UnitRange,Colon}, dim3::Int, dim4::Int) = _getslice(A, dim1, dim2, (dim3,dim4))
getindex(A::CachedSeries2D, dim1::Union{UnitRange, Colon}, dim2::Union{UnitRange,Colon}, dim3::Int) = _getslice(A, dim1, dim2, (dim3,))

function _getslice(A::CachedSeries2D, dim1::Union{UnitRange, Colon}, dim2::Union{UnitRange,Colon}, queryidxs::NTuple{N,Int}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2)
end

#returns multiple slices.  This is memory-inefficient (allocates 2x as much as a mutating version would)
function getindex(A::CachedSeries2D, dim1::Union{UnitRange,Colon}, dim2::Union{UnitRange,Colon}, queryidxs)
    outsz = _idx_shape(A, (dim1, dim2, queryidxs...))
    output = zeros(T, outsz...)
    _getindex!(output, A, idxs1, idxs2, queryidxs)
end

function _getindex!(prealloc::AbstractArray{TO}, A::CachedSeries2D{TO,TI}, idxs1, idxs2, queryidxs::NTuple{N}) where {TO,TI,N}
    itr = enumerate(Base.product(queryidxs))
    itrsz = size(itr)
    for (ipre, ia) in itr
        prealloc[:, :, ind2sub(itersz, ipre)...] = A[idxs1,idxs2,ia...]
    end
    return prealloc
end
