#' Deflate Nominal Brazilian Reais Using INPC
#'
#' @description
#' \code{inpc()} is a convenience function to deflate nominal Brazilian Reais using the Brazilian Institute of Geography and Statistics' INPC price index.
#'
#' @param nominal_values A \code{numeric} vector containing nominal Brazilian Reais to deflate.
#' @param nominal_dates A \code{Date} vector with corresponding nominal dates (i.e., when nominal values were measured).
#' @param real_date A value indicating the reference date to deflate nominal values in the format
#' 'DD/MM/YYYY' (e.g., '01/01/2018' for January 2018). Values are rounded to the previous month, following the
#' standard methodology used by the \href{https://www3.bcb.gov.br/CALCIDADAO/publico/metodologiaCorrigirIndice.do?method=metodologiaCorrigirIndice}{Brazilian Central Bank}.
#'
#' @seealso \code{\link{deflate}}.
#'
#' @return A \code{numeric} vector.
#'
#' @examples
#' \dontrun{
#' # Use INPC index to deflate a vector of nominal Brazilian Reais
#' reais <- rep(100, 5)
#' actual_dates <- seq.Date(from = as.Date("2001-01-01"), to = as.Date("2001-05-01"), by = "month")
#'
#' inpc(reais, actual_dates, "01/01/2018")
#' }
#'
#' @export

inpc <- function(nominal_values, nominal_dates, real_date){

  deflate(nominal_values, nominal_dates, real_date, "inpc")
}
