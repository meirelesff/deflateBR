#' Calculate Inflation Between Two Dates
#'
#' @description
#' \code{inflation()} is a convenience function used to calculate the inflation rate between two periods
#'
#' @param initial_date Initial date in the 'MM/YYYY' format (\code{character}).
#' @param end_date End date in the 'MM/YYYY' format (\code{character}).
#' @param index One of the following options: \code{ipca}, \code{inpc}, \code{igpm}, \code{igpdi}, and \code{ipc}. Each one
#' of these options uses the following price indexes, respectively: IPCA and INPC indexes maintained by Brazilian Institute of Geography and Statistics (IBGE); and
#' IGP-M, IGP-DI, and IPC maintained by Getulio Vargas Foundation (FGV). For an overview of the indexes' methodologies
#' and covered periods, check the Brazilian Central Bank official \href{https://www.bcb.gov.br/conteudo/home-en/FAQs/FAQ\%2002-Price\%20Indices.pdf}{FAQ}.
#'
#' @seealso \code{\link{deflate}}.
#'
#' @return The inflation rate, in percent, between \code{initial_date} and \code{end_date}.
#'
#' @examples
#' \dontrun{
#' # Inflation rate between January 2010 to January 2018 calculated using IPCA price index
#' inflation("01/2010", "01/2018", "ipca")
#'
#' # Inflation rate between January 2014 to December 2014 calculated using IGP-M price index
#' inflation("01/2014", "12/2014", "igpm")
#' }
#'
#' @export

inflation <- function(initial_date, end_date, index = c("ipca", "inpc", "igpm", "igpdi", "ipc")){

  # Inputs
  index <- match.arg(index)
  initial_date <- clean_real_date(initial_date)

  # Inflation rate
  deflate(100, initial_date, end_date, index) - 100
}
