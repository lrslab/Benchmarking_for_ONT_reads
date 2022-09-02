library(ggplot2)

df_cor=read.csv("r9vsr10_subsample_Rvalue.csv")
df_cor$size=as.factor(df_cor$size)
pcor=ggplot(data=df_cor)+
  geom_boxplot(aes(x=size,y=r_value,group=group,fill=color_group))+
  scale_fill_manual(values=c("r941"="#bcbddc","r104"="#fc9272"))+
  xlab("Yield(Mb)")+
  ylab("Correlation coefficient")+
  theme_bw()+
  scale_fill_manual(values=c("r941"="#bcbddc","r104"="#fc9272"),
                    breaks=c("r941","r104"),
                    labels=c("HCC78 Bulk cells (R10.4)","HCC78 Bulk cells (R9.4.1)"))+
  guides(fill=guide_legend(title=NULL))+
  theme(legend.position="bottom")

pcor

#ggsave(plot=pcor,"bc_r9vsr10_subsample_promoter_correlation-r.pdf")

