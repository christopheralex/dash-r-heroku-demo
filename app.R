# Author - Christopher Alexander 

library(dash)
# library(dashCoreComponents)
# library(dashHtmlComponents)
# library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

data <- readr::read_csv(here::here('data', 'spotify.csv'))

app$layout(
    dbcContainer(
        dbcRow(
            list(
                dbcCol(
                    list(
                        htmlLabel('Left'),
                        dccDropdown(
                            options = unique(data$track_artist) |> 
                                purrr::map(function(value) list(label = value, value = value)),
                            value = 'artist-id'
                        )
                    )
                ),
                dbcCol(
                    list(
                        htmlLabel('Right'),
                        dccDropdown(
                            options = list(list(label = "New York City", value = "NYC"),
                                           list(label = "San Francisco", value = "SF")),
                            value = 'SF'
                        )
                    )
                )
            )
        ), style = list('max-width' = '85%')  # Change left/right whitespace for the container
    )
)

app$run_server(debug = T)