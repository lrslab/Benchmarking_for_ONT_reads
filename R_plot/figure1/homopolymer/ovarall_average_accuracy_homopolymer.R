library(ggplot2)
  
data <- read.table("homopolymer_acc_overall.txt", header = T, sep = "\t")

data['value'] <- data['value'] * 100

ggplot(data = data,aes(x=base ,y=value,group = type,color=type))+
  geom_point()+
  geom_line() +
  theme_bw()+ scale_color_manual(values = c("WGS(R10.4)" = "#fc9272",
                               "WGS(R9.4.1)" = "#bcbddc",
                               "scWGA(R10.4)" = "#fec44f",
                               "scWGA(R9.4.1)" = "#9ecae1")) +
  facet_wrap(.~group,ncol= 1) +
  scale_y_continuous(name="Average accuracy of homopolymer detection (%)", limits=c(75,95),breaks=seq(75,95,5)) + 
  theme(legend.position="none") + xlab("") + 
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title.y=element_text(size=15, colour = "black"),
        legend.text = element_text(size=15, colour = "black"),
        legend.title = element_blank())
