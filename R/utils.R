# OnAttach message
.onAttach <-
  function(libname, pkgname) {
    packageStartupMessage("\nTo cite deflateBR in publications, please use: citation('deflateBR')")
  }


# Function to check real date
clean_real_date <- function(real_date){

  if(nchar(real_date) != 7 & substr(real_date, 3, 3) != "/") stop("'real_date' must be a character in the MM/YYYY format.")
  lubridate::dmy(paste0("01/", real_date))
}


# Function to check nominal dates
check_nominal_dates <- function(nominal_dates){

  if(!lubridate::is.Date(nominal_dates)) stop("'nominal_date' and 'real_date' objects must be of classs Date.")
}
