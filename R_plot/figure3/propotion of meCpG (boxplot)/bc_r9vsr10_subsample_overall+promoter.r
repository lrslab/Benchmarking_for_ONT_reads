library(ggplot2)

process_df<-function(filename){
  WLM_d0=read.table(filename, header = F)
  colnames(WLM_d0)=c("R_seed", "overall", "promoter_all")
  WLM_d0$color_group=substr(WLM_d0$R_seed,start=4,stop=7)
   return(WLM_d0)
}

r941_20M=process_df("bc_r941_5mc_20M_sums100.txt")
r941_20M$size=as.factor(20)
r104_20M=process_df("bc_r104_5mc_20M_sums100.txt")
r104_20M$size=as.factor(20)
r941_50M=process_df("bc_r941_5mc_50M_sums100.txt")
r941_50M$size=as.factor(50)
r104_50M=process_df("bc_r104_5mc_50M_sums100.txt")
r104_50M$size=as.factor(50)
r941_125M=process_df("bc_r941_5mc_125M_sums100.txt")
r941_125M$size=as.factor(125)
r104_125M=process_df("bc_r104_5mc_125M_sums100.txt")
r104_125M$size=as.factor(125)
r941_250M=process_df("bc_r941_5mc_250M_sums100.txt")
r941_250M$size=as.factor(250)
r104_250M=process_df("bc_r104_5mc_250M_sums100.txt")
r104_250M$size=as.factor(250)
r941_500M=process_df("bc_r941_5mc_500M_sums100.txt")
r941_500M$size=as.factor(500)
r104_500M=process_df("bc_r104_5mc_500M_sums100.txt")
r104_500M$size=as.factor(500)
r941_3G=process_df("bc_r941_5mc_3G_sums100.txt")
r941_3G$color_group=substr(r941_3G$R_seed,start=4,stop=7)
r941_3G$size=as.factor(3000)
r104_3G=process_df("bc_r104_5mc_3G_sums100.txt")
r104_3G$size=as.factor(3000)

r941to104=read.table("bc_r941tor104_5mc_sum100.txt",header = F)
colnames(r941to104)=c("R_seed", "overall", "promoter_all")
r941to104_overall_mean=mean(r941to104$overall)
r941to104_promoter_mean=mean(r941to104$promoter_all)

r941to104$color_group=substr(r941to104$R_seed,start=4,stop=7)
r941to104$size=as.factor(12886)


bc_sub=rbind(r941_20M,r104_20M,r941_50M,r104_50M,r941_125M,r104_125M,r941_500M,r104_500M,r941_3G,r104_3G,r941to104)
bc_sub$subsample_group=paste(bc_sub$color_group,bc_sub$size)

pbc_sub_all=ggplot(data=bc_sub)+ 
  geom_boxplot(aes(x=size, y=overall,group=subsample_group,fill=color_group))+
  geom_boxplot(aes(x=size, y=promoter_all,group=subsample_group,fill=color_group))+
  #geom_boxplot(aes(x=subsample_group, y=promoter_all,group=subsample_group))+
  geom_hline(aes(yintercept=0.6744307975605757),color="#bcbddc",linetype="dashed")+
  #geom_hline(aes(yintercept=0.675032510415986),color="#bcbddc",linetype="dashed")+
  geom_hline(aes(yintercept=0.6770214288656671),color="#fc9272",linetype="dashed")+
  geom_hline(aes(yintercept=0.5461459899461588),color="#bcbddc",linetype="dashed")+
  geom_hline(aes(yintercept=0.5253522548279378),color="#fc9272",linetype="dashed")+
  scale_fill_manual(values=c("r941"="#bcbddc","r104"="#fc9272"),
                    breaks=c("r941","r104"),
                    labels=c("HCC78 Bulk cells (R10.4)","HCC78 Bulk cells (R9.4.1)"))+
  ylab("Propotion of meCpG")+
  xlab("Yield(Mb)")+
  #ylim(0.6, 0.75)+
  theme_bw()+
  guides(fill=guide_legend(title=NULL))+
  theme(legend.position="none")
  
pbc_sub_all
ggsave(plot=pbc_sub_all,"bc_r9vsr10_subsample_overall+promoter.pdf")

