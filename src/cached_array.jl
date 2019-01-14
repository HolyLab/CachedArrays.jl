mutable struct CachedArray{T,N,NC,AA<:AbstractArray} <: AbstractCachedArray{T,T,N,NC,AA}
    parent::AA
    cached::Array{T,NC}
    current_I::Tuple
end

#not type stable, but as a constructor it's not performance-critical
function CachedArray(A::AbstractArray{T,N}, nd_cache::Int) where {T,N}
    @assert nd_cache < N
    cache_rngs = axes(A)[nd_cache+1:N]
    ci = map(first, cache_rngs)
    cached = similar(view(A, axes(A)[1:nd_cache]..., ci...))
    s = CachedArray{T,N,nd_cache,typeof(A)}(A, cached, ci)
    update_cache!(s, ci)
    return s
end
