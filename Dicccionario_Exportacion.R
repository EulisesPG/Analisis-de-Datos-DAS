# Diccionarios de Datos ---------------------------------------------------
library(readxl)
library(dplyr)
# Especifica la ruta completa del archivo Excel
archivo_excel <- "E:/Users/YORA/Downloads/diccionario_de_datos_1(1).xlsx"

# Lee la hoja 'delegación-subdelegación' y la hoja 'entidad-municipio'
Delegacion_Subdelegacion <- read_excel(archivo_excel, sheet = "delegación-subdelegación")
Entidad_Municipio <- read_excel(archivo_excel, sheet = "entidad-municipio")

# Filtro de Jalisco
filtro_E_M <- filter(Entidad_Municipio, `descripción entidad` == "Sonora",`cve_entidad` == "26")
filtro_E_M <- filter(Entidad_Municipio, `descripción entidad` == "Baja California", `cve_delegacion` == "2",`cve_entidad` == "02")


# crea el filtro de municipio
filtro_E_M <- filter(Entidad_Municipio, `descripción municipio` == "Tijuana", `cve_delegacion` == "2",`cve_entidad` == "02")
filtro_E_M <- filter(Entidad_Municipio, `descripción municipio` == "Guadalajara", `cve_delegacion` == "14",`cve_entidad` == "14")

# Imprimir los valores únicos de la columna "cve_municipio"
cve_municipio_filter<-(unique(filtro_E_M$cve_municipio))
##print caracteres
print(cve_municipio_filter)

rm(Delegacion_Subdelegacion,Entidad_Municipio,archivo_excel)






# Exportar ----------------------------------------------------------------
#Solo una base 2
# Solo para la exportacion de una sola base de datos
library(openxlsx)

# Crear un libro de trabajo
wb <- createWorkbook()
# Modificar la fuente y el tamaño del workbook
modifyBaseFont(wb, fontName = "Consolas", fontSize = 12)
# Agregar hojas al libro de trabajo con los nombres deseados

hoja_BC <- "Baja California"
hoja_JLC <- "Sonora"
addWorksheet(wb, hoja_BC)
addWorksheet(wb, hoja_JLC)
# Ejemplo de datos (reemplazar con tus datos)
datos_BC <- Serie_Tiempo_2000_2024_BC
datos_JLC <- Serie_Tiempo_2000_2024_SNR

# Crear estilos para las filas
estilo_blanco <- createStyle(bgFill = "#EDD1D2", border = "TopBottomLeftRight", borderColour = "black", borderStyle = "thin")
estilo_verde <- createStyle(bgFill = "#A67FAB", border = "TopBottomLeftRight", borderColour = "black", borderStyle = "thin")

# Aplicar estilos alternativamente a las filas para Serie_Tiempo_2000_2024_BC
for (i in 1:nrow(datos_BC)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_BC, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_BC, estilo_verde, rows = i + 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para Serie_Tiempo_2000_2024_NVL
for (i in 1:nrow(datos_JLC)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_JLC, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_JLC), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_JLC, estilo_verde, rows = i + 1, cols = 1:ncol(datos_JLC), gridExpand = TRUE)
  }
}


# Especificar la ruta del archivo
Ruta_archivo <- "E:/Users/YORA/Documents/guardado_años/Serie_Tiempo_2000_2024_BC_SNR_3801.xlsx"

# Escribir los datos en las hojas
writeData(wb, hoja_BC, datos_BC)
writeData(wb, hoja_JLC, datos_JLC)

# Crear un estilo con fondo verde forestal para las cabeceras
estilo_cabecera <- createStyle(fgFill = "#554690", textDecoration = "bold", halign = "center")

