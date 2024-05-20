#' @title create_demo
#' @description
#' Create a demo data.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' demo <- create_demo()
create_demo <- function(){
  demo <- dplyr::tibble(mz1 = c(371, 371, 371, 371, 371, 371, 192, 192, 192),
                 mz2 = c(192, 192, 192, 73, 73, 73, 73, 73, 73),
                 range = c(1, 2, 3, 1, 2, 3, 1, 2, 3),
                 correlation = c(-0.8, -0.4, 0.5, -0.8, -0.2, 0.8, 0.2, -0.5, -0.8))
  return(demo)
}
#' @title paraSet
#' @description
#' Set parameters for df
#'
#'
#' @param df A tibble like demo
#' @param corThreshold Threshold of correlation
#'
#' @return
#' @export
#'
#' @examples
#' demo <- paraSet(df = demo)
paraSet <- function(df, corThreshold = 0.8){
  df$min_mz <- min(c(df$mz1, df$mz2))
  df$max_mz <- max(c(df$mz1, df$mz2))
  df$size <- sapply(df$range, function(x) {
    switch (x,
            "1" = 4,
            "2" = 6,
            "3" = 12
    )
  })
  df$color <- sapply(df$correlation, function(x) {
    if(abs(x) < corThreshold) return(0)
    else return(x)
  })
  return(df)
}
#' @title plotMultiMS
#' @description
#' plotMultiMS.
#'
#'
#' @param df A tibble like demo.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' plotMultiMS(df = demo)
plotMultiMS <- function(df){
  min_mz <- df$min_mz[1]
  max_mz <- df$max_mz[1]
  p <- ggplot2::ggplot(df, ggplot2::aes(x = mz1, y = mz2)) +
    ggplot2::geom_point(ggplot2::aes(size = size, col = color), stroke = 2, shape = 21, alpha = 0.9) +
    ggplot2::scale_size(range = c(4, 16)) +
    ggplot2::scale_color_gradient2(low = "#2600D1FF", high = "#D60C00FF", mid = "white", midpoint = 0) +
    ggplot2::theme_grey() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::ylim(min_mz - 50, max_mz + 50) +
    ggplot2::xlim(min_mz - 50, max_mz + 50)
  return(p)
}
