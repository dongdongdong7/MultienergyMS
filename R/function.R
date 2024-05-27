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
#' @title cal_cor
#' @description
#' calculate correlation df.
#'
#' @param data A tibble.
#' @param ceLength ceLength.
#' @param noise noise.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' data(CA)
#' df <- cal_cor(CA, max_CE = 35)
cal_cor <- function(data, ceLength = 10, noise = 200, min_CE = NA, max_CE = NA){
  if(is.na(min_CE)) min_CE <- min(data$CE)
  if(is.na(max_CE)) max_CE <- max(data$CE)
  if(min_CE >= max_CE) stop("CE wrong!")
  ceIdx <- seq(min_CE, max_CE, ceLength)
  dfList <- lapply(1:(length(ceIdx) - 1), function(i) {
    ceRange <- c(ceIdx[i], ceIdx[i + 1])
    data_tmp <- data %>%
      dplyr::filter(CE >= ceRange[1] & CE <= ceRange[2])
    data_tmp[, -1][data_tmp[, -1] <= noise] <- NA
    corMatrix <- round(cor(data_tmp[, -1], use = "pairwise.complete.obs"), 2)
    mz <- colnames(corMatrix)
    df <- dplyr::tibble(mz1 = double(), mz2 = double(), correlation = double())
    for(mz1 in mz){
      for(mz2 in mz){
        correlation_tmp <- corMatrix[mz1, mz2]
        df_tmp <- dplyr::tibble(mz1 = as.double(mz1),
                                mz2 = as.double(mz2),
                                correlation = correlation_tmp)
        df <- rbind(df, df_tmp)
      }
    }
    df$range <- i
    return(df)
  })
  df <- purrr::list_rbind(dfList)
  df$correlation[is.na(df$correlation)] <- 0
  df <- df %>%
    dplyr::arrange(mz1)
  return(df)
}
#' @title paraSet
#' @description
#' Set parameters for df
#'
#'
#' @param df A tibble like demo
#' @param corThreshold Threshold of correlation
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' df <- paraSet(df = df)
paraSet <- function(df, corThreshold = 0.8){
  df$min_mz <- min(c(df$mz1, df$mz2))
  df$max_mz <- max(c(df$mz1, df$mz2))
  df$size <- df$range^3
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
#' plotMultiMS(df = df, scale_size = c(2, 10))
plotMultiMS <- function(df, scale_size = c(4, 16), stroke = 1){
  min_mz <- df$min_mz[1]
  max_mz <- df$max_mz[1]
  p <- ggplot2::ggplot(df, ggplot2::aes(x = mz1, y = mz2)) +
    ggplot2::geom_point(ggplot2::aes(size = size, col = color), stroke = stroke, shape = 21, alpha = 0.9) +
    ggplot2::scale_size(range = scale_size) +
    ggplot2::scale_color_gradient2(low = "#2600D1FF", high = "#D60C00FF", mid = "white", midpoint = 0) +
    ggplot2::theme_grey() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::ylim(min_mz - 50, max_mz + 50) +
    ggplot2::xlim(min_mz - 50, max_mz + 50)
  return(p)
}
