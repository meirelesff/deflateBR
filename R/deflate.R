#' Deflate Nominal Brazilian Reais Using Various Price Indexes
#'
#' @description
#' \code{deflate()} uses data from the Brazilian Institute for Applied Economic Research's API (IPEADATA) to adjust nominal Brazilian Reais for inflation.
#'
#' @param nominal_values A \code{numeric} vector containing nominal Brazilian Reais to deflate.
#' @param nominal_dates A \code{Date} vector with corresponding nominal dates (i.e., when nominal values were measured).
#' Values are set to the previous month, following the
#' standard methodology used by the \href{https://www3.bcb.gov.br/CALCIDADAO/publico/metodologiaCorrigirIndice.do?method=metodologiaCorrigirIndice}{Brazilian Central Bank}.
#' @param real_date A value indicating the reference date to deflate nominal values in the format
#' 'MM/YYYY' (e.g., '01/2018' for January 2018).
#' @param index Indicates the price index used to deflate nominal Reais. Valid options are: \code{ipca}, \code{igpm},
#' \code{igpdi}, \code{ipc}, and \code{inpc}.
#'
#' @details Each one of the five price indexes included
#' in the function are maintained by two Brazilian agencies: IPCA and INPC indexes are maintained by Brazilian Institute of Geography and Statistics (IBGE);
#' IGP-M, IGP-DI, and IPC are maintained by Getulio Vargas Foundation (FGV). For an overview of the indexes' methodologies and covered periods, check the Brazilian Central Bank official \href{https://www.bcb.gov.br/conteudo/home-en/FAQs/FAQ\%2002-Price\%20Indices.pdf}{FAQ}.
#'
#' @references For more information on the Brazilian Institute for Applied Economic Research's API, please check (in Portuguese):
#' \url{http://www.ipeadata.gov.br/}.
#'
#' @return A \code{numeric} vector.
#'
#' @examples
#' \dontrun{
#' # Use IPCA index to deflate a vector of nominal Brazilian Reais
#' reais <- rep(100, 5)
#' actual_dates <- seq.Date(from = as.Date("2001-01-01"), to = as.Date("2001-05-01"), by = "month")
#'
#' deflate(reais, actual_dates, "01/2018", "ipca")
#'
#' # Using IGP-M index
#' deflate(reais, actual_dates, "01/2018", "igpm")
#' }
#'
#' @importFrom lubridate %m-%
#' @export

deflate <- function(nominal_values, nominal_dates, real_date, index = c("ipca", "igpm", "igpdi", "ipc", "inpc")){


  # Inputs
  real_date <- clean_real_date(real_date)
  check_nominal_dates(nominal_dates)
  index <- match.arg(index)


  # Round dates
  nominal_dates <- lubridate::floor_date(nominal_dates, unit = "month") %m-% months(1)
  real_date <- lubridate::floor_date(real_date, unit = "month")


  # Get price index
  message("\nDownloading necessary data from IPEA's API\n...\n")
  tmp <- tempfile()

  if(index == "ipca"){

    indice <- httr::GET("http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='PRECOS12_IPCA12')")
    httr::stop_for_status(indice, task = "get IPCA price index from IPEA's API.")

  } else if(index == "igpm") {

    indice <- httr::GET("http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='IGP12_IGPM12')")
    httr::stop_for_status(indice, task = "get IPG-M price index from IPEA's API.")

  } else if(index == "igpdi") {

    indice <- httr::GET("http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='IGP12_IGPDI12')")
    httr::stop_for_status(indice, task = "get IPG-DI price index from IPEA's API.")

  } else if(index == "ipc") {

    indice <- httr::GET("http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='IGP12_IPC12')")
    httr::stop_for_status(indice, task = "get IPC price index from IPEA's API.")

  } else {

    indice <- httr::GET("http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='PRECOS12_INPC12')")
    httr::stop_for_status(indice, task = "get INPC price index from IPEA's API.")

  }


  # Calculate changes in prices
  indice <- httr::content(indice)[[2]]
  indice <- dplyr::bind_rows(indice)[,2:3]
  indice$VALDATA <- lubridate::as_date(indice$VALDATA)
  indice$indx <- indice$VALVALOR[indice$VALDATA == real_date] / indice$VALVALOR


  # Return
  indice$indx[match(nominal_dates, indice$VALDATA)] * nominal_values
}
