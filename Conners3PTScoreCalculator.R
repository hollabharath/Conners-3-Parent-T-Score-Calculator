#!/usr/bin/env Rscript

# Check if dplyr is installed and load it silently

suppressPackageStartupMessages(library("dplyr", character.only = TRUE, quietly = TRUE))


# Function to display usage instructions
usage <- function() {
  cat("
Usage: Conners3PTScoreCalculator.R <path_to_input_csv_file>

The script requires a single CSV file path as input. 
Ensure that the CSV file contains the following columns:
- 'Age': Values should be in the range of 6 to 15.
- 'Sex': Values should be 'F', 'female', 'M', or 'male'.
- 108 columns starting with 'con3_p_' (e.g., con3_p_1, con3_p_2, ..., con3_p_108) with integer values in the range of 0 to 3.

The script generates an output file in the same directory as the input file. 
This file, named with the original file name followed by '-R+T.csv', 
will include both the raw scores (_raw) and the calculated T-scores (_t).
")
}

# Get the file path from the command line argument
args <- commandArgs(trailingOnly = TRUE)

# Check if the argument is provided, if not, show usage and exit
if (length(args) == 0) {
  usage()
  q("no")
}

input_file_path <- args[1]
dir_path <- dirname(input_file_path)
output_file_path <- paste0(sub("\\.csv$", "", input_file_path), "-R+T.csv")



# Read the input CSV file
a <- read.csv(input_file_path)


# Check if 'Age' column is present
if(!"Age" %in% names(a)) {
  stop("Error: 'Age' column missing.")
}

# Check if 'Sex' column is present
if(!"Sex" %in% names(a)) {
  stop("Error: 'Sex' column missing.")
}


# Check for the exact number of con3_p_ columns
con3_p_columns <- grep("con3_p_", names(a), value = TRUE)
if(length(con3_p_columns) != 108) {
  stop("Error: Incorrect number of 'con3_p_' columns. Expected 108, found ", length(con3_p_columns), ".")
}


# Iterate over each con3_p_ column to check ifvalues are between 0-3
for(col in con3_p_columns) {
  # Identify rows with values outside the 0-3 range
  invalid_rows <- which(a[[col]] < 0 | a[[col]] > 3, arr.ind = TRUE)

  # Check if there are any invalid rows
  if(length(invalid_rows) > 0) {
    # Report the column name and the row numbers with invalid values
    stop(sprintf("Error: Values in column '%s' are out of the 0-3 range in rows: %s.", col, paste(invalid_rows, collapse = ", ")))
  }
}



# Check Age is between 6-18 years
if(any(a$Age < 6 | a$Age > 18)) {
  stop("Error: Age values are out of the 6-18 years range.")
}

# Check Sex values
if(!all(a$Sex %in% c("F", "female", "M", "male"))) {
  stop("Error: Sex column contains invalid values. Allowed values are 'F', 'female', 'M', 'male'.")
}


# Necessary re-coding  
a <- a %>% mutate(
            con3_p_1R = case_when(con3_p_1 == 0 ~ 1, con3_p_1 == 1 ~ 1, con3_p_1 == 2 ~ 0, con3_p_1 == 3 ~ 0, TRUE ~ NA_real_),
            con3_p_8R = case_when(con3_p_8 == 0 ~ 1, con3_p_8 == 1 ~ 1, con3_p_8 == 2 ~ 0, con3_p_8 == 3 ~ 0, TRUE ~ NA_real_),
            con3_p_9R = case_when(con3_p_9 == 0 ~ 3, con3_p_9 == 1 ~ 2, con3_p_9 == 2 ~ 1, con3_p_9 == 3 ~ 0, TRUE ~ NA_real_), 
            con3_p_18R = case_when(con3_p_18 == 0 ~ 0, con3_p_18 == 1 ~ 0, con3_p_18 == 2 ~ 1, con3_p_18 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_26R = case_when(con3_p_26 == 0 ~ 0, con3_p_26 == 1 ~ 0, con3_p_26 == 2 ~ 1, con3_p_26 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_31R = case_when(con3_p_31 == 0 ~ 1, con3_p_31 == 1 ~ 0, con3_p_31 == 2 ~ 0, con3_p_31 == 3 ~ 0, TRUE ~ NA_real_), 
            con3_p_32R = case_when(con3_p_32 == 0 ~ 0, con3_p_32 == 1 ~ 0, con3_p_32 == 2 ~ 1, con3_p_32 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_33R = case_when(con3_p_33 == 0 ~ 0, con3_p_33 == 1 ~ 0, con3_p_33 == 2 ~ 0, con3_p_33 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_38R = case_when(con3_p_38 == 0 ~ 1, con3_p_38 == 1 ~ 0, con3_p_38 == 2 ~ 0, con3_p_38 == 3 ~ 0, TRUE ~ NA_real_), 
            con3_p_42R = case_when(con3_p_42 == 0 ~ 0, con3_p_42 == 1 ~ 0, con3_p_42 == 2 ~ 1, con3_p_42 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_64R = case_when(con3_p_64 == 0 ~ 3, con3_p_64 == 1 ~ 2, con3_p_64 == 2 ~ 1, con3_p_64 == 3 ~ 0, TRUE ~ NA_real_), 
            con3_p_72R = case_when(con3_p_72 == 0 ~ 3, con3_p_72 == 1 ~ 2, con3_p_72 == 2 ~ 1, con3_p_72 == 3 ~ 0, TRUE ~ NA_real_), 
            con3_p_74R = case_when(con3_p_74 == 0 ~ 0, con3_p_74 == 1 ~ 0, con3_p_74 == 2 ~ 0, con3_p_74 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_80R = case_when(con3_p_80 == 0 ~ 0, con3_p_80 == 1 ~ 0, con3_p_80 == 2 ~ 0, con3_p_80 == 3 ~ 1, TRUE ~ NA_real_), 
            con3_p_105R = case_when(con3_p_105 == 0 ~ 0, con3_p_105 == 1 ~ 0, con3_p_105 == 2 ~ 0, con3_p_105 == 3 ~ 1, TRUE ~ NA_real_)
            )

question_numbers_by_domain <- list(
  IN = c(12, 23, 28, 44, 47, 49, 67, 77, 88, 95),
  HY = c(19, 43, 45, 50, 52, 54, 55, 61, 69, 71, 93, 98, 99, 104), 
  LP = c(5, 7, "9R", 15, 36, 51, 53, 60, 87), 
  EF = c(34, 37, 63, "72R", 75, 79, 84, 90, 97), 
  AG = c(16, 22, 27, 30, 39, 46, 48, 57, 58, 65, 83, 86, 94, 102), 
  PR = c(10, 13, 24, 62, "64R", 92), 
  GI = c(19, 25, 29, 34, 40, 50, 67, 81, 85, 99),
  AN = c(2, 28, 35, 47, 68, 79, 84, 95, 97, 101),
  AH = c(3, 43, 45, 54, 61, 69, 71, 93, 98, 99, 104), 
  CD = c(6, 11, 16, 27, 30, 39, 41, 56, 58, 65, 76, 78, 89, 91, 96), 
  OD = c(14, 21, 48, 57, 59, 73, 94, 102), 
  PI = c("31R", "33R", "38R", "74R", "80R", "105R"), 
  NI = c("1R", "8R", "18R", "26R", "32R", "42R") 
)


# Initialize a dataframe to store the raw scores
raw_scores <- data.frame(
                    matrix(
                      ncol = length(question_numbers_by_domain),
                      nrow = nrow(a)
                      )
                    )
colnames(raw_scores) <- paste0(names(question_numbers_by_domain), "_raw")

# Bind the raw_scores dataframe to 'a'
a <- cbind(a, raw_scores)

# Calculate the raw sum scores for each domain directly in 'a'
for (domain in names(question_numbers_by_domain)) {
  question_cols <- paste0("con3_p_", question_numbers_by_domain[[domain]])
  domain_raw <- paste0(domain, "_raw") 
  a[[domain_raw]] <- apply(a[, question_cols], 1, function(x) {
    if (all(is.na(x))) {
      return(NA)
    } else {
      return(sum(x, na.rm = TRUE))
    }
  })
}



# Transform 'F' and 'M' to 'female' and 'male'
a <- a %>%
  mutate(Sex = case_when(
    Sex == "F" ~ "female",
    Sex == "M" ~ "male",
    TRUE ~ NA_character_  # Handling unexpected values
  ))

# Define the domains for which T-scores are needed
domains <- c("IN", "HY", "LP", "EF", "AG", "PR", "GI","AN","AH","CD","OD")

# Function to lookup T-score
lookup_t_score <- function(age, raw_score, sex, domain) {
  # Handle NA raw scores immediately
  if (is.na(raw_score)) {
    return(NA)
  }
  
  csv_file <- file.path(dir_path, paste0("Conners-3-P-T-Scoring-Grid/",sex, '_', tolower(domain), '.csv'))

    if (!file.exists(csv_file)) {
    return(NA)  # Return NA if file does not exist
  }
  
  t_score_df <- read.csv(csv_file)
  
  age_column <- paste0("A", age)
  if (!age_column %in% names(t_score_df)) {
    return(NA)  # Return NA if age column is not found
  }
  
  # Find the highest T-score where the child's raw score is equal to or greater than the threshold
  t_score_row <- which(t_score_df[[age_column]] <= raw_score, arr.ind = TRUE)
  if (length(t_score_row) == 0) {
    return(90)  # Return 90 if raw score is higher than any listed scores
  } else {
    return(max(t_score_df$T[t_score_row]))
  }
}


# Calculate T-scores for each domain and bind to dataframe 'a'
for (domain in domains) {
  domain_raw <- paste0(domain, "_raw")
  domain_t <- paste0(domain, "_t")
  
  # Use sapply for a consistent output length
  t_scores <- sapply(seq_len(nrow(a)), function(i) {
    lookup_t_score(a$Age[i], a[[domain_raw]][i], a$Sex[i], domain)
  })
  
  # Debug: Check if the length of t_scores matches the number of rows in 'a'
  if (length(t_scores) != nrow(a)) {
    stop("Error: Length of T-scores does not match the number of rows in the dataframe")
  }
  
  a[[domain_t]] <- t_scores
}

# Export the dataframe with Domain wise Raw and T-scores
write.csv(a, output_file_path, row.names = FALSE, na = "")