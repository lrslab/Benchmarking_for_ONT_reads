library(ggplot2)
library(patchwork)
library(reshape2)

all_reads_info <- read.csv("test_reads.info", header = T, sep = "\t")
all_reads_info['acc'] <- all_reads_info['acc'] * 100

p1 <- ggplot(all_reads_info, aes(x=acc, color=type)) +  geom_density(size=1.2)+
  scale_x_continuous(name="Observed read accuracy", limits=c(80,100),breaks=seq(80,100,2)) + 
  scale_color_manual(values = c("WGS(R10.4)" = "#fc9272",
                                "WGS(R9.4.1)" = "#bcbddc",
                                "scWGA(R10.4)" = "#fec44f",
                                "scWGA(R9.4.1)" = "#9ecae1"), guide="none") + 
  ylab("Probability density function") + theme_bw() + 
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title=element_text(size=15, colour = "black"))

all_reads_guppy <- read.csv("test_reads_guppy.info", header = T, sep = "\t")
all_reads_guppy['acc'] <- (1 - (10^(-1 * all_reads_guppy['Q_value']/10))) * 100

p2<- ggplot(all_reads_guppy, aes(x=acc, color=type)) +  geom_density(size=1.2) +
  scale_x_continuous(name="Estimated read accuracy", limits=c(80,100),breaks=seq(80,100,2)) + 
  scale_color_manual(values = c("WGS(R10.4)" = "#fc9272",
                                "WGS(R9.4.1)" = "#bcbddc",
                                "scWGA(R10.4)" = "#fec44f",
                                "scWGA(R9.4.1)" = "#9ecae1"), guide="none") + 
  ylab("Probability density function") +  theme_bw() + 
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title=element_text(size=15, colour = "black"))

p1 + p2  
p1/p2
