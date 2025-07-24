# Codigo para generar que no elimina las columnas relevantes
# Librerias ---------------------------------------------------------------
library(dplyr)
library(readxl)
library(lubridate)
library(tidyr)
library(stringr)
library(readr)
library(data.table)
library(rappdirs)
library(openxlsx)
library(writexl)
# Directorio base y Lista para almacenar los resultados por año
directorio_base <- "E:/Users/YORA/Desktop/BaseDat/"
Lista2000_2024 <- list()


# Filtro ------------------------------------------------------------------
# Lectura de archivos y Iterar desde el año 2000 hasta el 2024
hora_actual <- Sys.time()#Imprimir hora
print(hora_actual)
for (ano in 2000:2024) {
# Construir la ruta del archivo utilizando el año
  ruta_archivos <- list.files(
    path = sprintf("%sasg_%04d", directorio_base, ano),
    pattern = sprintf("asg-%04d-\\d{2}-\\d{2}.csv", ano),
    full.names = TRUE)
  
columnas_numericas <- c("asegurados", "no_trabajadores", "ta", "teu", "tpu", "tec", "tpc", "tec_sal", "tpc_sal", 
    "masa_sal_tec", "masa_sal_tpc", "ta_sal", "teu_sal", "tpu_sal", "masa_sal_ta", "masa_sal_teu", "masa_sal_tpu")
# Verificar si hay archivos que coincidan con el patrón
  if (length(ruta_archivos) > 0) {
# Leer los datos y procesarlos
    DatosF <- lapply(ruta_archivos, function(cbz) {
      datos <- fread(cbz, na.strings = c("", "NA"), encoding = "Latin-1") %>%
        filter(cve_entidad == "2" &
            (cve_municipio %in% cve_municipio_filter) &
            sector_economico_1 == "8" &
            sector_economico_2 == "84" &
            sector_economico_4 == "8401")
      # Verificar si la columna 'rango_uma' existe antes de eliminarla
      if ("rango_uma" %in% colnames(datos)) {datos <- datos %>% select(-c("rango_uma"))} 
      else {# La columna 'rango_uma' no está presente, así que solo eliminamos otras columnas
        datos <- datos %>% select(-c())}
      datos %>% mutate(across(all_of(columnas_numericas), as.numeric))
    })
# Almacenar los resultados en la lista
Lista2000_2024[[paste0("Lista", ano)]] <- DatosF
  }
  }

#Cambiar el nombre de la columna del mes 12 de 2024 dado que lo devuelve como otro elemento
names(Lista2000_2024[["Lista2023"]][[12]])[names(Lista2000_2024[["Lista2023"]][[12]]) == "tamaÃ±o_patron"] <- "tamaño_patron"
names(Lista2000_2024[["Lista2024"]][[1]])[names(Lista2000_2024[["Lista2024"]][[1]]) == "tamaÃ±o_patron"] <- "tamaño_patron"


# agrega totales de las columnas
add_totals <- function(lt) {
  total_row <- lt %>%
    summarise(
      ta = sum(ta),
      teu = sum(teu),
      tec = sum(tec),
      tpu = sum(tpu),
      tpc = sum(tpc),
      ta_sal = sum(ta_sal),
      teu_sal = sum(teu_sal),
      tec_sal = sum(tec_sal),
      tpu_sal = sum(tpu_sal),
      tpc_sal = sum(tpc_sal),
      masa_sal_ta = sum(masa_sal_ta),
      masa_sal_teu = sum(masa_sal_teu),
      masa_sal_tec = sum(masa_sal_tec),
      masa_sal_tpu = sum(masa_sal_tpu),
      masa_sal_tpc = sum(masa_sal_tpc)
    ) %>%
    mutate(cve_municipio = "Total")
  
  df_with_total <- bind_rows(lt, total_row)
  return(df_with_total)
}

#Año inicial y final
ano_inicial <- 2000
ano_final <- 2024
# Generar los nombres de sublistas
sublist_names <- paste0("Lista", ano_inicial:ano_final)


Tbls_years <- lapply(sublist_names, function(name) {
  Lista2000_2024[[name]] <- lapply(Lista2000_2024[[name]], add_totals)
  return(rbindlist(Lista2000_2024[[name]], use.names =FALSE))
})


# EXPORTAR DATOS ACOTADOS -------------------------------------------------
#Transforma los datos para que se adapten
# Escribe cada dataframe en un archivo Excel separado en la ruta especificada
# Función para obtener el año correspondiente según el índice
get_year <- function(index) {
  if (index <= 24) {
    return(2000 + index - 1)
  } else {
    return(2024)
  }
}

# Iteración sobre los elementos de Tbls_years
for (i in seq_along(Tbls_years)) {
  year <- get_year(i)  # Obtener el año correspondiente al índice
  write_xlsx(Tbls_years[[i]], paste0("E:/Users/YORA/Documents/guardado_años/BC-9204/tbl_", year, ".xlsx"))
}

# unir data-frames --------------------------------------------------------

# Aqui se junta si no se va exportar
Terminado <- rbindlist(Tbls_years)
#Generar fechas y unirlo al data frame
FLDU <- function(Terminado) {
  # Filtrar filas donde la columna "cve_municipio" es igual a "Total"
  terminado_filtrado <- Terminado %>% filter(cve_municipio == "Total") %>% select(-c(1:13))
  
  # Generar la secuencia de fechas
  fechas <- seq(as.Date("2000-01-01"), as.Date("2024-07-01"), by = "months")
  
  # Crear un data frame con la columna "Fecha" y unirlo con el data frame filtrado
  terminado_filtrado <- data.frame(Fecha = fechas) %>% bind_cols(terminado_filtrado)
  
  return(terminado_filtrado)
}
# Llamar a la función cuando sea necesario
Serie_Tiempo <- FLDU(Terminado)

# Division para obtener el salario Base
Serie_Tiempo_2000_2024_BC <- {Serie_Tiempo %>%
    mutate(
      Salario_Base_ta = masa_sal_ta / ta_sal,
      Salario_Base_teu = masa_sal_teu / teu_sal,
      Salario_Base_tec = masa_sal_tec / tec_sal,
      Salario_Base_tpu = masa_sal_tpu / tpu_sal,
      Salario_Base_tpc = masa_sal_tpc / tpc_sal
      
    )
}


# Remover elementos -------------------------------------------------------
# Eliminar todos los elementos generados en el script
rm(list = c("directorio_base", "ruta_archivos", "columnas_numericas", "DatosF", "add_totals", "ano", "hora_actual",
            "ano_inicial", "ano_final", "sublist_names", "Tbls_years", "Terminado", "filtro_E_M" , "cve_municipio_filter"  , "FLDU", "Serie_Tiempo"))



