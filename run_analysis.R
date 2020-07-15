library(dplyr)

#definir la direccion o ubicacion de la carpeta de trabajo.
#Por default mi getwd() es: "C:\\Users\\Rob\\Documents"

carpeta<-"C:\\Users\\Rob\\Documents\\UCI HAR Dataset"

#Lectura de conjunto de datos (X): Training.
train_x<-read.table(paste(carpeta,"\\train\\X_train.txt",sep=""),header=FALSE,sep="",dec=".")%>%
  mutate(set="Training")

#Lectura de conjunto de datos (X): Test. Uso de %>%
test_x<-read.table(paste(carpeta,"\\test\\X_test.txt",sep=""),header=FALSE,sep="",dec=".")%>%
  mutate(set="Test")

#Lectura del tipo de actividad (Y): Training
train_y<-read.table(paste(carpeta,"\\train\\Y_train.txt",sep=""),header=FALSE,sep="")

#Lectura del tipo de actividad (Y): Test
test_y<-read.table(paste(carpeta,"\\test\\y_test.txt",sep=""),header=FALSE,sep="")

#Lectura del tipo de asig.formacion 
train_sub<-read.table(paste(carpeta,"\\train\\subject_train.txt",sep=""),header=FALSE,sep="")

#Lectura del tipo de asig.formacion  -Test
test_sub<-read.table(paste(carpeta,"\\test\\subject_test.txt",sep=""),header=FALSE,sep="")

#1.- Union (Merge) de conjuntos training y test, creando nuevos conjuntos
y_all<-rbind(train_y,test_y)
x_all<-rbind(train_x,test_x)
sub_all<-rbind(train_sub,test_sub)

# Lectura de nombres de columnas, uso archivo features.
col_names<-read.table(paste(carpeta,"\\features.txt",sep=""),header=FALSE)
#2.- seleccionar los nombres que contengan la funcion "mean" y "sd"
selec_mean<-filter(col_names,grepl('mean()',V2))
selec_sd<-filter(col_names,grepl('std()',V2))

#Combinar seleccion de caracteristicas (features), se añade V3 para seleccionar y reordenar datos
selec_names<-rbind(selec_mean,selec_sd)%>%
  mutate(V3=paste("V",V1,sep=""))%>%
  arrange(V1)

#Extraer columnas / características seleccionadas de los datos
selec_data<-select(x_all,pull(selec_names,V3))

# cambiar el nombre de las columnas del conjunto de datos global seleccionado para aclararlo utilizando los datos de la tabla "características"
# selec_names es una referencia para el catálogo de datos

colnames(selec_data)<-pull(selec_names,V2)

#Nombres de actividades(Y) y agregar identificador(ID)
eti_act<-read.table(paste(carpeta,"\\activity_labels.txt",sep=""),header=FALSE)
y_all<-mutate(y_all,id_reg=as.numeric(rownames(y_all)))

# 4.- Combinar etiquetas para obtener un significado de la clase de actividad y eliminar la columna V1 (clase de actividad) que ya no es útil en un conjunto de datos ordenado
y_all_eti<-merge(y_all,eti_act,by="V1")%>%
  arrange(id_reg)%>%
  select(-V1)
colnames(y_all_eti)<-c("id_reg","Lbl_Activity")

# Añadimos etiquetas al conjunto unificado y eliminamos ID
y_eti<-cbind(y_all_eti,selec_data)%>%
  select(-id_reg)

#Renombramos las columnas
colnames(sub_all)<-c("ID_Subject")
eti_subj<-cbind(sub_all,y_eti)

#Ver los resultados.
View(eti_subj)

Syn_results<-eti_subj%>%
  group_by(Lbl_Activity,ID_Subject)%>%
  summarize_all("mean")
View(Syn_results)

#Crea archivo Syn_results.txt en getwd() definido por default.
write.table(Syn_results,file="Syn_results.txt",row.names=FALSE)
