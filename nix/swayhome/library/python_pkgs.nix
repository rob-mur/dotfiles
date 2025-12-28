{
  pkgs,
  python_withpackages ? true,
  ...
}:
with pkgs;
let

  python_pkgs =
   if python_withpackages then
     ( python3.withPackages ( ps:
      with ps; [

        ## Data Manipulation and Wrangling
        numpy
        pandas
        polars

        ## Data Exploration and Visualization
        bokeh
        great-tables
        matplotlib
        plotly
        seaborn

        ## Machine Learning and Modeling
        lightgbm
        optuna
        scikit-learn
        statsmodels
        xgboost

        ## Deep Learning
        # fastai # typer conflict
        torch
        keras
        tensorflow

        ## Natural Language Processing (NLP)
        nltk
        # spacy # typer conflict

        ## Time Series Analysis
        prophet
        statsmodels

        ## Computer Vision
        opencv-python
        torchvision

        ## Big Data and Distributed Computing
        dask

        ## Web Scraping & Automation
        beautifulsoup4
        scrapy
        selenium

        ## API and Backend Utilities
        fastapi
        flask

        ## Development Tools
        black
        cython
        euporie
        ipython
        jedi-language-server
        jupyterlab

        ## Database clients
        mysql-connector
        psycopg2
        redis
        sqlite

        ## Utility & Pipelines
        kaggle
        pydot
      ])
    )

    else
      python3;

in {

  inherit python_pkgs;

}
