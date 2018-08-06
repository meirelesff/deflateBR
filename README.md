<!-- README.md is generated from README.Rmd. Please edit that file -->
The `ipca` deflates Brazilian Reias in nominal values to current
Brazilian Reais using the
[IPCA](https://pt.wikipedia.org/wiki/%C3%8Dndices_de_infla%C3%A7%C3%A3o_do_Brasil)
developed and maitained by the Brazilian Institute of Geography and
Statistics (IBGE).

How does it work?
=================

To deflate nominal values in Reais using the `ipca` package, one just
need to pass a vector with the nominal values, their original dates and
a reference date used to deflate the series. An example:

``` r
library(ipca)

# Create some data
reais <- seq(101, 200)
actual_dates <- seq.Date(from = as.Date("2001-01-01"), by = "month", length.out = 100)

# Deflate nominal values to January 2018
reference <- as.Date("2018-01-01")

# Create a vector with fake dates
ipca(reais, actual_dates, reference)
```

In particular, the `ipca` function requests three arguments: `values`, a
`numeric` vector containing nominal Brazilian Reais; `actual_date`, a
vector of class `Date` with the `values`’ associated dates; and
`ref_date`, an object of class `Date` containing the reference date used
to deflate the series (note that the function only deflates nominal
values by month, so `ref_date = as.Date("2018-01-20")` won’t work, but
`ref_date = as.Date("2018-01-01")` will).

Intalling
---------

To install a development version of the `ipca` package, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/ipca")
```
