# OnAttach message
.onAttach <-
  function(libname, pkgname) {
    packageStartupMessage("\nTo cite deflateBR in publications, please use: citation('deflateBR')")
  }


# Function to check real date
clean_real_date <- function(real_date){
  
  # Handle Date objects
  if (inherits(real_date, "Date")) {
    if (length(real_date) != 1) {
      stop("'real_date' must have length 1 when providing a Date object.")
    }
    return(real_date)
  }
  
  # Handle character strings in MM/YYYY format
  if (is.character(real_date)) {
    if (length(real_date) != 1) {
      stop("'real_date' must have length 1.")
    }
    if (nchar(real_date) != 7 || substr(real_date, 3, 3) != "/") {
      stop("'real_date' must be a character in the MM/YYYY format.")
    }
    return(lubridate::dmy(paste0("01/", real_date)))
  }
  
  # Invalid input type
  stop("'real_date' must be either a Date object or a character string in MM/YYYY format.")
}


# Function to check nominal dates
check_nominal_dates <- function(nominal_dates){

  if(!lubridate::is.Date(nominal_dates)) stop("'nominal_date' and 'real_date' objects must be of classs Date.")
}
