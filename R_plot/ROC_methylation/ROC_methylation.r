library(plotROC)
library(ggplot2)
library(patchwork)

df <- read.csv("10-80.txt.1", sep = "\t", header = T)
df <- na.omit(df)

basicplot <-ggplot(df, aes(d = ngs, m = gDNA104)) + geom_roc(n.cuts = 0)
p2 <- ggplot(df, aes(d = ngs, m = gDNA104)) + geom_roc(n.cuts = 0) + 
  style_roc(theme = theme_grey) +
  theme(axis.text = element_text(colour = "black")) +
  ggtitle("WGS_r104") + 
  annotate("text", x = .75, y = .25, 
           label = paste("AUC =", round(calc_auc(basicplot)$AUC, 2))) +
  scale_x_continuous(name = "False positive fraction", breaks = seq(0, 1, by = .1)) + 
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title.y=element_text(size=15, colour = "black"),
        legend.text = element_text(size=15, colour = "black"),
        legend.title = element_blank())

basicplot1 <-ggplot(df, aes(d = ngs, m = gDNA941)) + geom_roc(n.cuts = 0)
p1 <- basicplot1 + style_roc(theme = theme_grey) +
  theme(axis.text = element_text(colour = "black")) +
  ggtitle("WGS_r941") + 
  annotate("text", x = .75, y = .25, 
           label = paste("AUC =", round(calc_auc(basicplot1)$AUC, 2))) +
  scale_x_continuous(name = "False positive fraction", breaks = seq(0, 1, by = .1)) + 
  theme(axis.text=element_text(size=15, colour = "black"),
        axis.title.y=element_text(size=15, colour = "black"),
        legend.text = element_text(size=15, colour = "black"),
        legend.title = element_blank())

p1 | p2

"""
demo data
postion	ngs	gDNA104	gDNA941
1_33080112_33081112	0	19.23076923076923	17.853846153846156
1_33081177_33082177	0	11.475409836065573	11.898360655737706
1_16439671_16440671	0	45.833333333333336	49.42876712328767
1_24744268_24745268	0	23.015873015873016	31.39047619047619
1_91886279_91887279	0	6.0	18.212371134020618
1_176207244_176208244	0	10.75472972972973	12.736486486486486
1_151007390_151008390	0	33.333333333333336	35.61296296296296
1_226309503_226310503	0	18.506249999999998	23.59375
1_226309748_226310748	0	42.583673469387755	44.78367346938776
"""
