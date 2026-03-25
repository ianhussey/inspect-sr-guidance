library(knitr)

# override default printing for data frames and tibbles
# round everything except p values to three decimal places
knit_print.data.frame <- function(x, ...) {
  x <- x %>% mutate(across(where(is.numeric) & !any_of(c("p", "p.value", "p_value")), roundwork::round_up, digits = 2))
  knitr::knit_print(knitr::kable(x), ...)
}

knit_print.tbl_df <- knit_print.data.frame

registerS3method("knit_print", "data.frame", knit_print.data.frame)
registerS3method("knit_print", "tbl_df", knit_print.data.frame)