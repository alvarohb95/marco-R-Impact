library(cleaningtools)
library(dplyr)

my_raw_dataset <- cleaningtools::cleaningtools_raw_data
my_kobo_survey <- cleaningtools::cleaningtools_survey
my_kobo_choice <- cleaningtools::cleaningtools_choices

# head(my_raw_dataset)
# head(my_kobo_survey)
# head(my_kobo_choice)

# verificación para detectar información de identificación personal
my_raw_dataset %>% 
  check_pii(uuid_column = "X_uuid")

# verificación que examine los porcentajes de valores faltantes por encuesta y que señale cualquier observación atípica
my_data_with_missing <- my_raw_dataset %>% 
  add_percentage_missing(kobo_survey = my_kobo_survey)

my_data_with_missing %>% 
  check_percentage_missing(uuid_column = "X_uuid")

# Práctica 3 con verificaciones

my_check_list <- data.frame(check_id = c("check_household number", "check_water_treatment", "check_water_pressure"),
                            description = c("num_hh_member is big","using bottled water and always treat","using bottled water and main reason is water pressure"),
                            check_to_perform = c("num_hh_member > 8","water_source_drinking == \"bottled\" & treat_drink_water == \"always_treat\"","water_source_drinking == \"bottled\" & access_water_enough_why_not.water_pressure == TRUE"),
                            columns_to_clean = c("num_hh_member","water_source_drinking, treat_drink_water","water_source_drinking, access_water_enough_why_not.water_pressure"))

data_logical_check <- my_raw_dataset %>% 
  check_logical_with_list(uuid_column = "X_uuid",
                          list_of_check = my_check_list,
                          check_id_column = "check_id",
                          check_to_perform_column = "check_to_perform",
                          columns_to_clean_column = "columns_to_clean",
                          description_column = "description")

writexl::write_xlsx(data_logical_check, path = "../outputs/check_logical_results.xlsx")

# Insertar audio audit file

if (FALSE) { # \dontrun{
  create_audit_list("audit_path.zip")
} # }


add_duration_from_audit(
  my_raw_dataset,
  col_name_prefix = "duration_audit",
  uuid_column = "uuid",
  audit_list,
  start_question = NULL,
  end_question = NULL,
  sum_all = TRUE
)



