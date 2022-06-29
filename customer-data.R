library(gt)
library(tidyverse)

# Read in the customer data with `readr::read_csv()`
customer_data <-
  readr::read_csv(
    file = "customer_data.csv",
    col_types = cols(
      company = col_character(),
      contact_name = col_character(),
      contact_email = col_character(),
      contact_phone = col_character(),
      product = col_character()
    )
  )

# Create the gt table
gt(customer_data) %>%
  tab_options(row_group.as_column = TRUE) %>%
  cols_label(
    contact_name = "Name",
    contact_email = "Email",
    contact_phone = "Phone"
  ) %>%
  tab_spanner(
    label = "Contact Information",
    columns = starts_with("contact")
  ) %>%
  text_transform(
    locations = cells_body(columns = product),
    fn = function(x) {
      gsub("Product A, Product B", "Products A & B", x, fixed = TRUE)
    }
  ) %>%
  cols_move(columns = product, after = company) %>%
  tab_header(
    title = "Our Current List of Customers",
    subtitle = "Contains up-to-date contact information."
  ) %>%
  tab_style(
    style = cell_text(
      font = google_font("Inconsolata"),
      size = "small"
    ),
    locations = cells_body(columns = starts_with("contact"))
  ) %>%
  tab_style(
    style = cell_text(
      font = google_font("Source Sans Pro"),
      size = "small"
    ),
    locations = cells_body(columns = !starts_with("contact"))
  ) %>%
  opt_all_caps() %>%
  opt_align_table_header("left") %>%
  tab_source_note(source_note = md(
    "Data was last updated on `2022-05-28`."
  ))
