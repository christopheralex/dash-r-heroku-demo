# Author - Christopher Alexander 

library(dash)
# library(dashCoreComponents)
library(dashHtmlComponents)
# library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

data <- readr::read_csv(here::here('data', 'spotify.csv'))

data <- tidyr::drop_na(data)

artist <- unique(data$track_artist) %>% purrr::map(function(art) list(label = art, value = art))

app$layout(
    dbcContainer(
        dbcRow(
            list(
                htmlH1('Dashr spotify-ex'),
                dbcCol(
                    list(
                        htmlLabel('Artist'),
                        dccDropdown(
                            id = 'artist-id',
                            options = artist,
                            # options = data %>% colnames %>% purrr::map(function(col) list(label = col, value = col)),
                            value = 'artist'
                        )
                    )
                ),
                dbcCol(
                    list(
                        htmlH4('Artist popularity record'),
                        dccGraph(id='artist_pop_hist_id')
                    )
                )
            )
        ), style = list('max-width' = '85%')  # Change left/right whitespace for the container
    )
)

app$callback(
    output('artist_pop_hist_id', 'figure'),
    list(input('artist-id', 'value')),
    function(xcol="Ed Sheeran") {
        chart <- ggplot2::ggplot(data %>% dplyr::filter(track_artist == xcol)) + aes(
            x = track_popularity ) + ggplot2::geom_histogram() + ggplot2::geom_vline(
                data = data %>% dplyr::filter(track_artist == xcol),
                aes(xintercept = mean(track_popularity),
                    colour="red")) + ggplot2::labs(
                        x = "Track popularity",
                        y = "Count",
                        colour="Mean popluarity" ) 
        ggplotly(chart) %>% layout(dragmode = 'select')
    }
)

app$run_server(host = '0.0.0.0')