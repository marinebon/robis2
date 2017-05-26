obis_url <- function() {
  getOption("robis_url", "http://api2.iobis.org/")
}

log_progress <- function(total, count) {
  cat("\rRetrieved ", total, " records of ", count, " (", floor(total / count * 100), "%)", sep = "")
}

http_request <- function(method, path, query) {
  if (method == "GET") {
    GET(obis_url(), user_agent("robis2 - https://github.com/iobis/robis2"),
        path = path, query = query)
  } else if (method == "POST") {
    POST(obis_url(), user_agent("robis2 - https://github.com/iobis/robis2"),
         path = path, body = query)
  }
}
