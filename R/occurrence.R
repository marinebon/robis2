#' @export
occurrence <- function(
  scientificname = NULL,
  resourceid = NULL,
  areaid = NULL,
  startdate = NULL,
  enddate = NULL,
  startdepth = NULL,
  enddepth = NULL,
  geometry = NULL) {

  after = -1
  i <- 1
  total <- 0
  datalist <- list()
  size <- 5000

  t <- proc.time()

  while (TRUE) {

      query <- list(scientificname = scientificname,
        resourceid = resourceid,
        areaid = areaid,
        startdate = startdate,
        enddate = enddate,
        startdepth = startdepth,
        enddepth = enddepth,
        geometry = geometry,
        after = format(after, scientific = FALSE),
        size = size)

    result <- http_request("GET", "occurrence", query)

    stop_for_status(result, result$url)
    text <- content(result, "text", encoding = "UTF-8")
    res <- fromJSON(text, simplifyVector = TRUE )

    if (length(res$results) == 0) {
      break
    }

    after <- res$results$id[nrow(res$results)]

    if(res$total > 0) {
      datalist[[i]] <- res$results
      total <- total + nrow(res$results)
      log_progress(total, res$total)
      i <- i + 1
    }

  }

  cat("\n")
  data <- bind_rows(datalist)
  return(data)
}
