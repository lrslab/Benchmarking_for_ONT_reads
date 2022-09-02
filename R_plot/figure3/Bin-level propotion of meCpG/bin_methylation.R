library(circlize) 

Data <- read.table("methylation_500k.txt", header = T)


#Data <- na.omit(Data)
Data[is.na(Data)]<-0

Data["gDNA941"] <- Data["gDNA941"] / 100
Data["gDNA104"] <- Data["gDNA104"] / 100

gDNA_r9 <- Data[c("chr", "start", "end", "gDNA941")]
gDNA_r10 <- Data[c("chr", "start", "end", "gDNA104")]

gDNA_r9_ave = mean(gDNA_r9$gDNA941)
gDNA_r10_ave = mean(gDNA_r10$gDNA104)

circos.clear()
circos.par(gap.degree = c(1,1,1,1,1,1,1,1,1,1,
                          1,1,1,1,1,1,1,1,1,1,
                          1,1,1,5), start.degree = 90)

cytoband = read.table("hg38_genome.size", colClasses = c("character", "numeric","numeric"), sep = "\t")

circos.initializeWithIdeogram(cytoband, sort.chr = FALSE, plotType = c("axis", "labels"))
text(0, 0, "Methylation", cex = 1)

circos.genomicTrack(gDNA_r10, track.height = 0.08,
                    bg.col = '#EEEEEE6E', bg.border = NA,
                    panel.fun = function(region, value, ...) {
                      circos.genomicLines(region, value,lwd = 0.1,col = "#fc9272")
                      circos.lines(c(0, max(region)), c(gDNA_r10_ave,gDNA_r10_ave), col = "#00000040", lwd = 0.15, lty = 2)
                      circos.lines(c(0, max(region)), c(0,0), col = "#00000040", lwd = 0.15, lty = 2)
                    })

circos.yaxis(side ="left", labels.cex = 0.25,lwd = 0.15,track.index=2,
             sector.index = "chr1", tick.length = convert_x(0.3, "mm"))

circos.genomicTrack(gDNA_r9, track.height = 0.08,
                    bg.col = '#EEEEEE6E', bg.border = NA,
                    panel.fun = function(region, value, ...) {
                      circos.genomicLines(region, value, lwd = 0.1,col = "#bcbddc") #
                      circos.lines(c(0, max(region)), c(gDNA_r9_ave,gDNA_r9_ave), col = "#00000040", lwd = 0.15, lty = 2)
                      circos.lines(c(0, max(region)), c(0,0), col = "#00000040", lwd = 0.15, lty = 2)
                    })

circos.yaxis(side ="left", labels.cex = 0.25,lwd = 0.15,track.index=3,
             sector.index = "chr1", tick.length = convert_x(0.3, "mm"))






