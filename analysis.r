setwd("D:/Scientific Data")
data_old<-read.csv("final_preprocessed_data_old.csv",header=TRUE)
data_new<-read.csv("final_preprocessed_data_new.csv",header=TRUE)
data_old$Month<-strftime(data_old$检查时间, format = "%y-%m")
data_old$Year<-strftime(data_old$检查时间, format = "%y")
data_new$Month<-strftime(data_new$检查时间, format = "%y-%m")
data_new$Year<-strftime(data_new$检查时间, format = "%y")

######################Figure 2时间序列数据 就诊人数和就诊时间差##########################
library(ggplot2)
old_p<-ggplot(data=data_old, aes(x=Month, y=log10(时间差))) +
      geom_boxplot(fill="steelblue")+
      theme_bw()+
      facet_wrap(~Year,scale="free",ncol=4)+
      theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
      plot.title = element_text(hjust = 0.5))
   
old_p

ggsave(old_p, file="old_p.pdf", width=10, height=7.5,limitsize = FALSE)

new_p<-ggplot(data=data_new, aes(x=Month, y=log10(时间差))) +
  geom_boxplot(fill="steelblue")+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

new_p

ggsave(new_p, file="new_p.pdf", width=10, height=9,limitsize = FALSE)


data_new_data<-unique(data_new[c(1,2,382,383,384,385,386,387,388,397,398,399,400,401)])
data_new_data$出生日期<-as.Date(data_new_data$出生日期)
#data_new_data$出生日期<-strftime(data_new_data$出生日期, format = "%y")
data_new_data$年龄<- difftime(data_new_data$检查时间,data_new_data$出生日期)
data_new_data$年龄<-data_new_data$年龄/365
data_new_data$年龄<-round(data_new_data$年龄,digits=0)
data_new_data$年龄<-as.numeric(data_new_data$年龄)
data_old_data<-unique(data_old[c(1,2,475,476,477,478,479,480,481,482,486,487,493,494,495)])
data_new_data$count<-1
data_old_data$count<-1
patient_count_new<-aggregate(data_new_data$count,list(data_new_data$病案号,data_new_data$Month,data_new_data$Year),sum)
colnames(patient_count_new)<-c("ID","Month","Year","sum")
patient_count_new$sum<-1
patient_count_old<-aggregate(data_old_data$count,list(data_old_data$病案号,data_old_data$Month,data_old_data$Year),sum)
colnames(patient_count_old)<-c("ID","Month","Year","sum")
patient_count_old$sum<-1
old_bar<-aggregate(patient_count_old$sum,list(patient_count_old$Month,patient_count_old$Year),sum)
new_bar<-aggregate(patient_count_new$sum,list(patient_count_new$Month,patient_count_new$Year),sum)

old_bar_p<-ggplot() +
  geom_bar(data=patient_count_old, aes(x=Month,fill='#FF7F00'),stat = "count")+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

old_bar_p

ggsave(old_bar_p, file="old_p_patient_count.pdf", width=10, height=7.5,limitsize = FALSE)

new_bar_p<-ggplot() +
  geom_bar(data=patient_count_new, aes(x=Month,fill='#FF7F00'),stat = "count")+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

new_bar_p

ggsave(new_bar_p, file="new_p_patient_count.pdf", width=10, height=9,limitsize = FALSE)


data_new_frame<-aggregate(data_new_data$count,list(data_new_data$Year,data_new_data$Month),sum)
colnames(data_new_frame)<-c("Year","Month","sum")
data_old_frame<-aggregate(data_old_data$count,list(data_old_data$Year,data_old_data$Month),sum)
colnames(data_old_frame)<-c("Year","Month","sum")



old_p<-ggplot() +
  geom_bar(data=patient_count_old, aes(x=Month,fill='#FF7F00'),stat = "count",width =0.5)+
  geom_point(data=data_old_frame, aes(x=Month, y=sum),color='#458B00')+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

old_p

ggsave(old_p, file="old_p_countsum.pdf", width=10, height=7.5,limitsize = FALSE)

new_p<-ggplot() +
  geom_bar(data=patient_count_new, aes(x=Month,fill='#FF7F00'),stat = "count",width =0.5)+
  geom_point(data=data_new_frame, aes(x=Month, y=sum),color='#458B00')+
  theme_bw()+
  facet_wrap(~Year,scale="free",ncol=4)+
  theme(axis.text.x = element_text(angle = 90,hjust = 0.5,vjust = 0.5),
        plot.title = element_text(hjust = 0.5))

new_p

ggsave(new_p, file="new_p_countsum.pdf", width=10, height=9,limitsize = FALSE)

