library(ggplot2)
library(dplyr)

gcov_r9vsr10_all=read.csv("genomecov_all_r941vsr104.csv", sep=",", header=T)
pcov_r9vsr10_all=ggplot()+
  geom_point(data = gcov_r9vsr10_all0616,aes(x=Read.coverage, y=Genome.covered.ratio,color=treatment, group=treatment),size=3)+
  geom_line(data = filter(gcov_r9vsr10_all0616, treatment=="gDNA+R9.4.1" | treatment=="gDNA+R10.4"|treatment=="sDNA+R9.4.1" |treatment=="sDNA+R10.4"),aes(x=Read.coverage, y=Genome.covered.ratio, color=treatment),size=1)+
  geom_text(data = filter(gcov_r9vsr10_all0616, treatment!="gDNA+R9.4.1" & treatment!="gDNA+R10.4"&treatment!="sDNA+R9.4.1" &treatment!="sDNA+R10.4"),aes(x=Read.coverage, y=Genome.covered.ratio, label=treatment , hjust= -0.1))+
  scale_x_continuous(name="Read Coverage", limits=c(0, 11))+ 
  scale_y_continuous(name="Genome Recovery Rate (%)", limits=c(0, 100))+
  theme_bw()+
  theme(title=element_text(size=15))+
  scale_color_manual(values=c("gDNA+R9.4.1"="#bcbddc","gDNA+R10.4"="#fc9272","sDNA+R9.4.1"="#9ecae1","sDNA+R10.4"="#fec44f"))+
  theme(legend.position = c(0.9, 0.2),legend.title=element_blank())+
  scale_fill_manual(values=c("gDNA+r941"="#bcbddc","gDNA+r104"="#fc9272","sDNA+r941"="#9ecae1","sDNA+r104"="#fec44f"))

pcov_r9vsr10_all

ggsave(pcov_r9vsr10_all,filename = "pcov_r9vsr10_all.pdf",width = 10,height = 6)
