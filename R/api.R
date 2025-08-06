#' API Configuration and Data Fetching Functions
#'
#' @description
#' Functions to handle API interactions with IPEA's database for price index data.

# API endpoint configuration
.IPEA_BASE_URL <- "http://ipeadata.gov.br/api/odata4/ValoresSerie"

# Price index series codes mapping
.PRICE_INDEX_CODES <- list(
  ipca = "PRECOS12_IPCA12",
  igpm = "IGP12_IGPM12", 
  igpdi = "IGP12_IGPDI12",
  ipc = "IGP12_IPC12",
  inpc = "PRECOS12_INPC12"
)

# Index names for error messages
.INDEX_NAMES <- list(
  ipca = "IPCA",
  igpm = "IGP-M", 
  igpdi = "IGP-DI",
  ipc = "IPC",
  inpc = "INPC"
)

#' Get Price Index Data from IPEA API
#'
#' @description
#' Fetches price index data from IPEA's API with retry mechanism and proper error handling.
#'
#' @param index Character string indicating the price index. Valid options are: 
#' "ipca", "igpm", "igpdi", "ipc", "inpc".
#' @param max_retries Maximum number of retry attempts for failed requests. Default is 3.
#' @param retry_delay Delay in seconds between retry attempts. Default is 1.
#' @param verbose Logical indicating whether to show progress messages and progress bar. Default is TRUE.
#'
#' @return A data frame with columns VALDATA (dates) and VALVALOR (index values).
#'
#' @importFrom httr GET stop_for_status content user_agent progress
#' @importFrom dplyr bind_rows
#' @importFrom lubridate as_date
get_price_index_data <- function(index, max_retries = 3, retry_delay = 1, verbose = TRUE) {
  
  # Validate index
  if (!index %in% names(.PRICE_INDEX_CODES)) {
    stop("Invalid index. Must be one of: ", paste(names(.PRICE_INDEX_CODES), collapse = ", "))
  }
  
  # Build API URL
  series_code <- .PRICE_INDEX_CODES[[index]]
  url <- paste0(.IPEA_BASE_URL, "(SERCODIGO='", series_code, "')")
  index_name <- .INDEX_NAMES[[index]]
  
  # Set user agent
  ua <- httr::user_agent("deflateBR R package (https://github.com/meirelesff/deflateBR)")

  # Attempt API request with retry mechanism
  response <- NULL
  last_error <- NULL
  
  for (attempt in 1:max_retries) {
    tryCatch({
      if (verbose) {
        response <- httr::GET(url, ua, httr::progress())
      } else {
        response <- httr::GET(url, ua)
      }
      httr::stop_for_status(response, task = paste("get", index_name, "price index from IPEA's API"))
      break  # Success, exit retry loop
    }, error = function(e) {
      last_error <<- e
      if (attempt < max_retries) {
        if (verbose) {
          message("Request failed (attempt ", attempt, "/", max_retries, "), retrying in ", retry_delay, " seconds...")
        }
        Sys.sleep(retry_delay)
      }
    })
  }
  
  # If all retries failed, throw the last error
  if (is.null(response)) {
    stop("Failed to fetch data after ", max_retries, " attempts. Last error: ", last_error$message)
  }
  
  # Parse response
  content_data <- httr::content(response)
  
  # Validate response structure
  if (is.null(content_data) || length(content_data) < 2 || is.null(content_data[[2]])) {
    stop("Invalid response structure from IPEA API for ", index_name, " index")
  }
  
  # Convert to data frame
  price_data <- dplyr::bind_rows(content_data[[2]])
  
  # Validate required columns
  if (!all(c("VALDATA", "VALVALOR") %in% names(price_data))) {
    stop("Missing required columns in API response for ", index_name, " index")
  }
  
  # Convert date column and select only needed columns
  price_data <- price_data[, c("VALDATA", "VALVALOR")]
  price_data$VALDATA <- lubridate::as_date(price_data$VALDATA)
  
  # Validate data
  if (nrow(price_data) == 0) {
    stop("No data returned from IPEA API for ", index_name, " index")
  }
  
  return(price_data)
}

#' Get Available Price Index Codes
#'
#' @description
#' Returns a named vector of available price index codes and their corresponding series codes.
#'
#' @return A named character vector where names are index identifiers and values are series codes.
#' @export
get_available_indexes <- function() {
  return(unlist(.PRICE_INDEX_CODES))
}
