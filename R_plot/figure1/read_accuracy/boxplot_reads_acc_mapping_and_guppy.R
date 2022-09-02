library(ggplot2)
library(patchwork)
library(reshape2)

all_reads_info <- read.csv("test.info", header = T, sep = "\t")

ggplot(data = all_reads_info, aes(color=type,fill=methods, x=type, y=acc)) +
  
  geom_boxplot(width=1,outlier.shape = NA, outlier.alpha = 0.1) +
  
  scale_color_manual(values = c("WGS(R10.4)" = "#fc9272",
                                "WGS(R9.4.1)" = "#bcbddc",
                                "scWGA(R10.4)" = "#fec44f",
                                "scWGA(R9.4.1)" = "#9ecae1"), guide="none") +
  
  scale_fill_manual(values=alpha(c("mapping" = "#FFFFFF", "guppy" = "#D6DBDF"),.3)) +
  
  scale_x_discrete(limits = c("WGS(R10.4)", "WGS(R9.4.1)", "scWGA(R10.4)", "scWGA(R9.4.1)")) + xlab("") + 
  
  scale_y_continuous(name="Read accuracy (%)", limits=c(88, 100),breaks=seq(88, 100, 2)) + theme_bw()+
  
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title.y=element_text(size=15, colour = "black"),
        legend.text = element_text(size=15, colour = "black"),
        legend.title = element_blank())

