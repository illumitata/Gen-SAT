library(ggplot2)
library(reshape)

r_40_80 <- read.csv("/home/illumitata/Studia/IntOblicz/projekt1/datasets/diff_pop/jan-40x-80k_roulette_result.csv", head=F, sep=',')
t_40_80 <- read.csv("/home/illumitata/Studia/IntOblicz/projekt1/datasets/diff_pop/jan-40x-80k_tournament_result.csv", head=F, sep=',')

r_40_80 <- read.csv("/home/illumitata/Studia/IntOblicz/projekt1/datasets/diff_pop/jan-50x-100k_roulette_result.csv", head=F, sep=',')
t_40_80 <- read.csv("/home/illumitata/Studia/IntOblicz/projekt1/datasets/diff_pop/jan-50x-100k_tournament_result.csv", head=F, sep=',')

# failed runs
r_failed <- sum(r_40_80$V7)
t_failed <- sum(t_40_80$V7)

unique_pop_size_r_40_80 <- (unique(r_40_80$V4))
unique_pop_size_t_40_80 <- (unique(t_40_80$V4))

r_means <- c()
r_medians <- c()
t_means <- c()
t_medians <- c()

for (pop_size in unique_pop_size_r_40_80) {
  r_means <- c(r_means, mean((r_40_80[r_40_80$V4 == pop_size,])$V5))
  r_medians <- c(r_medians, median((r_40_80[r_40_80$V4 == pop_size,])$V5))
}

for (pop_size in unique_pop_size_t_40_80) {
  t_means <- c(t_means, mean((t_40_80[t_40_80$V4 == pop_size,])$V5))
  t_medians <- c(t_medians, median((t_40_80[t_40_80$V4 == pop_size,])$V5))
}



data_to_plot <- data.frame(size_of_pop = unique_pop_size_r_40_80,
                          r_means = r_means, 
                          r_medians = r_medians,
                          t_means = t_means, 
                          t_medians = t_medians)

data_to_plot.m <- melt(data_to_plot, id="size_of_pop")

my_graf <- ggplot(data = data_to_plot.m, aes(x = size_of_pop, y = value, color=variable)) +
                  geom_line(size = 1.0, position=position_dodge(width=0.8)) +
                  theme(legend.justification = c(0, 1), legend.position = c(0, 1), text=element_text(size=10, family="Arial")) +
                  labs(title = "Czas trwania algorytmu genetycznego", 
                       subtitle = "(40 zmiennych, 80 klauzul)", 
                       x = "Rozmiar populacji", 
                       y = "Czas trwania(s)", 
                       color = "Wartość\n", caption="(wyk.1)") +
                       scale_color_manual(labels = c("Średnia dla metody ruletki", "Mediana dla metody ruletki", "Średnia dla metody turniejowej", "Mediana dla metody turniejowej"),
                                          values = c("#FF7700", "#FF0000", "#09C4E8", "#0E00E8"))+
                      guides(colour = guide_legend(override.aes = list(size=5)))

my_graf <- my_graf + scale_x_continuous(breaks=unique_pop_size_r_40_80)

ggsave(file="/home/illumitata/Studia/IntOblicz/projekt1/article/50x100k.png", dpi=300)
# my_graf
