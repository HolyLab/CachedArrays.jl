mutable struct CachedSliceSeries2D{T,N} <: CachedSeries2D{T,T,N}
    parent::AbstractArray{T,N}
    cached::Array{T,2}
    cache_idxs::Tuple
end

cache_idxs(A::CachedSliceSeries2D) = A.cache_idxs
cache(A::CachedSliceSeries2D) = A.cached
size(A::CachedSliceSeries2D) = size(A.parent)
indices(A::CachedSliceSeries2D) = indices(A.parent)

function update_cache!(A::CachedSliceSeries2D{T, N}, inds::NTuple{N2, Int}) where {T, N, N2}
    A.cached[:,:] = A.parent[:,:,inds...]
    A.cache_idxs = inds
end

function CachedSliceSeries2D(A::AbstractArray{T,N}) where {T,N}
    cached = zeros(T, size(A,1), size(A,2))
    cache_rngs = Base.tail(Base.tail(indices(A)))
    cache_idxs = map(first, cache_rngs) #(ones(Int, N-2)...)
    s = CachedSliceSeries2D(A, cached, cache_idxs)
    update_cache!(s, cache_idxs)
    return s
end

Base.show(io::IO, A::CachedSliceSeries2D) = print(io, summary(A)*"\n")
Base.show(io::IO, ::MIME"text/plain", A::CachedSliceSeries2D) = show(io, A)
