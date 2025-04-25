library(readr)
library(dplyr)

## DATA LOADING AND CLEANING ##

############ UK DATA ######################

# Load female life table
uk_female <- read_table("data/fltper_1x1.txt", skip = 2) %>% 
  filter(Year == 2022) %>% 
  select(Age, qx, ex)%>%
  mutate(Country = "UK", Sex = "Female")

# Load male life table
uk_male <- read_table("data/mltper_1x1.txt", skip = 2) %>%
  filter(Year == 2021) %>%
  select(Age, qx, ex)%>%
  mutate(Country = "UK", Sex = "Male")

uk_data <- bind_rows(uk_female, uk_male)  # Bind gender data together

############ US DATA ########################

# Load female life table
us_female <- read_table("data/US_fltper_1x1.txt", skip = 2) %>% 
  filter(Year == 2022) %>% 
  select(Age, qx, ex)%>%
  mutate(Country = "US", Sex = "Female")

# Load male life table
us_male <- read_table("data/US_mltper_1x1.txt", skip = 2) %>%
  filter(Year == 2021) %>%
  select(Age, qx, ex)%>%
  mutate(Country = "US", Sex = "Male")

us_data <- bind_rows(us_female, us_male)

############ JAPAN DATA #######################

# Load female life table
j_female <- read_table("data/J_fltper_1x1.txt", skip = 2) %>% 
  filter(Year == 2022) %>% 
  select(Age, qx, ex)%>%
  mutate(Country = "Japan", Sex = "Female")

# Load male life table
j_male <- read_table("data/J_mltper_1x1.txt", skip = 2) %>%
  filter(Year == 2021) %>%
  select(Age, qx, ex)%>%
  mutate(Country = "Japan", Sex = "Male")

j_data <- bind_rows(j_female, j_male)

##################################################

combined <- bind_rows(uk_data, us_data, j_data)  # Combine all countries



####### Visualisations ##########

###### Mortality rate ##########

library(ggplot2)

ggplot(combined, aes(x = as.numeric(Age), y = qx, color = Country, linetype = Sex)) +
  geom_line(size = 1) +
  scale_y_log10() +
  labs(
    title = "Probability of Death by Age (2022)",
    subtitle = "Log scale | Source: Human Mortality Database",
    x = "Age (years)",
    y = "Probability of Death (qₓ)",
    color = "Country",
    linetype = "Sex"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "white"),
    plot.subtitle = element_text(size = 12, color = "white"),
    axis.title = element_text(face = "bold", color = "white"),
    axis.text = element_text(color = "white"),
    legend.title = element_text(face = "bold", color = "white"),
    legend.text = element_text(color = "white"),
    legend.position = "bottom",
    panel.background = element_rect(fill = NA, color = NA),
    plot.background = element_rect(fill = NA, color = NA),
    legend.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20")
  )


######## life expectancy (at birth) ##########

e0_data <- combined %>%
  filter(Age == "0") %>%
  select(Country, Sex, ex)

library(ggplot2)

ggplot(e0_data, aes(x = interaction(Country, Sex), y = ex, fill = Country)) +
  geom_col(width = 0.6, color = "white") +
  labs(
    title = "Life Expectancy at Birth (e₀)",
    subtitle = "Based on 2022 Period Life Tables | Source: Human Mortality Database",
    x = "Country & Sex",
    y = "Life Expectancy (years)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "white"),
    plot.subtitle = element_text(size = 12, color = "white"),
    axis.title = element_text(face = "bold", color = "white"),
    axis.text = element_text(color = "white"),
    legend.title = element_text(face = "bold", color = "white"),
    legend.text = element_text(color = "white"),
    legend.position = "bottom",
    panel.background = element_rect(fill = NA, color = NA),
    plot.background = element_rect(fill = NA, color = NA),
    legend.background = element_rect(fill = NA, color = NA),
    legend.key = element_rect(fill = NA, color = NA),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20")
  )


################ Save Plots as PNGs ########################

ggsave("plots/qx_by_age.png", width = 8, height = 6, dpi = 300)

ggsave("plots/ex_at_birth.png", width = 8, height = 6, dpi = 300)


