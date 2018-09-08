<!-- README.md is generated from README.Rmd. Please edit that file -->
deflateBR
=========

[![Travis-CI Build Status](https://travis-ci.org/meirelesff/deflateBR.svg?branch=master)](https://travis-ci.org/meirelesff/deflateBR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/deflateBR?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/deflateBR)

`deflateBR` is an `R` package used to deflate nominal Brazilian Reias using several popular price indexes.

How does it work?
-----------------

The `deflateBR`'s main function, `deflate`, requires three arguments to work: a `numeric` vector of nominal Reais (`nominal_values`); a `Date` vector of corresponding dates (`nominal_dates`); and a reference date in the `DD/MM/YYYY` format (`real_date`), used to deflate the values. An example:

``` r
# Load the package
library(deflateBR)

# Deflate January 2000 reais
deflate(nominal_values = 100, nominal_dates = as.Date("2000-01-01"), real_date = "01/01/2018")
#> 
#> Downloading necessary data from IPEA's API
#> ...
#> [1] 310.3893
```

Behind the scenes, `deflateBR` requests data from [IPEADATA](http://www.ipeadata.gov.br/)'s API on one these five Brazilian price indexes: [IPCA](https://ww2.ibge.gov.br/english/estatistica/indicadores/precos/inpc_ipca/defaultinpc.shtm) and [INPC](https://ww2.ibge.gov.br/english/estatistica/indicadores/precos/inpc_ipca/defaultinpc.shtm), maintained by [IBGE](https://ww2.ibge.gov.br/home/); and [IGP-M](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B6160B0D7D), [IGP-DI](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B6160B0D7D), and [IPC](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E34B9011D92B7350710C7) maintained by [FGV/IBRE](http://portalibre.fgv.br/main.jsp?lumChannelId=402880811D8E2C4C011D8E33F5700158). To select one of the available price indexes, just provide one of the following options to the `index =` argument: `ipca`, `igpm`, `igpdi`, `ipc`, and `inpc`. In the following, the INPC index is used.

``` r
# Deflate January 2000 reais using the FGV/IBRE's INCP price index
deflate(100, as.Date("2000-01-01"), "01/01/2018", index = "inpc")
#> 
#> Downloading necessary data from IPEA's API
#> ...
#> [1] 318.1845
```

With the same syntax, a vector of nominal Reais can also be deflated, what is useful while working with `data.frames`:

``` r
# Create some data
df <- tibble::tibble(reais = seq(101, 200),
                     dates = seq.Date(from = as.Date("2001-01-01"), by = "month", length.out = 100)
                     )

# Reference date to deflate the nominal values
reference <- "01/01/2018"

# Deflate using IGP-DI
head(deflate(df$reais, df$dates, reference, "igpdi"))
#> 
#> Downloading necessary data from IPEA's API
#> ...
#> [1] 341.0412 342.7393 344.9315 345.5051 344.9379 346.6979
```

### Working with the tidyverse

For `tidyverse` users, the `deflate` function can be easily used inside code chains:

``` r
library(tidyverse)

df %>%
  mutate(deflated_reais = deflate(reais, dates, reference, "ipca"))
#> 
#> Downloading necessary data from IPEA's API
#> ...
#> # A tibble: 100 x 3
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
#> # ... with 90 more rows
```

### Convenience functions

To facilitate the task of deflating nominal Reais, the `deflateBR` package also provides two convenience functions: `ipca` and `igpm`, that deflate nominal values using the IPCA and IGP-M indexes, respectively.

``` r
# Deflate January 2000 reais using the IGP-M
igpm(100, as.Date("2000-01-01"), "01/01/2018")
```

Intalling
---------

Install the latest released version from CRAN with:

``` r
install.packages("deflateBR")
```

To install the development version of the package, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/deflateBR")
```

Citation
--------

To cite `deflateBR` in publications, please use:

``` r
citation('deflateBR')
```

Author
------

[Fernando Meireles](http://fmeireles.com)
