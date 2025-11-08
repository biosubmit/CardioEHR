
############################################################
# Project: EHR Data Analysis and Visualization
# Script:  main_analysis.R
# Author:  YanzeLi
# Date:    2025-11-08
# Purpose: This script performs preprocessing, statistical 
#          analysis, and visualization of EHR data.
############################################################

# -------------------------------
# 1. Environment setup
# -------------------------------

# Clear environment
rm(list = ls())

# Set working directory (modify as needed)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# -------------------------------
# 2. Load required packages
# -------------------------------
# (install if necessary)
packages <- c("tidyverse", "migest", "circlize", "ggplot2", "readr", "dplyr","reshape2")

invisible(lapply(packages, function(pkg) {
  if (!require(pkg, character.only = TRUE)) install.packages(pkg)
  library(pkg, character.only = TRUE)
}))
################# Visualization Analysis Part ########################

data_old<-read.csv("VisualizationOriginalData/data_old.csv",header=TRUE)
old_p<-ggplot(data=data_old, aes(x=Month, y=log10(时间差))) +
  geom_boxplot(fill="steelblue")+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

old_p

ggsave(old_p, file="VisualizationOriginalData/Figure4B.pdf", width=10, height=7.5,limitsize = FALSE)



data_new<-read.csv("VisualizationOriginalData/data_new.csv",header=TRUE)
new_p<-ggplot(data=data_new, aes(x=Month, y=log10(时间差))) +
  geom_boxplot(fill="steelblue")+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

new_p

ggsave(new_p, file="VisualizationOriginalData/Figure4D.pdf", width=10, height=9,limitsize = FALSE)


patient_count_old<-read.csv("VisualizationOriginalData/patient_count_old.csv",header=TRUE)
old_p<-ggplot() +
  geom_bar(data=patient_count_old, aes(x=Month,fill='#FF7F00'),stat = "count",width =0.5)+
  geom_point(data=data_old_frame, aes(x=Month, y=sum),color='#458B00')+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

old_p

ggsave(old_p, file="VisualizationOriginalData/Figure4A.pdf", width=10, height=7.5,limitsize = FALSE)


patient_count_new<-read.csv("VisualizationOriginalData/patient_count_new.csv",header=TRUE)
new_p<-ggplot() +
  geom_bar(data=patient_count_new, aes(x=Month,fill='#FF7F00'),stat = "count",width =0.5)+
  geom_point(data=data_new_frame, aes(x=Month, y=sum),color='#458B00')+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

new_p

ggsave(new_p, file="VisualizationOriginalData/Figure4C.pdf", width=10, height=9,limitsize = FALSE)

###############Figure 3########################################

library(RColorBrewer)
data_old_group<-read.csv("VisualizationOriginalData/data_old_group.csv",header=TRUE)

p1<-ggplot(data_old_group,aes(x=Age))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
  
p1

p2<-ggplot(data_old_group,aes(x=PerCapitaRegionalGDP))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p2

p3<-ggplot(data_old_group,aes(x=Number_of_Hospitals_and_HealthClinics))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p3

p4<-ggplot(data_old_group,aes(x=Number_of_Hospital_and_Township_ClinicBeds))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p4

p5<-ggplot(data_old_group,aes(x=Number_of_Physicians))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p5

p6<-ggplot(data_old_group,aes(x=AverageWage_of_Employees))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p6

p<-p1+p2+p3+p4+p5+p6

p
ggsave(p, file="VisualizationOriginalData/Figure3A.pdf", width=17, height=6,limitsize = FALSE)


data_new_group<-read.csv("VisualizationOriginalData/data_new_group.csv",header=TRUE)

p1<-ggplot(data_new_group,aes(x=Age))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p1

p2<-ggplot(data_new_group,aes(x=PerCapitaRegionalGDP))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p2

p3<-ggplot(data_new_group,aes(x=Number_of_Hospitals_and_HealthClinics))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p3

p4<-ggplot(data_new_group,aes(x=Number_of_Hospital_and_Township_ClinicBeds))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p4

p5<-ggplot(data_new_group,aes(x=Number_of_Physicians))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p5

p6<-ggplot(data_new_group,aes(x=AverageWage_of_Employees))+
  geom_density(aes(color = as.factor(Gender)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p6

p_new<-p1+p2+p3+p4+p5+p6
p_new

ggsave(p_new, file="VisualizationOriginalData/Figure3B.pdf", width=17, height=6,limitsize = FALSE)

############## diagram Figure 2 ################

from_to1<-read.csv("VisualizationOriginalData/Diagram_old.csv",header=TRUE)
from_to1<-from_to1[,-1]
pdf("VisualizationOriginalData/Diagram_old.pdf")

chordDiagram(
  from_to1,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
    
  },
  bg.border = NA
)

circos.clear()
dev.off()

from_to2<-read.csv("VisualizationOriginalData/Diagram_new.csv",header=TRUE)
from_to2<-from_to2[,-1]
pdf("VisualizationOriginalData/Diagram_new.pdf")

chordDiagram(
  from_to2,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
  },
  bg.border = NA
)

circos.clear()
dev.off()



from_to1<-read.csv("VisualizationOriginalData/Diagram_old.csv",header=TRUE)
from_to1<-from_to1[,-1]
pdf("VisualizationOriginalData/Diagram_old.pdfFigure2B.pdf")

chordDiagram(
  from_to1,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
    
  },
  bg.border = NA
)

circos.clear()
dev.off()

from_to2<-read.csv("VisualizationOriginalData/Diagram_new.csv")
from_to2<-from_to2[,-1]
pdf("VisualizationOriginalData/Diagram_newFigure2D.pdf")

chordDiagram(
  from_to2,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
  },
  bg.border = NA
)

circos.clear()
dev.off()

################################ Department ##########################################
from_to1<-read.csv("VisualizationOriginalData/Diagram_old_Department.csv",header=TRUE)
from_to1<-from_to1[,-1]
pdf("VisualizationOriginalData/Diagram_old_DepartmentFigure2A.pdf")

chordDiagram(
  from_to1,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
  },
  bg.border = NA
)

circos.clear()
dev.off()

from_to2<-read.csv("VisualizationOriginalData/Diagram_new_Department.csv",header=TRUE)
from_to2<-from_to2[,-1]
pdf("VisualizationOriginalData/Diagram_new_DepartmentFigure2C.pdf")

chordDiagram(
  from_to2,
  annotationTrack = "grid",
  direction.type = c("diffHeight","arrows"),
  preAllocateTracks = list(track.height = 0.1)
  
)

circos.trackPlotRegion(
  track.index = 1,
  panel.fun = function(x, y) {
    sector.name = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    theta = get.cell.meta.data("cell.start.degree")  # 获取角度
    
    
    circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1.5] - mm_y(1),
                CELL_META$sector.index, facing = "reverse.clockwise", niceFacing = TRUE,
                adj = c(1, 1.3), cex = 0.6)
  },
  bg.border = NA
)

circos.clear()
dev.off()




