# CachedArrays
[![Build Status](https://travis-ci.com/HolyLab/CachedArrays.jl.svg?branch=master)](https://travis-ci.com/HolyLab/CachedArrays.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/2bqgvmga8nu79vti/branch/master?svg=true)](https://ci.appveyor.com/project/Cody-G/cachedarrays-jl/branch/master)
[![codecov](https://codecov.io/gh/HolyLab/CachedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HolyLab/CachedArrays.jl)

This package defines a concrete type, `CachedArray`, that caches data accessed in the first `n` dimensions of the array that it wraps, where `n` is selectable by the user:

```julia
A = rand(10,10,10) #this would make more sense with a large memory-mapped array
C = CachedArray(A, 2) #cache the first two dimensions
C[1,1,1] #This single access updates the cache for the first 100 elements of the array
C[2,1,1] #This doesn't update the cache and returns the element without reading again from A
C[2,1,2] #This updates the cache again because the non-cached dimension is changed
```

The usefulness of this depends on the array that you're wrapping and the expected access pattern.  Suppose, for example, that you need to access a memory-mapped array (backed by a slow hard disk) with a non-sequential access pattern.  If the access pattern is at least *local* rather than completely random then it may be faster to read and cache large chunks of the data to minimize the number of accesses needed by the hard drive.

Beware that access patterns in which the non-cached (higher) dimensions of the array change quicker than the cached dimensions will have dismal performance with a CachedArray!  In that case you're better off operating on the parent array directly, retrievable with `parent(C)`.

If you want to cache more than just the elements of the parent array (say, for example, store results of an expensive function applied to the array slices) then consider extending the `AbstractCachedArray` interface.  Examples of `AbstractCachedArray` subtypes can be found in `InterlacedStacks.jl`, `ZWarpedArrays.jl`, and `ImageInterpLast.jl`.  This kind of functionality could be described as "lazy `mapslices` with caching".
