{
  pkgs,
  julia_withpackages ? true,
  ...
}:
with pkgs;
let

  julia_list_pkgs = [

    ## Data Wrangling
    "Arrow"
    "CSV"
    "Chain"
    "DataFrames"
    "DataFramesMeta"
    # "InMemoryDatasets"
    "Missings"
    "Tables"

    ## Visualization
    # "CairoMakie"
    # "GLMakie"
    # "Makie"
    "StatsPlots"
    "VegaLite"
    "Gadfly"

    ## Machine Learning
    "Clustering"
    "DecisionTree"
    "GLM"
    "LightGBM"
    "MLJ"
    "ScikitLearn"
    "XGBoost"

    ## Optimization
    "JuMP"
    "Optim"
    "Convex"
    "SDDP"
    "HiGHS"

    ## Stats Prob
    "DifferentialEquations"
    "Distributions"
    "DynamicPPL"
    "HypothesisTests"
    "StatsBase"
    "StatsModels"
    "Turing"
    "Zygote"

    ## Deep Learning
    "Flux"
    "FluxTraining"
    "KernelAbstractions"
    "Lux"
    "Metalhead"
    "Transformers"

    ## GPU Acceleration
    # "oneAPI"
    # "CUDA"
    # "AMDGPU"

    ## NLP
    # "Embeddings"
    "TextAnalysis"
    "WordTokenizers"

    ## Time Series
    "OnlineStats"
    "StateSpaceModels"
    "TSML"
    "Temporal"
    "TimeSeries"

    ## Computer Vision
    # "Augmentor"
    "ImageFeatures"
    "ImageFiltering"
    "ImageSegmentation"
    "ImageTransformations"
    "Images"

    ## Web API & Access
    "Cascadia"
    "Gumbo"
    "HTTP"
    "JSON3"

    ## Web Frameworks
    "Genie"
    "Franklin"
    "Stipple"

    ## Dev Tools
    "BenchmarkTools"
    "Documenter"
    "IJulia"
    "LanguageServer"
    "PkgTemplates"
    "Pluto"
    "Revise"
    "Weave"

    ## Database
    "DBInterface"
    "DuckDB"
    "LibPQ"
    "MySQL"
    "ODBC"
    "SQLite"

    ## Datasets
    "DataDeps"
    "MLDatasets"
    "RDatasets"
  ];

  julia_pkgs =
    if julia_withpackages then
      julia-lts.withPackages
        julia_list_pkgs
    else
    julia-lts;
in {

  inherit julia_pkgs;

}
