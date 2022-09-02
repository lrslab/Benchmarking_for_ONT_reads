library(ggplot2)
library(ggpubr)
library(dplyr)
df=read.csv("intersected_proportion.csv",header = T)
head(df)

# Use position=position_dodge()
p=ggplot(data=df, aes(x=minimum_support_reads, y=proportion, fill=group)) +
  geom_bar(stat="identity", position=position_dodge())+
  scale_fill_manual(values=c("#FC9272", "#BCBDDC", "#FEC44F","#9ECAE1"))+
  theme_bw()+
  xlab("Minimum support reads")+
  ylab("Proportion of intersections")+
  labs(fill = "")+
  theme(legend.position="none")
p
