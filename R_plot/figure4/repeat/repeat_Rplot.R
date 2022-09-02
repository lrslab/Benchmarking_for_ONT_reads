library(ggplot2)

data <- read.table("uncoverage_class.txt", header = T)
data$sequencing = factor(data$sequencing, levels=c('bulk_cells_(R10.4)',
                                             'bulk_cells_(R9.4.1)',
                                             'single_cell_(R10.4)',
                                             'single_cell_(R9.4.1)'))

data$repeat. = factor(data$repeat., levels=c('Satellite', 'LINE', 'SINE', 'LTR', 'DNA', 'Simple_repeat',
                                             'Low_complexity', 'RC/Helitron', 'Unknown'))

ggplot(data, mapping = aes(x = factor(repeat.), y = length, fill = sequencing)) + 
  geom_bar(stat = 'identity', position = 'dodge', width=0.7)+ 
  xlab("") + 
  theme_bw() +
  scale_fill_manual(values=c("bulk_cells_(R10.4)" = "#fc9272",
                             "bulk_cells_(R9.4.1)" = "#bcbddc",
                             "single_cell_(R10.4)" = "#fec44f",
                             "single_cell_(R9.4.1)" = "#9ecae1",
                             "single_cell_(NGS)" = "#778899"))


