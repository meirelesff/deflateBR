<!-- README.md is generated from README.Rmd. Please edit that file -->
deflateBR
=========

[![Travis-CI Build
Status](https://travis-ci.org/meirelesff/deflateBR.svg?branch=master)](https://travis-ci.org/meirelesff/deflateBR)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/deflateBR?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/deflateBR)

The `deflateBR` is an `R` package used to deflate Brazilian Reias in
nominal values to current Brazilian Reais using the
[IPCA](https://pt.wikipedia.org/wiki/%C3%8Dndices_de_infla%C3%A7%C3%A3o_do_Brasil)
developed and maitained by the Brazilian Institute of Geography and
Statistics (IBGE).

How does it work?
-----------------

The `deflateBR` package uses the `tidyverse` syntax powered by pipes
(i.e., `%>%`) to deflate nominal Reais. One just needs to pass the
unquoted names of two variables to the packages’ main function, `ipca`:
one containing nominal Reais (`numeric`) and a second one contaning the
original associated dates (`Date`). An example:

``` r
library(tidyverse)
library(deflateBR)

# Create some data
df <- tibble::tibble(reais = seq(101, 200),
                     dates = seq.Date(from = as.Date("2001-01-01"), by = "month", length.out = 100)
                     )

# Reference date to deflate the nominal values
reference <- as.Date("2018-01-01")

# Deflate
df %>%
  ipca(reais, dates, reference)
#> 
#> Downloading necessary data from IBGE's Sidra.
#> ...
#> # A tibble: 100 x 4
#>    reais dates      actual_date def_values
#>    <int> <date>     <date>           <dbl>
#>  1   101 2001-01-01 2001-01-01        294.
#>  2   102 2001-02-01 2001-02-01        296.
#>  3   103 2001-03-01 2001-03-01        297.
#>  4   104 2001-04-01 2001-04-01        299.
#>  5   105 2001-05-01 2001-05-01        300.
#>  6   106 2001-06-01 2001-06-01        302.
#>  7   107 2001-07-01 2001-07-01        300.
#>  8   108 2001-08-01 2001-08-01        301.
#>  9   109 2001-09-01 2001-09-01        303.
#> 10   110 2001-10-01 2001-10-01        303.
#> # ... with 90 more rows
```

In particular, the `ipca` function requests three arguments: `values`, a
`numeric` vector containing nominal Brazilian Reais; `actual_date`, a
vector of class `Date` with the `values`’ associated dates; and
`ref_date`, an object of class `Date` containing the reference date used
to deflate the series (note that the function only deflates nominal
values by month, so `ref_date = as.Date("2018-01-20")` won’t work, but
`ref_date = as.Date("2018-01-01")` will).

Optionally, users may pass an additional argument to the function called
`outname` that sets name of the output variable created by `ipca`

Intalling
---------

To install a development version of the `deflateBR` package, use:

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
