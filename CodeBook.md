Descripcion del Codigo - (Idioma Español - Language Spanish)

Este libro de códigos describe las variables, los datos y cualquier transformación o trabajo que se realice para limpiar los datos, segun el objetivo propuesto por el curso para esta tarea.

Acerca de los datos (Reconocimiento de actividad humana usando el conjunto de datos de teléfonos inteligentes):

Los experimentos se llevaron a cabo con un grupo de 30 voluntarios dentro de un rango de edad de 19-48 años.

Cada persona realizó seis actividades (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) usando un teléfono inteligente (Samsung Galaxy S II) en la cintura.

Que incluye la carpeta UCI HAR Dataset:
  'README.txt'
  
  'features_info.txt': muestra información sobre las variables utilizadas en el vector de características.
  
  'features.txt': Lista de todas las características (hay 561 registros).
  
  'activity_labels.txt': enlaza las 6 etiquetas de clase con su nombre de actividad(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING), tiene 6 elementos.
  
  'train / X_train.txt': conjunto de entrenamiento (7352 registros de 561 características / variables).
  
  'train / y_train.txt': etiquetas de capacitación (clase de actividad para los 7352 registros anteriores).
  
  'train / subject_test.txt': Id de los sujetos para los 7352 registros de arriba).
  
  'test / X_test.txt': conjunto de prueba (2947 registros de 561 características/variables)
  
  'test / y_test.txt': etiquetas de prueba (clase de actividad para los 2947 registros anteriores).
  
  'test / subject_test.txt': Id de sujetos para los 2947 registros anteriores).
  
  Las características están normalizadas y limitadas dentro de [-1,1].
  
  Cada vector de características es un vector o fila en el archivo de texto.
  
  Objetivo del Proyecto - Pasos a seguir:
  
  Los requisitos para el proyecto son los siguientes:
  
     1. Fusionar los conjuntos de entrenamiento y prueba para crear un conjunto de datos.
     
     2. Extraer solo las mediciones de la media y la desviación estándar para cada medición.
     
     3. Utilizar nombres descriptivos de actividades para nombrar las actividades en el conjunto de datos.
     
     4. Etiquetar adecuadamente el conjunto de datos con nombres de variables descriptivas.
     
     Del conjunto de datos en el paso 4,
     5. Crear un segundo conjunto de datos ordenado independiente con el promedio de cada variable para cada actividad y cada sujeto.
     
Pasos del Codigo - run_analysis.R

Fusionar los conjuntos de entrenamiento y prueba para crear un conjunto de datos:

     Utilizar la biblioteca dplyr, se carga la libreria para permitir la manipulación de datos.
     
     Los datos se leen de los archivos txt de los conjuntos de entrenamiento y prueba de la carpeta UCI HAR Dataset, se guarda direccion en donde se encuentra la carpeta en sistema.
     
     Se agrega una columna 'conjunto' para identificar el conjunto de datos de origen y permitir algunos posibles análisis de limpieza.
     
     Los data frame que utilizamos para almacenar datos son: train_x, test_x, train_y, test_y, train_sub, test_sub
     
     La función rbind () se utiliza para fusionar los 3 conjuntos de datos de entrenamiento y prueba (es decir, datos X, datos Y (actividad), _sub)
     
     Los respectivos data frame combinados son: x_all, y_all, sub_all

Extraer solo las mediciones de la media y la desviación estándar para cada medición.

     El ID de los data frame se usan con col_names para almacenar los nombres de las 561 variables del archivo 'features.txt' de la carpeta.
     
     La función grepl () se utiliza para seleccionar variables que incluyen las funciones mean () o std () en sus nombres (columna V2 del data frame: col_names), queda guardado en variables selec_mean, selec_sd
     
     Como resultado, el data frame sel_names se usa para almacenar las variables relacionadas con la media y la desviación estándar (se ocupa rbind de las 2 selecciones anteriores).
     
     Se agrega una columna V3 ("V" + identificación de las variables seleccionadas) a los nombres de los data frame para permitir una extracción, se ocupa la funcion select().
     
     El dataframe sel_data se usa para almacenar los datos seleccionados (es decir, media y estándar) a partir del dataframe y_all creado en la parte 1.
     
Utilizar nombres descriptivos de actividades para nombrar las actividades en el conjunto de datos:

     La función colnames() se usa para cambiar el nombre de las columnas del data frame selec_data con el nombre de las variables seleccionadas.
     
     El dataframe de eti_act se usa para almacenar la etiqueta de actividades del archivo 'activity_labels.txt'
     
     La columna id_reg se agrega a dataframe y_all para asegurar el orden de los datos después de usar merge()
     
     La función merge() se utiliza para traducir 'clase de actividades' (columna V1 de y_all) a una 'etiqueta de actividad' significativa (columna V1 de eti_act). El resultado se almacena en el data frame y_all_eti
     
     Se usa colnames() para renombrar columnas de datos de y_all_eti como "id_reg" y "Lbl_Activity"
     
     La función cbind() se usa para agregar las actividades (del data frame y_all_eti) para todos los datos seleccionados (en selec_data) y almacenarlos en el data frame llamado y_eti
     
     Finalmente, cbind() se usa nuevamente para agregar 'ID_Subject' (de sub_all) a la actividad o datos ya procesados y almacenarlos en el data frame eti_subj

Como resultado de todos esos pasos, el resultado ordenado está disponible en el marco de datos subject_label_data con las siguientes columnas:

    "ID_Subject": Identificador del sujeto que proporcionó los datos
    "Lbl_Activity": etiqueta de la actividad registrada (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
    Una Lista de características relacionadas con la media o la desviación estándar.
    
El conjunto ordenado de datos con el promedio de cada variable para cada actividad y cada asignatura

     La función group_by() se usa para agrupar datos en el data frame eti_subj usando Lbl_Activity, ID_Subject
     La función summaryise_all() se utiliza para calcular la media de todas las variables en el marco de datos eti_subj
     El resultado está alojado en el data frame llamado Syn_Results
     
Finalmente, se usa write.table() para guardar en .txt el archivo Syn_results.txt en la carpeta de directorio principal de R de mi computadora (getwd()).



