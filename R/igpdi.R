#' Deflate Nominal Brazilian Reais Using IGP-DI
#'
#' @description
#' \code{ipc()} is a convenience function to deflate nominal Brazilian Reais using the Getulio Vargas Foundation's IGP-DI price index.
#'
#' @param nominal_values A \code{numeric} vector containing nominal Brazilian Reais to deflate.
#' @param nominal_dates A \code{Date} vector with corresponding nominal dates (i.e., when nominal values were measured).
#' Values are set to the previous month, following the
#' standard methodology used by the \href{https://www3.bcb.gov.br/CALCIDADAO/publico/metodologiaCorrigirIndice.do?method=metodologiaCorrigirIndice}{Brazilian Central Bank}.
#' @param real_date A value indicating the reference date to deflate nominal values in the format
#' 'MM/YYYY' (e.g., '01/2018' for January 2018).
#'
#' @seealso \code{\link{deflate}}.
#'
#' @return A \code{numeric} vector.
#'
#' @examples
#' \dontrun{
#' # Use IGP-DI index to deflate a vector of nominal Brazilian Reais
#' reais <- rep(100, 5)
#' actual_dates <- seq.Date(from = as.Date("2001-01-01"), to = as.Date("2001-05-01"), by = "month")
#'
#' igpdi(reais, actual_dates, "01/2018")
#' }
#'
#' @export

igpdi <- function(nominal_values, nominal_dates, real_date){

  deflate(nominal_values, nominal_dates, real_date, "igpdi")
}
