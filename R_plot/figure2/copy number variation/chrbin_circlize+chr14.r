library(circlize)
library(dtplyr)
library(ComplexHeatmap)

cytoband = read.table("hg38.fa.sizes", colClasses = c("character", "numeric","numeric"), sep = "\t")

process_df<-function(filename){
  df1=read.csv(filename, sep="\t",header = T)
  df1$end=df1$Start+1000000
  df1$cn=log2(df1$Ratio+1)*2
  df1=df1[,c(1,2,6,7)]
  df1$cn[which(df1$cn=="-Inf")]=NA
  return(df1)
}

df1=process_df("HCC78_gDNA_q200402.sort.bam_ratio.txt")
df2=process_df("HCC78_gDNA_s.bam_ratio.txt")
df3=process_df("HCC78_MDA_q200328.sort.bam_ratio.txt")
df4=process_df("HCC78_MDA_4h0126.sort.bam_ratio.txt")


circos.clear()
circos.par("start.degree" = 90)
circos.par("track.height" = 0.08)


circos.initializeWithIdeogram(cytoband, sort.chr = FALSE, plotType = c("axis", "labels"))

circos.genomicTrackPlotRegion(df1, panel.fun = function(region, value, ...) {
  
  circos.genomicPoints(region, value, col="#fc9272", pch = 16, cex = 0.2)
})

circos.genomicTrackPlotRegion(df2, panel.fun = function(region, value, ...) {
  circos.genomicPoints(region, value, col="#bcbddc", pch = 16, cex = 0.2)
})

circos.genomicTrackPlotRegion(df3, panel.fun = function(region, value, ...) {
  circos.genomicPoints(region, value, col="#fec44f", pch = 16, cex = 0.2)
})

circos.genomicTrackPlotRegion(df4, panel.fun = function(region, value, ...) {
  circos.genomicPoints(region, value, col="#9ecae1", pch = 16, cex = 0.2)
})


lgd_lines = Legend(at = c("WGS (R10.4)","WGS (R9.4.1)","scWGA (R10.4)","scWGA (R9.4.1)"), 
                   type = "points", size = 2.5, 
                   legend_gp = gpar(col=c( "#fc9272","#bcbddc","#fec44f","#9ecae1")))
draw(lgd_lines)

library(ggplot2)
library(ggpubr)

p1=ggplot(data = filter(df1,Chromosome=="14"),aes(x=Start,y=cn))+
  geom_point(size=3,col="#fc9272")+
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank())+
  theme(axis.title.y=element_blank(),
        axis.ticks.y=element_blank())+
  ylim(0,6)

p2=ggplot(data = filter(df2,Chromosome=="14"),aes(x=Start,y=cn))+
  geom_point(size=3,col="#bcbddc")+
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank())+
  theme(axis.title.y=element_blank(),
        axis.ticks.y=element_blank())+
  ylim(0,6)

p3=ggplot(data = filter(df3,Chromosome=="14"),aes(x=Start,y=cn))+
  geom_point(size=3,col="#fec44f")+
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
  )+
  xlab("")+
  theme(axis.title.y=element_blank(),
        axis.ticks.y=element_blank())+
  ylim(0,6)

##p4=ggplot(data = filter(df4,Chromosome=="14"),aes(x=Start,y=cn))+
geom_point(size=3,col="#9ecae1")+
  theme_bw()+
  theme(axis.title.y=element_blank(),
        axis.ticks.y=element_blank())+
  ylim(0,6)+
  xlab("Chromosome 14")

p4=ggplot(data = filter(df4,Chromosome=="14"),aes(x=Start,y=cn))+
  geom_point(size=3,col="#9ecae1")+
  theme_bw()+
  theme(axis.title.y=element_blank(),
        axis.ticks.y=element_blank())+
  ylim(0,6)+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
  )

options(scipen = 200)

p=ggarrange(p1,p2,p3,p4,ncol=1,nrow=4)
p