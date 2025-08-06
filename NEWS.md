# deflateBR 1.2.0

## Major Changes

### Architecture Refactoring

* **Complete API separation**: Created dedicated `R/api.R` module to handle all API interactions with IPEA's database, removing hardcoded endpoints from main business logic.

* **Simplified package interface**: Removed five wrapper functions (`ipca()`, `igpm()`, `igpdi()`, `ipc()`, `inpc()`) in favor of a unified `deflate()` function with an `index` parameter. This reduces code duplication and provides a cleaner, more maintainable interface.

* **Enhanced error handling**: Added retry mechanisms for API requests with configurable retry attempts and delays.

## New Features

### Data Caching System

* **Local data caching**: Added comprehensive caching system that stores downloaded price index data locally in a "cache" directory, significantly improving performance for repeated API calls.

* **Automatic cache management**: Cache files are automatically validated for structure and content. Invalid or corrupted cache files are automatically re-downloaded.

* **Cache control**: Added `cache` parameter to `deflate()` function (default `TRUE`) allowing users to disable caching when fresh data is always required.

* **Smart cache loading**: First call downloads and caches data; subsequent calls load from cache with detailed progress messages showing cache status.

### Enhanced Function Interface

* **Flexible date input**: The `real_date` parameter now accepts both character strings in 'MM/YYYY' format and Date objects (e.g., `as.Date("2018-01-01")`), providing more flexibility for users.

* **Verbose control**: Added `verbose` parameter to `deflate()` function to control progress messages and progress bars during data download. Default is `TRUE` for backward compatibility.

* **Improved user agent**: API requests now include a proper user agent string identifying the deflateBR package.

### API Improvements

* **Centralized configuration**: All API endpoints and price index codes are now centrally managed in `R/api.R`.

* **Better HTTP handling**: Enhanced HTTP request handling with proper status checking and informative error messages.

* **Progress feedback**: Optional progress bars during data download for better user experience.

## Documentation

* **Comprehensive examples**: Updated documentation with examples showing both string and Date object usage for the `real_date` parameter.

* **Simplified README**: Removed references to deprecated wrapper functions and updated examples to showcase the unified interface.

* **Enhanced function documentation**: Improved parameter descriptions and added detailed examples for all new features.

## Breaking Changes

* **Removed wrapper functions**: The convenience functions `ipca()`, `igpm()`, `igpdi()`, `ipc()`, and `inpc()` have been removed. Users should now use `deflate()` with the appropriate `index` parameter instead.

  ```r
  # Old (deprecated):
  ipca(100, as.Date("2020-01-01"), "01/2021")
  
  # New:
  deflate(100, as.Date("2020-01-01"), "01/2021", index = "ipca")
  ```


## Migration Guide

For users upgrading from version 1.1.x:

1. **Replace wrapper function calls**: Change `ipca()`, `igpm()`, etc. calls to use `deflate()` with the `index` parameter.

2. **Optional: Use Date objects**: Take advantage of the new Date object support for the `real_date` parameter.

3. **Optional: Control verbosity**: Use the `verbose = FALSE` parameter for silent operation.

---

# deflateBR 1.1.2

* Added a `NEWS.md` file to track changes to the package.