# Aplicar el estilo a las cabeceras de las columnas para ambas hojas
addStyle(wb, hoja_BC, estilo_cabecera, rows = 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
addStyle(wb, hoja_JLC, estilo_cabecera, rows = 1, cols = 1:ncol(datos_JLC), gridExpand = TRUE)

# Guardar el archivo
saveWorkbook(wb, Ruta_archivo, overwrite = TRUE)

#-----Base-completa-categorias
#%primer exportacion%
library(openxlsx)

# Crear un libro de trabajo
wb <- createWorkbook()
# Modificar la fuente y el tamaño del workbook
modifyBaseFont(wb, fontName = "Consolas", fontSize = 12)
# Agregar hojas al libro de trabajo con los nombres deseados

hoja_BC <- "BC"
hoja_GJT <- "BCS"
hoja_edad_BC <- "Edad_BC"
hoja_SX_BC <- "Sexo_BC"
hoja_edad_GJT <- "Edad_BCS"
hoja_SX_GJT <- "Sexo_BCS"

addWorksheet(wb, hoja_BC)
addWorksheet(wb, hoja_GJT)
addWorksheet(wb, hoja_edad_BC)
addWorksheet(wb, hoja_SX_BC)
addWorksheet(wb, hoja_edad_GJT)
addWorksheet(wb, hoja_SX_GJT)

# Definir datos para cada hoja
datos_BC <- Serie_Tiempo_2000_2024_BC
datos_GJT <- Serie_Tiempo_2000_2024_BCS
datos_edad_BC <- Edad_2000_2024_BC
datos_SX_BC <- sexo_2000_2024_BC
datos_edad_GJT <- Edad_2000_2024_BCS
datos_SX_GJT <- sexo_2000_2024_BCS

# Crear estilos para las filas
estilo_blanco <- createStyle(bgFill = "#f1ffcf", border = "TopBottomLeftRight", borderColour = "black", borderStyle = "thin")
estilo_verde <- createStyle(bgFill = "#f8df82", border = "TopBottomLeftRight", borderColour = "black", borderStyle = "thin")
estilo_cabecera <- createStyle(fgFill = "#fac055", textDecoration = "bold", halign = "center")
# Aplicar estilos alternativamente a las filas para Serie_Tiempo_2000_2024_BC
for (i in 1:nrow(datos_BC)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_BC, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_BC, estilo_verde, rows = i + 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para Serie_Tiempo_2000_2024_GJT
for (i in 1:nrow(datos_GJT)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_GJT, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_GJT), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_GJT, estilo_verde, rows = i + 1, cols = 1:ncol(datos_GJT), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para edad_bc
for (i in 1:nrow(datos_edad_BC)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_edad_BC, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_edad_BC), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_edad_BC, estilo_verde, rows = i + 1, cols = 1:ncol(datos_edad_BC), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para edad_GJT
for (i in 1:nrow(datos_edad_GJT)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_edad_GJT, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_edad_GJT), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_edad_GJT, estilo_verde, rows = i + 1, cols = 1:ncol(datos_edad_GJT), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para sex_bc
for (i in 1:nrow(datos_SX_BC)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_SX_BC, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_SX_BC), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_SX_BC, estilo_verde, rows = i + 1, cols = 1:ncol(datos_SX_BC), gridExpand = TRUE)
  }
}

# Aplicar estilos alternativamente a las filas para edad_GJT
for (i in 1:nrow(datos_SX_GJT)) {
  if (i %% 2 == 0) { # Si la fila es par
    addStyle(wb, sheet = hoja_SX_GJT, estilo_blanco, rows = i + 1, cols = 1:ncol(datos_SX_GJT), gridExpand = TRUE)
  } else { # Si la fila es impar
    addStyle(wb, sheet = hoja_SX_GJT, estilo_verde, rows = i + 1, cols = 1:ncol(datos_SX_GJT), gridExpand = TRUE)
  }
}
# Especificar la ruta del archivo
Ruta_archivo <- "E:/Users/YORA/Documents/guardado_años/BC-BCS-Financieros/Serie_Tiempo_2000_2024_BC_BCS_7505.xlsx"

# Escribir los datos en las hojas
writeData(wb, hoja_BC, datos_BC)
writeData(wb, hoja_GJT, datos_GJT)
writeData(wb, hoja_edad_BC, datos_edad_BC)
writeData(wb, hoja_edad_GJT, datos_edad_GJT)
writeData(wb, hoja_SX_BC, datos_SX_BC)
writeData(wb, hoja_SX_GJT, datos_SX_GJT)

# Aplicar el estilo a las cabeceras de las columnas para ambas hojas
addStyle(wb, hoja_BC, estilo_cabecera, rows = 1, cols = 1:ncol(datos_BC), gridExpand = TRUE)
addStyle(wb, hoja_GJT, estilo_cabecera, rows = 1, cols = 1:ncol(datos_GJT), gridExpand = TRUE)
addStyle(wb, hoja_edad_BC, estilo_cabecera, rows = 1, cols = 1:ncol(datos_edad_BC), gridExpand = TRUE)
addStyle(wb, hoja_edad_GJT, estilo_cabecera, rows = 1, cols = 1:ncol(datos_edad_GJT), gridExpand = TRUE)
addStyle(wb, hoja_SX_BC, estilo_cabecera, rows = 1, cols = 1:ncol(datos_SX_BC), gridExpand = TRUE)
addStyle(wb, hoja_SX_GJT, estilo_cabecera, rows = 1, cols = 1:ncol(datos_SX_GJT), gridExpand = TRUE)

# Guardar el archivo
saveWorkbook(wb, Ruta_archivo, overwrite = TRUE)
#----------------------------------------

#-------------Exportacion-individual---------------------------
#exportar los datos
library(writexl)
# Ruta donde quieres guardar el archivo Excel
ruta <- "E:/Users/YORA/Documents/guardado_años/BC-BCS-Financieros/Patron_BCS_2000_2024.xlsx"

# Guardar el dataframe en la ruta especificada
write_xlsx(Patron_2000_2024_BCS, ruta)



