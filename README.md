<!-- README.md is generated from README.Rmd. Please edit that file -->

# deflateBR

[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/deflateBR?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/deflateBR)

`deflateBR` is an `R` package used to deflate nominal Brazilian Reais
using several popular price indexes.

## What’s New in Version 1.2.0

This major release brings significant improvements:

-   **Simplified interface**: Unified `deflate()` function replaces
    previous wrapper functions
-   **Flexible date input**: Reference dates now accept both strings
    (‘MM/YYYY’) and Date objects  
-   **Enhanced API handling**: Improved error handling, retry
    mechanisms, and progress feedback
-   **Better user experience**: Optional verbose mode and cleaner
    architecture

See `NEWS.md` for complete details and migration guide.

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
#>   |                                                                              |                                                                      |   0%  |                                                                              |=============                                                         |  19%  |                                                                              |=========================================                             |  59%  |                                                                              |======================================================================| 100%
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
#>   |                                                                              |                                                                      |   0%  |                                                                              |===============                                                       |  21%  |                                                                              |================                                                      |  23%  |                                                                              |=============================================                         |  64%  |                                                                              |===============================================                       |  68%  |                                                                              |======================================================================| 100%
#> [1] 318.1845
```

The reference date can also be provided as a Date object for
convenience:

``` r
# Same calculation using Date object for reference date
deflate(100, as.Date("2000-01-01"), as.Date("2018-01-01"), index = "inpc")
#>   |                                                                              |                                                                      |   0%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  62%  |                                                                              |======================================================================| 100%
#> [1] 318.1845
```

For silent operation without progress messages, you can use the
`verbose` parameter:

``` r
# Silent operation - no progress messages or bars (using Date object)
deflate(100, as.Date("2000-01-01"), as.Date("2018-01-01"), index = "ipca", verbose = FALSE)
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
#>   |                                                                              |                                                                      |   0%  |                                                                              |===============                                                       |  21%  |                                                                              |=====================                                                 |  30%  |                                                                              |===========================                                           |  39%  |                                                                              |==============================================                        |  66%  |                                                                              |======================================================================| 100%
#> [1] 341.0412 342.7393 344.9315 345.5051 344.9379 346.6979
```

### Working with the tidyverse

For `tidyverse` users, the `deflate` function can be easily used inside
code chains:

``` r
library(tidyverse)

df %>%
  mutate(deflated_reais = deflate(reais, dates, reference, "ipca"))
#>   |                                                                              |                                                                      |   0%  |                                                                              |=============================                                         |  41%  |                                                                              |======================================================================| 100%
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
#>   |                                                                              |                                                                      |   0%  |                                                                              |===========================                                           |  39%  |                                                                              |======================================================                |  77%  |                                                                              |====================================================================  |  97%  |                                                                              |======================================================================| 100%
#> [1] 102.8496
```

## Citation

To cite `deflateBR` in publications, please use:

``` r
citation('deflateBR')
```

## Author

[Fernando Meireles](http://fmeireles.com)
