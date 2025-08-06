#' Data Caching Functions
#'
#' @description
#' Functions to handle local caching of price index data to improve performance
#' by avoiding redundant API calls.

#' Get Cache Directory Path
#'
#' @description
#' Returns the path to the cache directory, creating it if it doesn't exist.
#'
#' @param create_if_missing Logical indicating whether to create the directory if it doesn't exist.
#' @return Character string with the path to the cache directory.
get_cache_dir <- function(create_if_missing = TRUE) {
  cache_dir <- file.path(getwd(), "cache")
  
  if (create_if_missing && !dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }
  
  return(cache_dir)
}

#' Get Cache File Path for Index
#'
#' @description
#' Returns the full path to the cache file for a specific price index.
#'
#' @param index Character string indicating the price index.
#' @return Character string with the full path to the cache file.
get_cache_file_path <- function(index) {
  cache_dir <- get_cache_dir(create_if_missing = FALSE)
  cache_file <- paste0(index, ".csv")
  return(file.path(cache_dir, cache_file))
}

#' Check if Cache File Exists and is Valid
#'
#' @description
#' Checks if a cache file exists for the given index and validates its structure.
#'
#' @param index Character string indicating the price index.
#' @param verbose Logical indicating whether to show cache status messages.
#' @return Logical indicating whether a valid cache file exists.
#' @importFrom utils read.csv
cache_exists <- function(index, verbose = TRUE) {
  cache_file <- get_cache_file_path(index)
  
  if (!file.exists(cache_file)) {
    if (verbose) {
      message("No cache found for ", toupper(index), " index")
    }
    return(FALSE)
  }
  
  # Check if file is readable and has correct structure
  tryCatch({
    cache_data <- utils::read.csv(cache_file, stringsAsFactors = FALSE)
    
    # Validate required columns
    required_cols <- c("VALDATA", "VALVALOR")
    if (!all(required_cols %in% names(cache_data))) {
      if (verbose) {
        message("Invalid cache file structure for ", toupper(index), " index, will re-download")
      }
      return(FALSE)
    }
    
    # Validate data types and content
    if (nrow(cache_data) == 0) {
      if (verbose) {
        message("Empty cache file for ", toupper(index), " index, will re-download")
      }
      return(FALSE)
    }
    
    if (verbose) {
      message("Found valid cache for ", toupper(index), " index (", nrow(cache_data), " records)")
    }
    return(TRUE)
    
  }, error = function(e) {
    if (verbose) {
      message("Error reading cache file for ", toupper(index), " index: ", e$message)
    }
    return(FALSE)
  })
}

#' Load Data from Cache
#'
#' @description
#' Loads price index data from the local cache file.
#'
#' @param index Character string indicating the price index.
#' @param verbose Logical indicating whether to show cache loading messages.
#' @return A data frame with columns VALDATA (dates) and VALVALOR (index values).
#' @importFrom lubridate as_date
#' @importFrom utils read.csv
load_from_cache <- function(index, verbose = TRUE) {
  cache_file <- get_cache_file_path(index)
  
  if (verbose) {
    message("Loading ", toupper(index), " data from cache...")
  }
  
  tryCatch({
    cache_data <- utils::read.csv(cache_file, stringsAsFactors = FALSE)
    
    # Convert date column
    cache_data$VALDATA <- lubridate::as_date(cache_data$VALDATA)
    
    # Ensure correct column order and types
    cache_data <- cache_data[, c("VALDATA", "VALVALOR")]
    
    if (verbose) {
      date_range <- range(cache_data$VALDATA, na.rm = TRUE)
      message("Loaded ", nrow(cache_data), " records from cache (", 
              format(date_range[1], "%Y-%m"), " to ", 
              format(date_range[2], "%Y-%m"), ")")
    }
    
    return(cache_data)
    
  }, error = function(e) {
    stop("Failed to load cache file for ", toupper(index), " index: ", e$message)
  })
}

#' Save Data to Cache
#'
#' @description
#' Saves price index data to the local cache file.
#'
#' @param index Character string indicating the price index.
#' @param data Data frame with price index data to cache.
#' @param verbose Logical indicating whether to show cache saving messages.
#' @return Logical indicating success of the caching operation.
#' @importFrom utils write.csv
save_to_cache <- function(index, data, verbose = TRUE) {
  # Ensure cache directory exists
  get_cache_dir(create_if_missing = TRUE)
  cache_file <- get_cache_file_path(index)
  
  if (verbose) {
    message("Saving ", toupper(index), " data to cache...")
  }
  
  tryCatch({
    # Validate data structure
    required_cols <- c("VALDATA", "VALVALOR")
    if (!all(required_cols %in% names(data))) {
      stop("Data must contain VALDATA and VALVALOR columns")
    }
    
    if (nrow(data) == 0) {
      stop("Cannot cache empty data")
    }
    
    # Prepare data for saving (ensure consistent format)
    cache_data <- data[, required_cols]
    cache_data$VALDATA <- as.character(cache_data$VALDATA)
    
    # Save to CSV
    utils::write.csv(cache_data, cache_file, row.names = FALSE)
    
    if (verbose) {
      message("Cached ", nrow(cache_data), " records for ", toupper(index), " index")
    }
    
    return(TRUE)
    
  }, error = function(e) {
    warning("Failed to save cache for ", toupper(index), " index: ", e$message)
    return(FALSE)
  })
}

#' Get Price Index Data with Caching Support
#'
#' @description
#' Main function that handles cache logic - checks cache first, then downloads if needed.
#'
#' @param index Character string indicating the price index.
#' @param cache Logical indicating whether to use caching.
#' @param verbose Logical indicating whether to show progress messages.
#' @param max_retries Maximum number of retry attempts for failed requests.
#' @param retry_delay Delay in seconds between retry attempts.
#' @return A data frame with columns VALDATA (dates) and VALVALOR (index values).
get_price_index_data_cached <- function(index, cache = TRUE, verbose = TRUE, max_retries = 3, retry_delay = 1) {
  
  # If caching is enabled, try to load from cache first
  if (cache && cache_exists(index, verbose = verbose)) {
    return(load_from_cache(index, verbose = verbose))
  }
  
  # Download data from API
  if (verbose && cache) {
    message("Cache not available, downloading from IPEA API...")
  }
  
  price_data <- get_price_index_data(index, max_retries = max_retries, 
                                   retry_delay = retry_delay, verbose = verbose)
  
  # Save to cache if caching is enabled
  if (cache) {
    save_to_cache(index, price_data, verbose = verbose)
  }
  
  return(price_data)
}
