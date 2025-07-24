# Librerias
library(dplyr)
library(data.table)
libaray(plurr)
#--------transformación-datos-----------
filtro_E_M <- filtro_E_M %>%
  select(cve_municipio, `descripción municipio`)
#-------Insertar-nombres-entidades-------------
# Función para reemplazar valores en cve_municipio usando el dataframe de mapeo
replace_cve_with_description <- function(df, map_df) {
  # Realizar un left join para agregar la descripción a la tabla
  df <- df %>%
    left_join(map_df, by = "cve_municipio") %>%
    mutate(cve_municipio = `descripción municipio`) %>%
    select(-`descripción municipio`) # Eliminar la columna extra después del join
  
  return(df)
}

# Aplicar la función a cada dataframe en la lista
Lista2000_2024 <- map(Lista2000_2024, function(sublist) {
  map(sublist, function(df) {
    replace_cve_with_description(df, filtro_E_M)
  })
})
# Parte para Insertar fechas ----------------------------------------------
# Generar el Codigo para hacer el dataframe con municipios
# Función para añadir una columna de fecha basada en el mes y año
add_month_year_to_df <- function(df, year, month) {
  # Crear la fecha en formato "YYYY-MM"
  fecha <- as.Date(sprintf("%d-%02d-01", year, month))
  # Añadir la columna de fecha al data frame
  df_with_date <- df %>% mutate(Fecha = fecha)
  # Reordenar las columnas para que 'Fecha' sea la primera
  df_with_date <- df_with_date %>% select(Fecha, everything())
  
  return(df_with_date)
}

# Iterar sobre cada sublista y data frame en Lista2000_2024
Lista2000_2024_con_fechas <- lapply(seq_along(Lista2000_2024), function(year_index) {
  # Determinar el año para la sublista actual
  year <- 2000 + year_index - 1
  
  # Aplicar la función a cada data frame en la sublista
  lapply(seq_along(Lista2000_2024[[year_index]]), function(month_index) {
    # Determinar el mes (1-12)
    month <- month_index
    
    # Obtener el data frame actual
    df <- Lista2000_2024[[year_index]][[month_index]]
    
    # Añadir la columna de fecha
    add_month_year_to_df(df, year, month)
  })
})

# Convertir la lista de listas en una lista nombrada igual a la original
names(Lista2000_2024_con_fechas) <- names(Lista2000_2024)


# Parte para generar Subtotales -------------------------------------------
# Generar Sumas de Municipios
columnas_numericas <- c("asegurados", "no_trabajadores", "ta", "teu", "tpu", "tec", "tpc", "tec_sal", "tpc_sal", 
                        "masa_sal_tec", "masa_sal_tpc", "ta_sal", "teu_sal", "tpu_sal", "masa_sal_ta", "masa_sal_teu", "masa_sal_tpu")
# Función mejorada para agregar subtotales por cve_municipio y total global, manteniendo la columna Fecha
add_totals <- function(df) {
  # Selecciona solo las columnas numéricas para el cálculo de subtotales
  columnas_presentes <- intersect(columnas_numericas, names(df))
  
  # Genera los subtotales por municipio, manteniendo la columna Fecha
  subtotals <- df %>%
    group_by(cve_municipio, Fecha) %>%  # Agrupa también por la columna Fecha
    summarise(across(all_of(columnas_presentes), sum, na.rm = TRUE)) %>%
    ungroup()
  
  # Genera la fila con el total global para cada fecha
  total_row <- subtotals %>%
    group_by(Fecha) %>%  # Agrupa también por la columna Fecha
    summarise(across(all_of(columnas_presentes), sum)) %>%
    mutate(cve_municipio = "Total") %>%
    ungroup()
  
  # Combina los subtotales con la fila del total global
  df_with_totals <- bind_rows(subtotals, total_row)
  
  return(df_with_totals)
}
#Año inicial y final
ano_inicial <- 2000
ano_final <- 2024
# Generar los nombres de sublistas
sublist_names <- paste0("Lista", ano_inicial:ano_final)


# Aplicar la función de subtotales a los datos procesados
Tbls_years <- lapply(sublist_names, function(name) {
  Lista2000_2024_con_fechas[[name]] <- lapply(Lista2000_2024_con_fechas[[name]], add_totals)
  return(rbindlist(Lista2000_2024_con_fechas[[name]], use.names = TRUE, fill = TRUE))
})


# Exportar Datos ----------------------------------------------------------
# Exportar datos a archivos Excel
for (i in seq_along(Tbls_years)) {
  year <- get_year(i)
  write_xlsx(Tbls_years[[i]], paste0("E:/Users/YORA/Documents/guardado_años/BC-9204/tbl_", year, ".xlsx"))
}


# Union de data-frames
Serie_Tiempo_Municipios°_BC <- rbindlist(Tbls_years)
