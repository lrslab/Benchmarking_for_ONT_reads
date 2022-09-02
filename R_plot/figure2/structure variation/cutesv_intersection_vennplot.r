# load Venn diagram package
library(VennDiagram)
library(ggpubr)

# move to new plotting page
grid.newpage()

# create pairwise Venn diagram
pWGS_min2=draw.pairwise.venn(area1=28365, area2=45539,cross.area=20874,
                             category=c("WGS(R10.4)","WGS(R9.4.1)"),fill=c("#fc9272","#bcbddc"),col=c("#fc9272","#bcbddc"),
                             cat.pos = c(-20,20))

pWGS_min3=draw.pairwise.venn(area1=12062, area2=29875,cross.area=9724,
                             category=c("WGS(R10.4)","WGS(R9.4.1)"),fill=c("#fc9272","#bcbddc"),col=c("#fc9272","#bcbddc"),
                             cat.pos = c(-20,20))

pWGS_min4=draw.pairwise.venn(area1=6840, area2=22790,cross.area=5501,
                             category=c("WGS(R10.4)","WGS(R9.4.1)"),fill=c("#fc9272","#bcbddc"),col=c("#fc9272","#bcbddc"),
                             cat.pos = c(-20,20))

pWGS_min5=draw.pairwise.venn(area1=3936, area2=17512,cross.area=3127,
                             category=c("WGS(R10.4)","WGS(R9.4.1)"),fill=c("#fc9272","#bcbddc"),col=c("#fc9272","#bcbddc"),
                             cat.pos = c(-20,20))

pscWGA_min2=draw.pairwise.venn(area1=45883, area2=207665,cross.area=11350,
                               category=c("scWGA(R10.4)","scWGA(R9.4.1)"),fill=c("#fec44f","#9ecae1"),col=c("#fec44f","#9ecae1"),
                               cat.pos = c(-20,20))

pscWGA_min3=draw.pairwise.venn(area1=7079, area2=20082,cross.area=5385,
                               category=c("scWGA(R10.4)","scWGA(R9.4.1)"),fill=c("#fec44f","#9ecae1"),col=c("#fec44f","#9ecae1"),
                               cat.pos = c(-20,20))

pscWGA_min4=draw.pairwise.venn(area1=4263, area2=10294,cross.area=3328,
                               category=c("scWGA(R10.4)","scWGA(R9.4.1)"),fill=c("#fec44f","#9ecae1"),col=c("#fec44f","#9ecae1"),
                               cat.pos = c(-20,20))

pscWGA_min5=draw.pairwise.venn(area1=2806, area2=7133,cross.area=2177,
                               category=c("scWGA(R10.4)","scWGA(R9.4.1)"),fill=c("#fec44f","#9ecae1"),col=c("#fec44f","#9ecae1"),
                               cat.pos = c(-20,20))


p2=ggarrange(pWGS_min2,pscWGA_min2,ncol = 1,nrow = 2)
p2

p3=ggarrange(pWGS_min3,pscWGA_min3,ncol = 1,nrow = 2)
p3          

p4=ggarrange(pWGS_min4,pscWGA_min4,ncol = 1,nrow = 2)
p4

p5=ggarrange(pWGS_min5,pscWGA_min5,ncol = 1,nrow = 2)
p5

