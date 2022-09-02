library(ggplot2)
library(ggpubr)
data <- read.table("methylation_500k.txt", header=T)

gDNA <- data[c("gDNA104", "gDNA941")]/100

gDNA <- gDNA[which(rowSums(data==0)==0),]

ggplot(gDNA, aes(x=gDNA104, y=gDNA941)) + 
  geom_point(color = "grey") + 
  theme_bw() +
  theme(panel.grid=element_blank())+
  geom_smooth(method = "lm", se = F, color = 'black', linetype="dashed") + 
  stat_cor(method = "pearson", aes(x=gDNA104, y=gDNA941)) + 
  xlab("R10.4") + ylab("R9.4.1") +
  theme(axis.text=element_text(size=12,face = "bold"),
        axis.title.x=element_text(size=16),
        axis.title.y=element_text(size=16))
  
