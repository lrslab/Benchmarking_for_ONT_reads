library(ggplot2)
library(dplyr)
library(ggpubr)
library(cowplot)

### promoter level summary

process_df<-function(filename, version){
  WLM_d0=read.csv(filename, sep=",", header = F)
  colnames(WLM_d0)=c("gene",version)
  return(WLM_d0)
}


# the csv file is generated in server 

bcr941=process_df("gDNAr941_5mc_gp6_remora_sup_promoter.csv",version = "R9.4.1")
bcr104=process_df("gDNAr104_5mC_remora_sup_promoter.csv",version="R10.4")


bc5mc=merge(bcr941, bcr104, by="gene")

bc5mc$group <- ifelse(abs(bc5mc$R10.4-bc5mc$R9.4.1) >=25, "sig", "non_sig")

df_promoter_all=data.frame(version=c("R9.4.1","R10.4"), 
                           group= c("bc5mc", "bc5mc"), 
                           type="promoter_all",
                           Ratio_5mC=c(
                             mean(bc5mc$R9.4.1/100),
                             mean(bc5mc$R10.4/100))
)


bc5mc$group0=bc5mc$R9.4.1-bc5mc$R10.4
bc5mc <- transform(bc5mc,color_group=ifelse(bc5mc$group=="non_sig", "non_sig", ifelse(bc5mc$group0>0,"sig_R9.4.1","sig_R10.4")))


p_a=ggplot(data=bc5mc,aes(x=R9.4.1/100, y=R10.4/100))+
  geom_point(aes(color=color_group),size=1)+
  theme_bw()+
  theme(legend.position = "none")+
  scale_color_manual(values=c("grey", "#fc9272","#bcbddc"))+
  xlab("Propotion of meCpG in promoter regions of R9.4.1")+
  ylab("Propotion of meCpG in promoter region of R10.4")+
  geom_smooth(method = "lm", se = F, color = 'dark grey') +
  stat_cor(method = "pearson", aes(x=R9.4.1/100, y=R10.4/100))

p_a