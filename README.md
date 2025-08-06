<!-- README.md is generated from README.Rmd. Please edit that file -->

# deflateBR

<!-- badges: start -->

[![R-CMD-check](https://github.com/meirelesff/deflateBR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/meirelesff/deflateBR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`deflateBR` is an `R` package used to deflate nominal Brazilian Reais
using several popular price indexes.

## How does it work?

The `deflateBR`‘s main function, `deflate`, requires three mandatory
arguments to work: a `numeric` vector of nominal Reais
(`nominal_values`); a `Date` vector of corresponding dates
(`nominal_dates`); and a reference date (`real_date`), used to deflate
the values. The reference date can be provided either as a character
string in ’MM/YYYY’ format or as a Date object. Additionally, you can
specify the price index using the `index` argument and control output
verbosity with the `verbose` argument. An example:

``` r
# Load the package
library(deflateBR)

# Deflate January 2000 reais
deflate(nominal_values = 100, nominal_dates = as.Date("2000-01-01"), real_date = "01/2018")
#> No cache found for IPCA index
#> Cache not available, downloading from IPEA API...
#>   |                                                                              |                                                                      |   0%  |                                                                              |=============                                                         |  19%  |                                                                              |=========================================                             |  59%  |                                                                              |===========================================================           |  85%  |                                                                              |==================================================================    |  94%  |                                                                              |======================================================================| 100%
#> Saving IPCA data to cache...
#> Cached 547 records for IPCA index
#> [1] 310.3893
```

Behind the scenes, `deflateBR` requests data from
[IPEADATA](http://www.ipeadata.gov.br/)’s API on one these five
Brazilian price indexes:
[IPCA](https://ww2.ibge.gov.br/english/estatistica/indicadores/precos/inpc_ipca/defaultinpc.shtm)
and
[INPC](https://ww2.ibge.gov.br/english/estatistica/indicadores/precos/inpc_ipca/defaultinpc.shtm),
maintained by [IBGE](https://ww2.ibge.gov.br/home/); and
[IGP-M](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B6160B0D7D),
[IGP-DI](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B6160B0D7D),
and
[IPC](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B7350710C7)
maintained by
[FGV/IBRE](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E2C4C011D8E33F5700158).
To select one of the available price indexes, just provide one of the
following options to the `index =` argument: `ipca`, `igpm`, `igpdi`,
`ipc`, and `inpc`. In the following, the INPC index is used.

``` r
# Deflate January 2000 reais using the INPC price index
deflate(100, as.Date("2000-01-01"), "01/2018", index = "inpc")
#> No cache found for INPC index
#> Cache not available, downloading from IPEA API...
#>   |                                                                              |                                                                      |   0%  |                                                                              |=================================================                     |  70%  |                                                                              |======================================================================| 100%
#> Saving INPC data to cache...
#> Cached 556 records for INPC index
#> [1] 318.1845
```

The reference date can also be provided as a Date object for
convenience:

``` r
# Same calculation using Date object for reference date
deflate(100, as.Date("2000-01-01"), as.Date("2018-01-01"), index = "inpc")
```

For silent operation without progress messages, you can use the
`verbose` parameter:

``` r
# Silent operation - no progress messages or bars (using Date object)
deflate(100, as.Date("2000-01-01"), as.Date("2018-01-01"), index = "ipca", verbose = FALSE)
```

### Data Caching

Starting from version 1.2.0, `deflateBR` includes a caching system that
stores downloaded price index data locally to improve performance. By
default, caching is enabled and data is saved to a “cache” directory in
your working directory:

``` r
# First call downloads data and saves to cache
deflate(100, as.Date("2000-01-01"), "01/2018", "ipca")
#> No cache found for IPCA index
#> Cache not available, downloading from IPEA API...
#> Saving IPCA data to cache...
#> Cached 547 records for IPCA index

# Subsequent calls load from cache (much faster)
deflate(200, as.Date("2001-01-01"), "01/2018", "ipca")
#> Found valid cache for IPCA index (547 records)
#> Loading IPCA data from cache...
#> Loaded 547 records from cache (1979-12 to 2025-06)
```

You can disable caching if you always want fresh data from the API:

``` r
# Disable caching - always download from API
deflate(100, as.Date("2000-01-01"), "01/2018", "ipca", cache = FALSE)
```

With the same syntax, a vector of nominal Reais can also be deflated,
what is useful while working with `data.frames`:

``` r
# Create some data
df <- tibble::tibble(reais = seq(101, 200),
                     dates = seq.Date(from = as.Date("2001-01-01"), by = "month", length.out = 100)
                     )

# Reference date to deflate the nominal values
reference <- "01/2018"

# Deflate using IGP-DI
head(deflate(df$reais, df$dates, reference, "igpdi"))
#> No cache found for IGPDI index
#> Cache not available, downloading from IPEA API...
#>   |                                                                              |                                                                      |   0%  |                                                                              |===============                                                       |  21%  |                                                                              |=================                                                     |  24%  |                                                                              |=====================                                                 |  30%  |                                                                              |=======================================                               |  56%  |                                                                              |======================================================================| 100%
#> Saving IGPDI data to cache...
#> Cached 978 records for IGPDI index
#> [1] 341.0412 342.7393 344.9315 345.5051 344.9379 346.6979
```

### Working with the tidyverse

For `tidyverse` users, the `deflate` function can be easily used inside
code chains:

``` r
library(tidyverse)

df %>%
  mutate(deflated_reais = deflate(reais, dates, reference, "ipca"))
#> Found valid cache for IPCA index (547 records)
#> Loading IPCA data from cache...
#> Loaded 547 records from cache (1979-12 to 2025-06)
#> # A tibble: 100 × 3
#>    reais dates      deflated_reais
#>    <int> <date>              <dbl>
#>  1   101 2001-01-01           296.
#>  2   102 2001-02-01           297.
#>  3   103 2001-03-01           299.
#>  4   104 2001-04-01           300.
#>  5   105 2001-05-01           301.
#>  6   106 2001-06-01           303.
#>  7   107 2001-07-01           304.
#>  8   108 2001-08-01           303.
#>  9   109 2001-09-01           304.
#> 10   110 2001-10-01           306.
#> # ℹ 90 more rows
```

## Installing

Install the latest released version from CRAN with:

``` r
install.packages("deflateBR")
```

To install the development version of the package, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/deflateBR")
```

## Methodology

Following standard practice, seconded by the [Brazilian Central
Bank](https://www3.bcb.gov.br/CALCIDADAO/publico/metodologiaCorrigirIndice.do?method=metodologiaCorrigirIndice),
the `deflateBR` adjusts for inflation by multiplying nominal Reais by
the ratio between the original and the reference price indexes. For
example, to adjust 100 reais of January 2018, with IPCA index of
4916.46, to August 2018, with IPCA of 5056.56 in the previous month, we
first calculate the ratio between the two indexes (e.g., 5056.56 /
4916.46 = 1.028496) and then multiply this value by 100 (e.g., 102.84
adjusted Reais). The `deflate` function gives exactly the same result:

``` r
deflate(100, as.Date("2018-01-01"), "08/2018", "ipca")
#> Found valid cache for IPCA index (547 records)
#> Loading IPCA data from cache...
#> Loaded 547 records from cache (1979-12 to 2025-06)
#> [1] 102.8496
```

## Citation

To cite `deflateBR` in publications, please use:

``` r
citation('deflateBR')
```

## Author

[Fernando Meireles](http://fmeireles.com)
