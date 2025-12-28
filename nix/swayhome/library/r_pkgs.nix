{
  pkgs,
  r_withpackages ? true,
  rstudio_withpackages ? false,
  ...
}:
with pkgs;
let

  r_list_pkgs =
   with rPackages; [
    ## Data Manipulation and Wrangling
    DBI
    DT
    data_table
    dplyr
    janitor
    lubridate
    purrr
    readr
    stringr
    tidyr
    tidyverse

    ## Data Exploration and Visualization
    DataExplorer
    GGally
    RColorBrewer
    ggplot2
    ggraph
    plotly
    skimr
    summarytools

    ## Machine Learning and Modeling
    MASS
    caret
    caretEnsemble
    e1071
    glmnet
    h2o
    kernlab
    lightgbm
    mlr3
    randomForest
    superml
    xgboost

    ## Deep Learning
    fastai
    keras
    luz
    tensorflow
    tfprobability
    torch
    torchdatasets
    torchopt
    torchvision

    ## Natural Language Processing (NLP)
    quanteda
    tm

    ## Time Series Analysis
    feasts
    forecast
    prophet
    tseries
    tsibble
    xts

    ## Spatial Data Analysis
    ggmap
    leaflet

    ## Database Interaction
    RSQLite
    dbplyr
    duckdb
    haven
    sqldf
    RPostgres
    redux

    ## Performance and Parallel Computing
    Rcpp
    arrow
    pbdZMQ

    ## Reproducibility and Reporting
    IRdisplay
    IRkernel
    gt
    kableExtra
    knitr
    languageserver
    lintr
    # prettifyAddins # broken
    qrcode
    quarto
    renv
    repr
    rmarkdown
    rsconnect
    stargazer
    targets
    tinytex

    ## Api and Web Scraping
    # Rcrawler # broken
    httr
    jsonlite
    rvest
    xml2

    ## Interactive Apps & Dashboards
    DT
    rhino
    shiny

    ## Big Data & Distributed Computing
    arrow
    sparklyr

    ## Julia Integration
    JuliaCall
    JuliaConnectoR
    JuliaFormulae

    ## R and Python Integration
    reticulate

    ## Management Project
    renv
    pipenv
    usethis
    
  ];

  r_pkgs =
    if r_withpackages then
      rWrapper.override {
        packages = r_list_pkgs;
    }
    else
      R;

  rstudio_pkgs =
    if rstudio_withpackages then
      rstudioWrapper.override {
        packages = r_list_pkgs;
    }
    else
      rstudio;

in {

  inherit r_pkgs;
  inherit rstudio_pkgs;

}
