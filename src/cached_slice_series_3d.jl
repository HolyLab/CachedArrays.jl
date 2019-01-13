mutable struct CachedSliceSeries3D{T,N,AA<:AbstractArray} <: CachedSeries3D{T,T,N,AA}
    parent::AA
    cached::Array{T,3}
    cache_idxs::Tuple
end


cache_idxs(A::CachedSliceSeries3D) = A.cache_idxs
cache(A::CachedSliceSeries3D) = A.cached
size(A::CachedSliceSeries3D) = size(A.parent)
axes(A::CachedSliceSeries3D) = axes(A.parent)

function update_cache!(A::CachedSliceSeries3D{T, N}, inds::NTuple{N2, Int}) where {T, N, N2}
    A.cached[:,:,:] = A.parent[:,:,:,inds...]
    A.cache_idxs = inds
end

function CachedSliceSeries3D(A::AbstractArray{T,N}) where {T,N}
    cached = zeros(T, size(A,1), size(A,2), size(A,3))
    cache_rngs = Base.tail(Base.tail(Base.tail(axes(A))))
    cache_idxs = map(first, cache_rngs)
    s = CachedSliceSeries3D{T,N,typeof(A)}(A, cached, cache_idxs)
    update_cache!(s, cache_idxs)
    return s
end

Base.show(io::IO, A::CachedSliceSeries3D) = print(io, summary(A)*"\n")
Base.show(io::IO, ::MIME"text/plain", A::CachedSliceSeries3D) = show(io, A)