###############Figure 2数据分布 分类问题########################################
library(reshape2)
data_plot_old<-merge(data_old_data,data_old_frame,by=c("Year","Month"))
data_plot_new<-merge(data_new_data,data_new_frame,by=c("Year","Month"))

data_old_group<-data_plot_old[-c(1,2,3,4,11,13,14,15,16,17)]
list_old_group<-melt(data_old_group)
data_new_group<-data_plot_new[-c(1,2,3,4,11,12,13,14,16,17)]
list_new_group<-melt(data_new_group)

library(RColorBrewer)
p1<-ggplot(data_old_group,aes(x=年龄))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
  
p1

p2<-ggplot(data_old_group,aes(x=人均地区生产总值.元.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p2

p3<-ggplot(data_old_group,aes(x=医院.卫生院数.个.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p3

p4<-ggplot(data_old_group,aes(x=医院.卫生院床位数.张.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p4

p5<-ggplot(data_old_group,aes(x=医生数.人.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p5

p6<-ggplot(data_old_group,aes(x=职工平均工资.元.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p6

p<-p1+p2+p3+p4+p5+p6


ggsave(p, file="density.pdf", width=17, height=6,limitsize = FALSE)

p1<-ggplot(data_new_group,aes(x=年龄))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p1

p2<-ggplot(data_new_group,aes(x=人均地区生产总值.元.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p2

p3<-ggplot(data_new_group,aes(x=医院.卫生院数.个.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")

p3

p4<-ggplot(data_new_group,aes(x=医院.卫生院床位数.张.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p4

p5<-ggplot(data_new_group,aes(x=医生数.人.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p5

p6<-ggplot(data_new_group,aes(x=职工平均工资.元.))+
  geom_density(aes(color = as.factor(性别)))+
  theme_bw()+
  scale_color_brewer(palette = "Set1")
p6

p_new<-p1+p2+p3+p4+p5+p6

ggsave(p_new, file="density_p_new.pdf", width=17, height=6,limitsize = FALSE)

#################################共病分析#######################################
de_old<-data_old[c(1,485)]
colnames(de_old)<-c("ID","diaginose")
de_new<-data_new[c(1,389)]
colnames(de_new)<-c("ID","diaginose")

library(sparklyr)
library(tidyr)
de_se_old <-separate_rows(de_old,2,sep = ' ')
de_se_new <-separate_rows(de_new,2,sep = ' ')
#table1<-merge(x,group1,by="Gene.ID")


#################缺失值统计##################################
old_frame<-colMeans(is.na(data_old))
old_frame<-as.data.frame(old_frame)
write.csv(old_frame,"old_frame.csv")
old_frame<-read.csv("old_frame.csv",header=TRUE)
#old_frame$percentage<-old_frame$old_frame/37071
new_frame<-colMeans(is.na(data_new))
new_frame<-as.data.frame(new_frame)
write.csv(new_frame,"new_frame.csv")
new_frame<-read.csv("new_frame.csv",header=TRUE)
#new_frame$percentage<-new_frame$new_frame/39915


p <- ggplot(old_frame, aes(x=order(old_frame,X), y=old_frame)) +
      geom_bar(stat="identity", fill=alpha("#FF6600", 0.5)) +
      ylim(-2,2)+
      theme_minimal()+
      theme(
       axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-2,4), "cm")
  ) +coord_polar(start = 0)
p


p1 <- ggplot(new_frame, aes(x=order(new_frame), y=new_frame)) +
  geom_bar(stat="identity", fill=alpha("#FF6600","#f6acf5", 0.5)) +
  ylim(-4,2)+
  theme_minimal()+
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-2,4), "cm")
  ) +coord_polar(start = 0)
p1


new_frame$group<-"Cohort2"
old_frame$group<-"Cohort1"

colnames(new_frame)<-c("ID","missing_percent","group")
colnames(old_frame)<-c("ID","missing_percent","group")

all_frame<-rbind(new_frame,old_frame)

df$angle1<-ifelse(all_frame$id<=30,96-df$id*6,96-df$id*6+180)
df$hjust<-ifelse(df$id<=30,0.2,1)

p1 <- ggplot(all_frame, aes(x=reorder(ID,missing_percent,mean), y=missing_percent)) +
  geom_bar(stat="identity", fill=alpha("#FF6600",0.7))+
  ylim(-4,2)+
  theme_minimal()+
  facet_wrap(~group)+
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-2,4), "cm")
  ) +coord_polar(start = 0)
p1

ggsave(p1, file="p1.pdf", width=17, height=6,limitsize = FALSE)
