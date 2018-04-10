#Like 2D version except that lazy computation / caching is applied to the first 3 dimensions
abstract type CachedSeries3D{TO,TI,N} <: AbstractCachedSeries{TO,TI,N} end

getindex(A::CachedSeries3D, dim1, dim2, dim3, dim4::Int) = _getslice(A, dim1, dim2, dim3, (dim4,))
getindex(A::CachedSeries3D, dim1::Int) = getindex(A, ind2sub(A, dim1)...)
getindex(A::CachedSeries3D, dim1::CartesianIndex) = getindex(A, dim1.I...)

function _getslice(A::CachedSeries3D, dim1, dim2, dim3, queryidxs::NTuple{N,Int}) where {N}
    if cache_idxs(A) != queryidxs
        update_cache!(A, queryidxs)
    end
    return _index_slice(cache(A), dim1,dim2,dim3)
end

#returns multiple slices.  This is memory-inefficient (allocates 2x as much as a mutating version would)
function getindex(A::CachedSeries3D{T}, dim1, dim2, dim3, queryidxs...) where {T}
    outsz = _idx_shape(A, (dim1, dim2, dim3, queryidxs...))
    output = zeros(T, outsz...)
    _getindex!(output, A, lose_colons(indices(A), dim1, dim2, dim3, queryidxs...)...)
end

function _getindex!(prealloc::AbstractArray{TO}, A::CachedSeries3D{TO}, idxs1, idxs2, idxs3, queryidxs...) where {TO}
    itr = enumerate(Base.product(queryidxs...))
    itrsz = size(itr)
    for (ipre, ia) in itr
        prealloc[:, :, :, ind2sub(itrsz, ipre)...] = A[idxs1,idxs2,idxs3,ia...]
    end
    return prealloc
end
